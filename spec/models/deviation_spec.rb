require 'rails_helper'

RSpec.describe Deviation, :type => :model do

	before { @deviation = Deviation.new(url: "http://xraystyle.deviantart.com/art/Looking-Back-497917730", 
										title: "Looking Back", 
										author: "xraystyle", 
										mature: false, 
										src: "http://fc04.deviantart.net/fs70/i/2014/336/f/9/looking_back_by_xraystyle-d88g3s2.jpg", 
										thumb: "http://th07.deviantart.net/fs70/200H/i/2014/336/f/9/looking_back_by_xraystyle-d88g3s2.jpg", 
										orientation: "landscape", 
										uuid: "62CD20E0-F32D-CB46-1853-BF80B9F22EDE") }
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

	describe "when uuid is missing" do
	  before { @deviation.uuid = "" }
	  it { should_not be_valid }
	end


	#  Test 'url' for validity ------------------------------
	describe "when 'url' is not a valid DA URL" do
		before { @slideshow.url = "http://turdb.in" }
		it { should_not be_valid }
	end


	describe "when 'url' is not a full, usable URL" do
		before { @slideshow.url = "turdb.in" }
	  	it { should_not be_valid }
	end


	#  Test 'src' for validity ------------------------------
	describe "when 'src' is not a valid DA URL" do
		before { @slideshow.src = "http://turdb.in/img/permanent/tacos.jpg" }
		it { should_not be_valid }
	end


	describe "when 'src' is not a full, usable URL" do
		before { @slideshow.src = "tacos.jpg" }
	  	it { should_not be_valid }
	end

	describe "when 'src' is not an image" do
		before { @slideshow.src = "http://turdb.in/dump/internet.txt" }
		it { should_not be_valid }
	end


	#  Test 'thumb' for validity ------------------------------
	describe "when 'thumb' is not a valid DA URL" do
		before { @slideshow.thumb = "http://turdb.in/img/permanent/tacos.jpg" }
		it { should_not be_valid }
	end


	describe "when 'thumb' is not a full, usable URL" do
		before { @slideshow.thumb = "tacos.jpg" }
	  	it { should_not be_valid }
	end

	describe "when 'thumb' is not an image" do
		before { @slideshow.thumb = "http://turdb.in/dump/internet.txt" }
		it { should_not be_valid }
	end



end




















