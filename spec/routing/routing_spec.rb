require 'rails_helper'

# RSpec.describe "routing to root", type: :routing do

# 	it "routes logged out users to the index page" do

# 		expect(get: "/").to route_to("static_pages#home")
		
# 	end
  
# end

describe "Visiting the root path" do

	describe "for logged out users" do

		it "routes them to the home page" do
			expect(get: "/").to route_to("static_pages#home")
		end
	  
	end
  
end