require 'rails_helper'

describe "Visiting the root path" do

	describe "for logged out users" do

		it "routes them to the home page" do
			expect(get: "/").to route_to("static_pages#home")
		end
	  
	end
  
end

