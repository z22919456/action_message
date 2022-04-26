<% module_namespacing do -%>
class <%= class_name %>Message < ActionMessenger::Base
<% actions.each do |action| -%>
  def <%= action %>
    sms(to: '+11231231234')
  end
<% end -%>
end
<% end -%>
