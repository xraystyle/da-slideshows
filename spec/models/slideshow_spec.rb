require 'rails_helper'

RSpec.describe Slideshow, :type => :model do
  
	before { @slideshow = Slideshow.new(seed: "DFE52DC8-726A-2C57-FEA4-6A61E9DEA8B0") }

	subject { @slideshow }

	describe "should respond to the following methods" do

		it { should respond_to(:seed) }

		# Relationships to User and Deviations
		it { should respond_to(:user) }
		it { should respond_to(:deviations) }

	end


	describe "should be valid when created properly" do
		it { should be_valid }
	end


	describe "when seed is not present" do
		before { @slideshow.seed = "" }
		it { should_not be_valid }
	end


	describe "when seed format is invalid" do
		before { @slideshow.seed = "This tastes like Grandma." }
		it { should_not be_valid }
	end


end
