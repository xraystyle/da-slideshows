class CreateDeviations < ActiveRecord::Migration
  def change
    create_table :deviations do |t|
      t.string :url
      t.string :title
      t.string :author
      t.boolean :mature
      t.string :src
      t.string :thumb
      t.string :orientation
      t.string :uuid

      t.timestamps
    end
  end
end
