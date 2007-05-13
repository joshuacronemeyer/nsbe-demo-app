class CreateRankings < ActiveRecord::Migration
  def self.up
    create_table :rankings do |t|
      t.column :company_id, :int
      t.column :job_id, :int
      t.column :count, :int
    end
  end

  def self.down
    drop_table :rankings
  end
end
