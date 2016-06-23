class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :async

  # Validations:
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(?:\.[a-z\d\-]+)*\.[a-z]+\z/i
  HEX_REGEX = /[a-f0-9]+/

  validates :email, presence: true, format: VALID_EMAIL_REGEX, uniqueness: { case_sensitive: false }
  # validates :uuid, presence: true, format: HEX_REGEX, uniqueness: true


  # callbacks
  before_create :set_default_slideshow
  after_save :create_uuid

  # Instance Methods
  def slideshow
    Slideshow.includes(:deviations).where(seed: self.seed).first
  end

  def create_uuid
    unless self.uuid
      self.uuid = (self.id + 1000).to_s(16).rjust(6,'0')
    end
  end

  private

  def set_default_slideshow
    self.seed = "00000000-0000-0000-0000-000000000001"
  end


end
