class SlideshowsDeviationsJoin < ActiveRecord::Migration
	def change
	
		create_table :slideshows_deviations, id: false do |t|
			t.belongs_to :slideshow, index: true
			t.belongs_to :deviation, index: true
		end

	end
end
