require 'abstract_controller'

require 'action_messenger/sms_providers'
require 'action_messenger/base'
require 'action_messenger/delivery_job'
require 'action_messenger/interceptor'
require 'action_messenger/short_message'
require 'action_messenger/message_delivery'
require 'action_messenger/version'
require 'action_messenger/railtie'

require 'active_support'
require 'active_support/rails'
require 'active_support/core_ext/class'
require 'active_support/core_ext/module/attr_internal'
require 'active_support/core_ext/string/inflections'
require 'active_support/lazy_load_hooks'

module ActionMessenger
  extend ::ActiveSupport::Autoload

  autoload :Base
  autoload :DeliveryJob
  autoload :MessageDelivery
  autoload :Messeng

  def self.eager_load!
    super
    Base.descendants.each do |messenger|
      messenger.eager_load! unless messenger.abstract?
    end
  end
end

autoload :Mime, 'action_dispatch/http/mime_type'

ActiveSupport.on_load(:action_view) do
  ActionView::Base.default_formats ||= Mime::SET.symbols
  ActionView::Template::Types.delegate_to Mime
end
