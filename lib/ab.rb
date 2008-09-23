class Ab < ActiveRecord::Base

 def self.click!(stub)
   self.update_all("click_count = click_count + 1", ["stub = ?", stub])
 end

 def self.display!(testname, version)
   ab = self.find_test(testname, version)
   ab.display_count += 1
   ab.save
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

 def before_create
   self.stub = random_string(10) if !self.stub?
 end

protected

 def self.find_test(testname, version)
   ab = self.find(:first, :conditions => ["testname = ? and version = ?", testname, version])
   return ab if ab

   self.new(:testname => testname, :version => version)
 end

 def random_string(len)
   chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
   newpass = ""
   1.upto(len) { |i| newpass << chars[rand(chars.size-1)] }
   return newpass
 end

end