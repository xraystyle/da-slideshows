require 'rails_helper'

RSpec.describe Deviation, :type => :model do

	before { @deviation = Deviation.new(url: "http://xraystyle.deviantart.com/art/Looking-Back-497917730", 
										title: "Looking Back", 
										author: "xraystyle", 
										mature: false, 
										src: "https://fc04.deviantart.net/fs70/i/2014/336/f/9/looking_back_by_xraystyle-d88g3s2.jpg", 
										thumb: "https://th07.deviantart.net/fs70/200H/i/2014/336/f/9/looking_back_by_xraystyle-d88g3s2.jpg", 
										orientation: "landscape", 
										uuid: "62CD20E0-F32D-CB46-1853-BF80B9F22EDE") }

	let(:slideshow_a) { FactoryGirl.create(:slideshow) }
	let(:slideshow_b) { FactoryGirl.create(:slideshow) }

	subject { @deviation }

	describe "should respond to the following methods:" do

		it { should respond_to(:url) }
		it { should respond_to(:title) }
		it { should respond_to(:author) }
		it { should respond_to(:mature?) }
		it { should respond_to(:src) }
		it { should respond_to(:thumb) }
		it { should respond_to(:orientation) }
		it { should respond_to(:uuid) }
		it { should respond_to(:slideshows) }

	end

	it { should be_valid }

	#  Test missing attributes.
	describe "when URL is missing" do
	  before { @deviation.url = "" }
	  it { should_not be_valid }
	end


	describe "when title is missing" do
	  before { @deviation.title = "" }
	  it { should_not be_valid }
	end


	describe "when author is missing" do
	  before { @deviation.author = "" }
	  it { should_not be_valid }
	end

	describe "when mature is missing" do
	  before { @deviation.mature = "" }
	  it { should_not be_valid }
	end

	describe "when src is missing" do
	  before { @deviation.src = "" }
	  it { should_not be_valid }
	end

	describe "when thumb is missing" do
	  before { @deviation.thumb = "" }
	  it { should_not be_valid }
	end

	describe "when orientation is missing" do
	  before { @deviation.orientation = "" }
	  it { should_not be_valid }
	end

	describe "acceptible values for 'orientation':" do
		
		describe "when 'portrait'" do
			before { @deviation.orientation = "portrait" }
			it { should be_valid }
		end

		describe "when 'landscape'" do
			before { @deviation.orientation = "landscape" }
			it { should be_valid }
		end

		describe "when 'square'" do
			before { @deviation.orientation = "square" }
			it { should be_valid }
		end

		describe "when not an acceptible value" do
			before { @deviation.orientation = "rhombus" }		  
			it { should_not be_valid }
		end

	end



	describe "when uuid is missing" do
	  before { @deviation.uuid = "" }
	  it { should_not be_valid }
	end

	describe "when uuid is already taken" do
		before do
			duplicate = @deviation.dup
			duplicate.save	
		end
		it { should_not be_valid }
	end


	#  Test 'url' for validity ------------------------------
	describe "when 'url' is not a valid DA URL" do
		before { @deviation.url = "http://turdb.in" }
		it { should_not be_valid }
	end


	describe "when 'url' is not a full, usable URL" do
		before { @deviation.url = "turdb.in" }
	  	it { should_not be_valid }
	end


	#  Test 'src' for validity ------------------------------
	describe "when 'src' is not a valid DA URL" do
		before { @deviation.src = "http://turdb.in/img/permanent/tacos.jpg" }
		it { should_not be_valid }
	end


	describe "when 'src' is not a full, usable URL" do
		before { @deviation.src = "tacos.jpg" }
	  	it { should_not be_valid }
	end

	describe "when 'src' is not an image" do
		before { @deviation.src = "http://deviantart.com/file/internet.txt" }
		it { should_not be_valid }
	end


	#  Test 'thumb' for validity ------------------------------
	describe "when 'thumb' is not a valid DA URL" do
		before { @deviation.thumb = "http://turdb.in/img/permanent/tacos.jpg" }
		it { should_not be_valid }
	end


	describe "when 'thumb' is not a full, usable URL" do
		before { @deviation.thumb = "tacos.jpg" }
	  	it { should_not be_valid }
	end

	describe "when 'thumb' is not an image" do
		before { @deviation.thumb = "http://deviantart.com/file/internet.txt" }
		it { should_not be_valid }
	end

	describe "when added to slideshows" do
		before do
			@deviation.save
			slideshow_a.deviations << @deviation
			slideshow_b.deviations << @deviation
		end

		it "is then associated with those slideshows" do
			expect(@deviation.slideshows).to include(slideshow_a)
			expect(@deviation.slideshows).to include(slideshow_b)
		end
	  
	end

end




















