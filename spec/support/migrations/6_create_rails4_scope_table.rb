class CreateRails4ScopeTable < ActiveRecord::Migration

  def up
    create_table :rails4_scopes do |t|
    end
  end

  def down
    drop_table :rails4_scopes
  end

end


