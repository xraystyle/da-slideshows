require 'rails_helper'
# require 'static_pages_views_shared.rb'

RSpec.describe "static_pages/home.html.haml", :type => :view do
# pending "add some examples to (or delete) #{__FILE__}"
	include_context "shared_examples"
	describe "for logged out users" do

		it 'has h1 "Hello World!"' do
			render template: "static_pages/home", layout: "layouts/application"
			subject { page }
			expect(rendered).to have_selector("h1", text: "Hello World!")
			expect(rendered).to have_title("DA Slideshows")
			# its(:title){ should eq "DA Slideshows" }
		end
	  
	end

end
