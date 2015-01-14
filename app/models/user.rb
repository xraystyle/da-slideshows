class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

	# Validations:
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(?:\.[a-z\d\-]+)*\.[a-z]+\z/i

	validates :email, presence: true, format: VALID_EMAIL_REGEX, uniqueness: { case_sensitive: false }




	# Relationships:
	# has_one :slideshow, dependent: :destroy

	def slideshow
		Slideshow.where(seed: self.seed).first
	end


end
