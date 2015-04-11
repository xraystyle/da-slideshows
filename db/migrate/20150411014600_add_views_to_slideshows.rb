class AddViewsToSlideshows < ActiveRecord::Migration
  def change

        add_column :slideshows, :views, :integer, default: 0

  end
end
