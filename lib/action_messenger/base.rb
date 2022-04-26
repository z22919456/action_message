require 'active_support/core_ext/string/inflections'
require 'active_support/core_ext/hash/except'
require 'active_support/core_ext/module/anonymous'
require 'action_messenger/log_subscriber'

module ActionMessenger
  class Base < AbstractController::Base
    abstract!

    include AbstractController::Rendering
    include AbstractController::Logger
    include AbstractController::Callbacks

    include ActionView::Layouts

    class << self
      def register_observers(*observers)
        observers.flaten.compact.each { |observer| register_observer(observer) }
      end

      def unrgister_observers(*observers)
        observers.flatten.compact.each { |observer| unregister_observer(observer) }
      end

      def register_observer(observer)
        Message.register_observer(observer_class_for(observer))
      end

      class_attribute :default_params
      self.default_params = {
        adapter: {
          name: :test,
          credentials: {}
        }
      }

      # Sets the defaults through app configuration:
      # config.action_messenger.default()
      #
      # Aliased by ::default_options=
      #
      def default(value = nil)
        self.default_params = default_params.merge(value).freeze if value
        default_params
      end
      # Allows to set defaults through app configuration:
      # config.action_messenger = { charset: 'ISO-8859-1' }
      #
      alias default_options= default

      def base_paths
        %w[
          app/views
          app/views/messages
          app/views/mailers
          app/views/application
          app/views/layouts
        ].freeze
      end

      protected

      def method_missing(method_name, *args) # :nodoc:
        if action_methods.include? method_name.to_s
          MessageDelivery.new(self, method_name, *args)
        else
          super
        end
      end
    end

    attr_internal :message
    attr_accessor :template_name, :template_path

    def initialize
      super
      @_message_was_called = false
      @_message = Message.new
    end

    def sms(params = {}, &block)
      raise ArgumentError, 'You need to provide at least a receipient' if params[:to].blank?
      return message if @_message_was_called && !block

      self.template_name = params[:template_name].presence || template_name
      self.template_path = params[:template_path].presence || template_path

      @_message_was_called = true

      # elookup_context.view_paths = (lookup_context.view_paths.to_a + self.class.base_paths).flatten.uniq

      message.to = params[:to]
      message.debug = params[:debug]
      message.message = params[:message] || render(full_template_path)
      message.options = params.reject! { |p| %i[to debug message].include?(p) }

      message
    end

    def process(method_name, *args)
      payload = {
        messenger: self.class.name,
        action: method_name
      }

      self.template_path ||= self.class.name.underscore
      self.template_name ||= method_name

      ActiveSupport::Notifications.instrument('process.action_messenger', payload) do
        super
        @_message = NullMessage.new unless @_message_was_called
      end
    end

    def full_template_path
      [template_path, template_name].join('/')
    end

    class NullMessage # :nodoc:
      def body
        ''
      end

      def header
        {}
      end

      def respond_to?(_string, _include_all = false)
        true
      end

      def method_missing(*_args)
        nil
      end
    end

    ActiveSupport.run_load_hooks(:action_messenger, self)
  end
end
