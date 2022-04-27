require 'action_messenger/sms_providers/base'
require 'action_messenger/sms_providers/test'

module ActionMessenger
  module SMSProviders
    extend ActiveSupport::Concern

    included do
      cattr_accessor :raise_delivery_errors
      cattr_accessor :perform_deliveries, default: true
      cattr_accessor :deliver_later_queue_name, default: :shore_messengers

      class_attribute :services, default: {}.freeze
      class_attribute :service, default: :test

      add_service :test, SMSProviders::Test
    end

    module ClassMethods
      delegate :services, :services=, to: SMSProviders::Test

      def add_service(symbol, klass, default_options = {})
        class_attribute(:"#{symbol}_settings") unless respond_to?(:"#{symbol}_settings")
        public_send(:"#{symbol}_settings=", default_options)
        self.services = services.merge(symbol.to_sym => klass).freeze
      end

      def wrap_service_behavior(short_message) # :nodoc:
        # service ||= service
        # mail.delivery_handler = self
        raise 'SMS provider cannot be nil' if service.nil?

        case service
        when NilClass
          raise 'Delivery method cannot be nil'
        when Symbol
          if klass = services[service]
            short_message.service(klass, send(:"#{service}_settings") || {})
          else
            raise "Invalid delivery method #{service.inspect}"
          end
        else
          short_message.service(method)
        end
        short_message.perform_deliveries    = perform_deliveries
        short_message.raise_delivery_errors = raise_delivery_errors
      end
    end

    def wrap_service_behavior!
      self.class.wrap_service_behavior(short_message)
    end
  end
end
