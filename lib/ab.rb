class Ab < ActiveRecord::Base

  def self.click!(stub)
    self.update_all("click_count = click_count + 1", ["stub = ?", stub])
  end

  def self.displayed!(stub)
    self.update_all("display_count = display_count + 1", ["stub = ?", stub])
  end

  def self.display!(testname, version)
    ab = self.find_test(testname, version)
    self.displayed!(ab.stub)
    ab
  end

  def self.for_testname(testname, version_count, mod_by)
    abs = self.find(:all, :conditions => {:testname => testname})
    if abs.size == 0
      ab = self.display!(testname, 0)
    elsif abs.size == 1
      ab = abs.first
      ab.increment!("display_count")
    else
      version_wanted = mod_by % version_count
      ab = abs.select{|ab| version_wanted == ab.version }.first
      ab ||= self.display!(testname, version_wanted)
    end
    ab
  end

  def self.for_click_count(testname, increment_display = true)
    ab = self.find_test(testname, 0)
    self.displayed!(ab.stub) if increment_display
    ab
  end

  def before_create
    self.stub = random_string(10) if !self.stub?
  end

  def self.stub_for_test_or_create(testname, version)
    key = "ab_stub:#{testname}_v:#{version}"
    fb_user = memcache_me(key) {
      ab = self.find(:first,
                     :select => "stub"
                     :conditions => ["testname = ? and version = ?",
                                      testname,
                                      version])
      ab ||= self.create(:testname => testname, :version => version)
      ab.stub
    }
  end

  def self.find_test(testname, version)
    key = "ab:#{testname}_v:#{version}"
    fb_user = memcache_me(key) {
      ab = self.find(:first,
                    :conditions => ["testname = ? and version = ?",
                                     testname,
                                     version])
      ab ||= self.create(:testname => testname, :version => version)
      ab
    }
  end

  def after_save
    Cache.delete("ab:#{self.testname}_v:#{self.version}")
    Cache.delete("ab_stub:#{self.testname}_v:#{self.version}")
  end

protected

  def random_string(len)
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    newpass = ""
    1.upto(len) { |i| newpass << chars[rand(chars.size-1)] }
    return newpass
  end

end