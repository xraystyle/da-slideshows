require 'rails_helper'
# require 'static_pages_views_shared.rb'

RSpec.describe "static_pages/home.html.haml", :type => :view do
# pending "add some examples to (or delete) #{__FILE__}"
	include_context "shared_examples"
	describe "for logged out users" do

		it 'has h1 "Hello World!"' do
			render template: "static_pages/home", layout: "layouts/application"
			expect(page_title(rendered)).to be true
			expect(rendered).to have_title("DA Slideshows")
		end
	  
	end

end
