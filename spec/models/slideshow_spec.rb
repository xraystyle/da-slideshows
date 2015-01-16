require 'rails_helper'

RSpec.describe Slideshow, :type => :model do
  
  	let(:user) { FactoryGirl.create(:user) }
	before do
		@slideshow = FactoryGirl.build(:slideshow)
		puts @slideshow.seed
	end

	subject { @slideshow }

	describe "should respond to the following methods" do

		it { should respond_to(:seed) }

		# Relationship to Deviations
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

	describe "when seed already exists" do
		before do
			duplicate_slideshow = @slideshow.dup
			duplicate_slideshow.save		  
		end
		it { should_not be_valid }
	end

end






