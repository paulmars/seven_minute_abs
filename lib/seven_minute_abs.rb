module SevenMinuteAbs

  # before_filter :ab_testing

  def ab_testing
    Ab.click!(params[:ab]) if params[:ab]
    @ab_version = Time.now.to_i%2  #only supports a/b testing, 2 versions max
  end

end