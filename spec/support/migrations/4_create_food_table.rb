class CreateFoodTable < ActiveRecord::Migration[5.0]

  def up
    create_table :foods do |t|
      t.string :name
    end
  end

  def down
    drop_table :foods
  end

end


