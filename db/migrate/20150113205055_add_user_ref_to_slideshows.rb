class AddUserRefToSlideshows < ActiveRecord::Migration
  def change
    add_reference :slideshows, :user, index: true
  end
end
