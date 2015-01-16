class RenameJoinTable < ActiveRecord::Migration
  def change
  	# Join table name was backwards. Rails joins need to be in lexical order,
  	# otherwise they won't be found automatically.
  	rename_table :slideshows_deviations, :deviations_slideshows

  end
end
