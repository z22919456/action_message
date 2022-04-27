module ActionMessage
  # include ActionMessage::Adapters

  class ShortMessage
    attr_accessor :action, :message, :to, :debug, :options, :raise_delivery_errors
    attr_reader :sms_provider

    def sms_provider(method = nil, settings = {})
      @sms_provider = method.new(settings)
    end

    # Initialize the observers and interceptors arrays
    @@delivery_notification_observers = []

    # You can register an object to be informed of every short message that is sent through
    # this method.
    #
    # Your object needs to respond to a single method #delivered_message(message)
    # which receives the short message that is sent.
    def self.register_observer(observer)
      @@delivery_notification_observers << observer unless @@delivery_notification_observers.include?(observer)
    end

    # Unregister the given observer, allowing short message to resume operations
    # without it.
    def self.unregister_observer(observer)
      @@delivery_notification_observers.delete(observer)
    end

    def inform_observers
      @@delivery_notification_observers.each do |observer|
        observer.delivered_message(self)
      end
    end

    def self.delivery_adapters; end

    def debug?
      !!@debug
    end

    def deliver
      ActiveSupport::Notifications.instrument('deliver.action_message', { messagage: message, to: to }) do
        @sms_provider.send_message(message, options.merge(to: to))
      end
      inform_observers
    end
  end
end
