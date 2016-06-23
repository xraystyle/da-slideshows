class AddUuidToUsersTable < ActiveRecord::Migration
  def up
    add_column :users, :uuid, :string, default: nil
  end

  def down
    remove_column :users, :uuid
  end
end
