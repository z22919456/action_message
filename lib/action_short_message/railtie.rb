require 'active_job/railtie'
require 'action_short_message'
require 'rails'

module ActionShortMessage
  class Railtie < Rails::Railtie # :nodoc:
    config.action_short_message = ActiveSupport::OrderedOptions.new
    config.eager_load_namespaces << ActionShortMessage

    initializer 'action_short_message.logger' do
      ActiveSupport.on_load(:action_short_message) { self.logger ||= Rails.logger }
    end

    config.after_initialize do |app|
      ActiveSupport.on_load(:action_short_message) do
        options = app.config.action_short_message
        options.each { |k, v| send("#{k}=", v) }
      end
    end
  end
end
