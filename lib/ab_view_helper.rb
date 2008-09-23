module AbViewHelper

  # <% ab_test("linkcolor") do |test,version|%>
  #   <% if version == 0 %>
  #     <%= link_to "Blue version", users_path(:ab => test.stub), {:style => "color:blue"} %>
  #   <% elsif version == 1 %>
  #     <%= link_to "Orange version", users_path(:ab => test.stub), {:style => "color:orange"} %>
  #   <% else %>
  #     <%= link_to "Ab testing not enabled",  users_path() %>
  #   <% end %>
  # <% end %>

  def ab_test(testname, &block)
    ab = Ab.display!(testname, @ab_version) if @ab_version
    version = ab ? ab.version : nil
    content_tag = capture(ab, version, &block)
    block_is_within_action_view?(block) ? concat(content_tag, block.binding) : content_tag
  end

end