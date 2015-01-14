require 'rails_helper'

RSpec.describe Slideshow, :type => :model do
  
  	let(:user) { User.new(email: "email@example.com", password: "foobar", password_confirmation: "foobar") }
	before do
		user.save
		# @slideshow = user.build_slideshow(seed: "DFE52DC8-726A-2C57-FEA4-6A61E9DEA8B0")
		# puts user.id
	end

	before { @slideshow = Slideshow.new(seed: "DFE52DC8-726A-2C57-FEA4-6A61E9DEA8B0") }

	subject { @slideshow }

	describe "should respond to the following methods" do

		it { should respond_to(:seed) }

		# Relationships to User and Deviations
		# it { should respond_to(:user) }
		it { should respond_to(:deviations) }

	end

	describe "when created properly" do
	  it { should be_valid }
	end

	describe "when seed is not present" do
		before { @slideshow.seed = "" }
		it { should_not be_valid }
	end


	describe "when seed format is invalid" do
		before { @slideshow.seed = "HolyMoses it DOES taste like Grandma" } # That string is 36 chars, same as seed UUID
		it { should_not be_valid }
	end


	# describe "when creating a slideshow" do
	# 	before { @slideshow.save }			  
	# 	it "should be associated with a user" do
	# 		expect(@slideshow.id).to eq(user.slideshow.id)
	# 	end
	# end

	# describe "when it has no user_id" do
	# 	before { @slideshow.user_id = nil }
	#   	it { should_not be_valid }
	# end

	# describe "when the associated user is destroyed" do
	# 	before do
	# 		user.slideshow.save
	# 		user.destroy
	# 	end
	# 	it "should self-destruct" do
	# 		expect(subject.destroyed?).to eq(true)
	# 	end
	  
	# end

end
