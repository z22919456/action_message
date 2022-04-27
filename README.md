# ActionMessenger

ActionMessage reference to [dballona/actionmessage](https://github.com/dballona/actionmessage), is heavily-inspired on ActionMailer.
It's a gem for sending SMS/Text messages like we do for sending e-mails on ActionMailer.

## Setup

Install it using bundler:

```ruby
# Gemfile
gem 'action_messenger'
```

## Config
Place this on your environment file or application.rb

```ruby

# Setting logger, default is Rails.logger
config.action_messenger.logger = Rails.logger

# Setting short message service provider, default is setting.
#
# Highly recommended place this on the environment files, and set 
# development sms_provider to :test it can save your money
config.action_messenger.sms_provider = :test 


```

### SMS Provider
Default provider is `test`, I also made a provider, use Mitake(山竹簡訊) api.
You can add [mitake_sms](http://) in Taiwan 🇹🇼

you also can create your provider, by implement `ActionMessenger::SMSProviders::Base` and add provider follow by `ActionMessenger::Base.add_provider(symbol, YourProvider, provider_setting)`

## Usage

In order to generate your message class, you can either place this code
under app/messengers/welcome_message.rb or just use generators by running
the following command: `rails g messenger Welcome send_welcome_sms`

```ruby
class WelcomeMessenger < ActionMessenger::Base
  def send_welcome_sms(name, phone_number_to_send_message)
    @name = name
    sms(to: phone_number_to_send_message)
  end

  # Inline message example, body parameter has preference compared
  # to a text.erb template.
  def welcome_with_inline_body(name, phone_number_to_send_message)
    @name = name
    sms(to: phone_number_to_send_message, message: 'Inline message')
  end
end
```

### Views

If you want to use template, add this file to `app/view/messenger/{your_messenger_name}/{method_name}.erb`

```html
Welcome, <%= @name %>!
```

### Callbacks
You can specify callbacks using `before_action` and `after_action` for configuring your messages.

```ruby
class WelcomeMessenger
  before_action :set_default_message
  after_action :log_message

  private

  def set_default_message
    ...
  end

  def log_message
    ...
  end
end

```

And to send is really simple!

```ruby
name = 'John Doe'
phone = '0987654321'

# To send right away:
WelcomeMessage.send_welcome_sms(name, phone).deliver_now

# To send through a background job
WelcomeMessage.send_welcome_sms(name, phone).deliver_later

```