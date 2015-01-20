require 'rails_helper'

RSpec.describe Slideshow, :type => :model do
  
  	let(:user) { FactoryGirl.create(:user) }
  	let(:deviation) { FactoryGirl.create(:deviation) }
  	let(:boobs) { FactoryGirl.create(:mature) }
	
	before { @slideshow = FactoryGirl.build(:slideshow) }

	subject { @slideshow }

	describe "should respond to the following methods" do

		it { should respond_to(:seed) }
		it { should respond_to(:mature_results) }

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

	describe "a deviation added to a slideshow" do
		before do
		  @slideshow.save
		  @slideshow.deviations << deviation
		end

		it "should then be retrievable" do
			expect(@slideshow.deviations).to include(deviation)
		end
	  
	end


	describe "with mature results" do
		before do
		  @slideshow.save
		  @slideshow.deviations << boobs
		end

		it "should not include mature deviations by default" do
			expect(@slideshow.deviations).not_to include(boobs)
		end
	end

end






