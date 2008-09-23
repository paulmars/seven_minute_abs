class Ab < ActiveRecord::Base

 def self.click!(stub)
   ab = self.find_by_stub(stub)
   ab.click_count += 1
   ab.save
   ab
 end

 def self.display!(testname, version)
   ab = self.find_test(testname, version)
   ab.display_count += 1
   ab.save
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