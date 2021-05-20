class CreateDrinkTable < ActiveRecord::Migration[5.0]

  def up
    create_table :drinks do |t|
      t.string :name
    end
  end

  def down
    drop_table :drinks
  end

end
