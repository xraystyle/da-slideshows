# This is what's necessary to add helper methods to FactoryGirl easily.
# It's kinda lame that you need to monkey-patch the DefinitionProxy class
# because you can't just include modules.
module FactoryGirl
	class DefinitionProxy
		
		def make_uuid
			# make random numbers for the first few parts of the seed.
			# last part doesn't matter. That's enough entropy to avoid
			# collisions.		
			first = Random.rand(268435456..4294967295).to_s(16).upcase
			second = Random.rand(4096..65535).to_s(16).upcase
			third = Random.rand(4096..65535).to_s(16).upcase
			fourth = Random.rand(4096..65535).to_s(16).upcase
			"#{first}-#{second}-#{third}-#{fourth}-C32495BB6097"
		end	

	end
end


require "faker"


FactoryGirl.define do
	
	# Build users.
	factory :user do

		sequence(:email) { |n| "person#{n}@example.com" }
		password "foobar"
		password_confirmation "foobar"

	end


	# Build slideshows.
	factory :slideshow do

		seed make_uuid

	end

	factory :deviation do
		sequence(:url) { |n| "http://user#{n}.deviantart.com/art/title-#{n}" }
		title Faker::Lorem.words.join(" ")
		author Faker::Internet.user_name
		mature false
		src "http://fc04.deviantart.net/fs70/i/2014/336/f/9/deviation-by-author-d88g3s2.jpg"
		thumb "http://th07.deviantart.net/fs70/200H/i/2014/336/f/9/deviation-by-author-d88g3s2.jpg"
		orientation { %w(portrait landscape square).sample }
		uuid make_uuid


	end


end
























