class RemoveUserIdFromSlideshows < ActiveRecord::Migration
  def change
  	remove_reference :slideshows, :user, index: true
  end
end
