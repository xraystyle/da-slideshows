FactoryGirl.define do
	
	# Build users.
	factory :user do

		sequence(:email) { |n| "person#{n}@example.com" }
		password "foobar"
		password_confirmation "foobar"

	end


	# Build slideshows.
	factory :slideshow do

		# make random numbers for the first few parts of the seed.
		# last part doesn't matter. That's enough entropy to avoid
		# collisions.
		@first = Random.rand(268435456..4294967295).to_s(16).upcase
		@second = Random.rand(4096..65535).to_s(16).upcase
		@third = Random.rand(4096..65535).to_s(16).upcase
		@fourth = Random.rand(4096..65535).to_s(16).upcase

		seed "#{@first}-#{@second}-#{@third}-#{@fourth}-C32495BB6097"

	end


end