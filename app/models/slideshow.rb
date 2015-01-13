class Slideshow < ActiveRecord::Base

	VALID_SEED_REGEX = /[A-F0-9]{8}(-[A-F0-9]{4}){3}-[A-F0-9]{12}/

	validates :seed, presence: true, length: { is: 36 }, format: VALID_SEED_REGEX
	validates :user_id, presence: true

	belongs_to :user



end
