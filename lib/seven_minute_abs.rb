module SevenMinuteAbs

  def ab_click_count
    Ab.click!(params[:ab]) if params[:ab]
  end
  
  # future tutorials
  
  # def ab_version_modulation
  #   @ab_version ||= Time.now.to_i
  # end
  # 
  # def increment_display_count?
  #   @inc_ab_display_count = true
  # end
  # 
  # def skip_display_count!
  #   @inc_ab_display_count = false
  # end

end