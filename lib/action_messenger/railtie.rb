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

    config.after_initialize do |app|
      ActiveSupport.on_load(:action_messenger) do
        options = app.config.action_messenger
        options.each { |k, v| send("#{k}=", v) }
      end
    end
  end
end
