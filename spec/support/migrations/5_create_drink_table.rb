class CreateDrinkTable < ActiveRecord::Migration

  def up
    create_table :drinks do |t|
      t.string :name
    end
  end

  def down
    drop_table :drinks
  end

end
