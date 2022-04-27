module ActionMessage
  class MessageDelivery
    attr_reader :messenger_class, :action, :args

    def initialize(messenger_class, action, *args)
      @messenger_class = messenger_class
      @action = action
      @args = args
    end

    def messenger_instance
      processed_messenger.send(action, *@args)
    end

    def deliver_now
      processed_messenger.send(action, *@args).deliver
    end

    def deliver_later(options = {})
      enqueue_delivery :deliver_now, options
    end

    protected

    def processed_messenger
      # message_delivery with template and all messenger need
      @processed_messenger ||= @messenger_class.new.tap do |messenger_instance|
        messenger_instance.process @action, *@args
      end
    end

    def enqueue_delivery(delivery_method, options = {})
      args = @messenger_class.name, @action.to_s, delivery_method.to_s, *@args
      ::ActionMessage::DeliveryJob.set(options).perform_later(*args)
    end
  end
end
