class CreateProfileTable < ActiveRecord::Migration[5.0]

  def up
    create_table :profiles do |t|
      t.integer :person_id
      t.integer :profile_history_id
    end
  end

  def down
    drop_table :profiles
  end

end


