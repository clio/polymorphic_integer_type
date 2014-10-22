class CreateRails4TargetTable < ActiveRecord::Migration

  def up
    create_table :rails4_targets do |t|
      t.integer :scope_tester_id
      t.integer :scope_tester_type
      t.boolean :extra
    end
  end

  def down
    drop_table :rails4_targets
  end

end


