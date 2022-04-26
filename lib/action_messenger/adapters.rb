require 'action_messenger/adapters/base'
require 'action_messenger/adapters/test'
require 'action_messenger/adapters/twilio'

module ActionMessenger
  module Adapters
    class << self
      def adapter_klass
        @@adapter_klass ||= adapter_params[:name].to_s.capitalize
      end

      def adapter_params
        @@adapter_params ||= ActionMessenger::Base.default_params[:adapter]
      end

      def adapter_credentials
        @@adapter_credentials ||= adapter_params[:credentials]
      end

      def adapter
        @@adapter ||= const_get(adapter_klass).new(adapter_credentials)
      end
    end
  end
end
