class ModifyUsersTable < ActiveRecord::Migration

	def up
		add_column :users, :seed, :string
		remove_column :users, :slideshow_id
	end

	def down
		remove_column :users, :seed
		add_column :users, :slideshow_id, :integer
	end

end
