require 'rails_helper'

RSpec.describe "static_pages/home.html.haml", :type => :view do
# pending "add some examples to (or delete) #{__FILE__}"
	
	describe "for logged out users" do

		it { should have_selector("h1", text: "Hello World!") }
	  
	end

end
