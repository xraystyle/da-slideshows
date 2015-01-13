require 'rails_helper'

RSpec.describe Slideshow, :type => :model do
  
	before { @slideshow = Slideshow.new(seed: "DFE52DC8-726A-2C57-FEA4-6A61E9DEA8B0") }

	subject { @slideshow }



end
