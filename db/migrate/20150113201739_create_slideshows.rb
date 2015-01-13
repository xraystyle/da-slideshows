class CreateSlideshows < ActiveRecord::Migration
  def change
    create_table :slideshows do |t|
      t.string :seed

      t.timestamps
    end
  end
end
