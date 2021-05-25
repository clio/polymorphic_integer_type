class CreateActivityTable < ActiveRecord::Migration[5.0]

  def up
    create_table :activities do |t|
      t.string :name
    end
  end

  def down
    drop_table :activities
  end

end


