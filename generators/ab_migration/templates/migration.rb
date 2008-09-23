class AbMigration < ActiveRecord::Migration
  def self.up
    create_table "abs", :force => true do |t|
      t.string  "testname"
      t.integer "version"
      t.integer "display_count", :default => 0
      t.integer "click_count",   :default => 0
      t.string  "stub"
    end

    add_index "abs", ["testname"], :name => "testname"
    add_index "abs", ["stub"], :name => "stub"
  end

  def self.down
    drop_table :abs
  end
end
