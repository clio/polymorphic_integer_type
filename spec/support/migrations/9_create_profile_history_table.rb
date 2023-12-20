class CreateProfileHistoryTable < ActiveRecord::Migration[5.0]

  def up
    create_table :profile_histories do |t|
    end
  end

  def down
    drop_table :profile_histories
  end

end


