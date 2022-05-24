require 'action_short_message/sms_providers/base'
require 'action_short_message/sms_providers/test'

module ActionShortMessage
  module SMSProviders
    extend ActiveSupport::Concern

    included do
      cattr_accessor :raise_delivery_errors
      cattr_accessor :perform_deliveries, default: true
      cattr_accessor :deliver_later_queue_name, default: :shore_messengers

      class_attribute :sms_providers, default: {}.freeze
      class_attribute :sms_provider, default: :test

      add_sms_provider :test, SMSProviders::Test
    end

    module ClassMethods
      delegate :sms_providers, :sms_providers=, to: SMSProviders::Test

      def add_sms_provider(symbol, klass, default_options = {})
        class_attribute(:"#{symbol}_settings") unless respond_to?(:"#{symbol}_settings")
        public_send(:"#{symbol}_settings=", default_options)
        self.sms_providers = sms_providers.merge(symbol.to_sym => klass).freeze
      end

      def wrap_sms_provider_behavior(short_message) # :nodoc:
        raise 'SMS provider cannot be nil' if sms_provider.nil?

        case sms_provider
        when NilClass
          raise 'Delivery method cannot be nil'
        when Symbol
          if klass = sms_providers[sms_provider]
            short_message.sms_provider(klass, send(:"#{sms_provider}_settings") || {})
          else
            raise "Invalid delivery method #{sms_provider.inspect}"
          end
        else
          short_message.sms_provider(method)
        end
        # short_message.perform_deliveries    = perform_deliveries
        short_message.raise_delivery_errors = raise_delivery_errors
      end
    end

    def wrap_sms_provider_behavior!
      self.class.wrap_sms_provider_behavior(short_message)
    end
  end
end
