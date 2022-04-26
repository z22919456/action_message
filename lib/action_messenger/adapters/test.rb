module ActionMessenger
  module Adapters
    class Test < Base
      def initialize(params = {})
        super(params)
      end

      def send_message(message, params = {})
        super(message, params)
      end
    end
  end
end
