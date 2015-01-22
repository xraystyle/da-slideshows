require 'rails_helper'

RSpec.describe Slideshow, :type => :model do
  
  	let(:user) { FactoryGirl.create(:user) }
  	let(:deviation) { FactoryGirl.create(:deviation) }
  	let(:boobs) { FactoryGirl.create(:mature) }
	
	before { @slideshow = FactoryGirl.build(:slideshow) }

	subject { @slideshow }

	describe "should respond to the following methods:" do

		it { should respond_to(:seed) }
		it { should respond_to(:nsfw) }
		it { should respond_to(:results) }

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

	describe "deviations added to a slideshow" do
		before do
			@slideshow.save
			@slideshow.deviations << deviation
			@slideshow.deviations << deviation
		end
		it "should be unique" do
			expect(@slideshow.deviations.count).to eq(1)
		end
	end

	describe ".results method" do
		before do
		  @slideshow.save
		  @slideshow.deviations << deviation
		  @slideshow.deviations << boobs
		end
		it "should return the default deviations list, i.e. all work safe deviations" do
			expect(@slideshow.results).to eq(@slideshow.deviations.where(mature: false))			
		end
	end


	describe "that contains mature deviations" do
		before do
		  @slideshow.save
		  @slideshow.deviations << boobs
		end

		it "should not include mature deviations by default" do
			expect(@slideshow.results).not_to include(boobs)
		end
	end

	describe ".nsfw method" do
		before do
		  @slideshow.save
		  @slideshow.deviations << boobs

		end
		it "should return mature deviations associated with that slideshow" do
			expect(@slideshow.nsfw).to include(boobs)
		end
	  
	end

end






