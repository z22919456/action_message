require 'active_job/railtie'
require 'action_message'
require 'rails'

module ActionMessage
  class Railtie < Rails::Railtie # :nodoc:
    config.action_message = ActiveSupport::OrderedOptions.new
    config.eager_load_namespaces << ActionMessage

    initializer 'action_message.logger' do
      ActiveSupport.on_load(:action_message) { self.logger ||= Rails.logger }
    end

    config.after_initialize do |app|
      ActiveSupport.on_load(:action_message) do
        options = app.config.action_message
        options.each { |k, v| send("#{k}=", v) }
      end
    end
  end
end
