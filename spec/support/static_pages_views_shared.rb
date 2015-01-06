RSpec.shared_context "shared_examples" do

	def page_title(page)
		expect(page).to (have_title("DA Slideshows"))
	end

	
end
