require 'active_job/railtie'
require 'action_messenger'
require 'rails'

module ActionMessenger
  class Railtie < Rails::Railtie # :nodoc:
    config.action_messenger = ActiveSupport::OrderedOptions.new
    config.eager_load_namespaces << ActionMessenger

    initializer 'action_messenger.logger' do
      ActiveSupport.on_load(:action_messenger) { self.logger ||= Rails.logger }
    end

    initializer 'action_messenger.set_configs' do |app|
      options = app.config.action_messenger

      ActiveSupport.on_load(:action_messenger) do
        options.each { |k, v| send("#{k}=", v) }
      end
    end

    config.after_initialize do |app|
      # options = app.config.action_messenger
      # ActionMessenger::Base.logger = options[:logger] || Rails.logger
      # ActionMessenger::Base.default_options = app.config.action_messenger
    end
  end
end
