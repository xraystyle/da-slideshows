class RenameJoinTable < ActiveRecord::Migration
  def change

  	rename_table :slideshows_deviations, :deviations_slideshows

  end
end
