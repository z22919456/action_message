module ActionMessenger
  include ActionMessenger::Adapters

  class Message
    attr_accessor :action, :message, :to, :debug, :options
    attr_reader :adapter

    def initialize
      @adapter = Adapters.adapter
    end

    # Initialize the observers and interceptors arrays
    @@delivery_notification_observers = []

    # You can register an object to be informed of every message that is sent through
    # this method.
    #
    # Your object needs to respond to a single method #delivered_message(message)
    # which receives the message that is sent.
    def self.register_observer(observer)
      @@delivery_notification_observers << observer unless @@delivery_notification_observers.include?(observer)
    end

    # Unregister the given observer, allowing message to resume operations
    # without it.
    def self.unregister_observer(observer)
      @@delivery_notification_observers.delete(observer)
    end

    def self.inform_observers(mail)
      @@delivery_notification_observers.each do |observer|
        observer.delivered_email(mail)
      end
    end

    def self.delivery_adapters; end

    def debug?
      !!@debug
    end

    def deliver
      if Interceptor.registered_for?(self)
        # TODO: add log
        nil
      else
        # TODO: add logger 'Sending message from "number" to "number"'
        ActiveSupport::Notifications.instrument('deliver.action_messenger', { messagage: message, to: to }) do
          adapter.send_message(message, to: to, options: options)
        end
      end
    end
  end
end
