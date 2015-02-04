class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

	# Validations:
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(?:\.[a-z\d\-]+)*\.[a-z]+\z/i

	validates :email, presence: true, format: VALID_EMAIL_REGEX, uniqueness: { case_sensitive: false }


	# callbacks
	before_save :set_default_slideshow

	# Instance Methods
	def slideshow
		Slideshow.where(seed: self.seed).first
	end



	private

	def set_default_slideshow
		self.seed = "00000000-0000-0000-0000-000000000001"
	end




end
