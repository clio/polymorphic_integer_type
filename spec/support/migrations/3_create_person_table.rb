class CreatePersonTable < ActiveRecord::Migration[5.2]

  def up
    create_table :people do |t|
      t.string :name
    end
  end

  def down
    drop_table :people
  end

end
