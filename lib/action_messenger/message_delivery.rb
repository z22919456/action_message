module ActionMessenger
  class MessageDelivery
    attr_reader :messenger_class, :action, :args

    def initialize(messenger_class, action, *args)
      @messenger_class = messenger_class
      @action = action
      @args = args
    end

    def deliver_now
      processed_messenger.send(action, @args).deliver
    end

    def deliver_later(_options = {})
      enqueue_delivery :deliver_now, optionse
    end

    protected

    def processed_messenger
      # message_delivery with template and all messenger need
      @processed_messenger ||= @messenger_class.new.tap do |messenger|
        messenger.process @action, *@args
      end
    end

    def enqueue_delivery(delivery_method, options = {})
      args = @message_class.name, @action.to_s, delivery_method.to_s, *@args
      ::ActionMessenger::DeliveryJob.set(options).perform_later(*args)
    end
  end
end
