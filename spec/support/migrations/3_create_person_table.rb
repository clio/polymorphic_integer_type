class CreatePersonTable < ActiveRecord::Migration

  def up
    create_table :people do |t|
      t.string :name
    end
  end

  def down
    drop_table :people
  end

end
