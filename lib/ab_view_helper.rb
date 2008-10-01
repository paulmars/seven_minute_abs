module AbViewHelper

  # <% ab_test("linkcolor") do |test,version| %>
  #   <% if version == 0 %>
  #     <%= link_to "Blue version", "new", {:style => "color:blue"} %>
  #   <% elsif version == 1 %>
  #     <%= link_to "Orange version", "new?ab=#{test.stub}", {:style => "color:orange"} %>
  #   <% else %>
  #     <%= link_to "Orange version", "new", {:style => "color:orange"} %>
  #   <% end %>
  # <% end %>

  def ab_test(testname, version_count, &block)
    testname = testname.gsub(/\W/,'_')
    ab = Ab.for_testname(testname, version_count, @ab_version)
    version = ab ? ab.version : nil
    content_tag = capture(ab, version, &block)
    block_is_within_action_view?(block) ? concat(content_tag, block.binding) : content_tag
  end

  def click_count(testname, &block)
    testname = "click_count:#{testname.gsub(/\W/,'_')}"
    ab = Ab.for_click_count(testname, @inc_ab_display_count)
    content_tag = capture(ab, &block)
    block_is_within_action_view?(block) ? concat(content_tag, block.binding) : content_tag
  end

end