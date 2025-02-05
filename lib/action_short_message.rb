require 'abstract_controller'

require 'action_short_message/sms_providers'
require 'action_short_message/base'
require 'action_short_message/delivery_job'
require 'action_short_message/interceptor'
require 'action_short_message/short_message'
require 'action_short_message/message_delivery'
require 'action_short_message/version'
require 'action_short_message/railtie'

require 'active_support'
require 'active_support/rails'
require 'active_support/core_ext/class'
require 'active_support/core_ext/module/attr_internal'
require 'active_support/core_ext/string/inflections'
require 'active_support/lazy_load_hooks'

module ActionShortMessage
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
