class CreatePlantTable < ActiveRecord::Migration[5.2]

  def up
    create_table :plants do |t|
      t.string :name
      t.string :type
      t.string :kind
      t.integer :owner_id
    end
  end

  def down
    drop_table :plants
  end

end

