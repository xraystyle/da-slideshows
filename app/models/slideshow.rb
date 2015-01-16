class Slideshow < ActiveRecord::Base

	# Validations:
	VALID_SEED_REGEX = /[A-F0-9]{8}(-[A-F0-9]{4}){3}-[A-F0-9]{12}/

	validates :seed, presence: true, length: { is: 36 }, format: VALID_SEED_REGEX, uniqueness: true

	# Relationships:
	has_and_belongs_to_many :deviations


end
