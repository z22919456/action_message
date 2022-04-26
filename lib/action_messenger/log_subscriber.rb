require 'active_support/log_subscriber'

module ActionMessenger
  class LogSubscriber < ActiveSupport::LogSubscriber
    def deliver(_event)
      info do
        # preform_adapter = event.payload[:preform_deliveries]
      end
    end

    def process(event)
      debug do
        messenger = event.payload[:messenger]
        action = event.payload[:action]
        "#{messenger}##{action}: processed SMS in #{event.duration.round(1)}ms"
      end
    end

    def logger
      ActionMessenger::Base.logger || Rails.logger
    end
  end
end

ActionMessenger::LogSubscriber.attach_to :action_messenger
