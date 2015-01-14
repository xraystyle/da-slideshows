class AddIndexToSlideshows < ActiveRecord::Migration
  def change
  	add_index :slideshows, :seed
  end
end
