<% module_namespacing do -%>
class <%= class_name %>Messenger < ActionShortMessage::Base
<% actions.each do |action| -%>
  def <%= action %>
    sms(to: '0987654321', message: "<%= action%>")
  end
<% end -%>
end
<% end -%>
