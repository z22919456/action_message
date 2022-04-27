module ActionMessage
  module SMSProviders
    class Test < Base
      def initialize(params = {})
        super(params)
      end

      def send_message(message, params = {})
        puts "SMS TEST: send short message to #{params[:to]}, context:"
        puts "options"
        puts params
        puts message
        puts "Completed!"
        super(message, params)
      end
    end
  end
end
