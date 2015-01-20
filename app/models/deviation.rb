class Deviation < ActiveRecord::Base

	DA_URL_REGEX = /http:\/\/.*\.deviantart\.(com|net)/
	DA_IMAGE_REGEX = /http:\/\/.*\.deviantart\.(com|net).*(jpg|png|gif)/

	# Validations:
	validates :url, presence: true, format: DA_URL_REGEX
	validates :src, presence: true, format: DA_IMAGE_REGEX
	validates :thumb, presence: true, format: DA_IMAGE_REGEX
	validates :title, presence: true
	validates :author, presence: true
	validates :mature, inclusion: { in: [true, false] }
	validates :orientation, inclusion: { in: ["portrait", "landscape", "square"] }
	validates :uuid, presence: true, uniqueness: true


	# Relationships:
	has_and_belongs_to_many :slideshows

	scope :nsfw, where(mature: true)

end
