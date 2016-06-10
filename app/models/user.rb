class User < ActiveRecord::Base
  require 'digest'
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :async

  # Validations:
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(?:\.[a-z\d\-]+)*\.[a-z]+\z/i

  validates :email, presence: true, format: VALID_EMAIL_REGEX, uniqueness: { case_sensitive: false }
  validates :uuid, presence: true, length: { is: 32 }, uniqueness: true


  # callbacks
  before_create :set_default_slideshow, :create_uuid

  # Instance Methods
  def slideshow
    Slideshow.includes(:deviations).where(seed: self.seed).first
  end

  def create_uuid
    md5 = Digest::MD5.new
    md5.update self.email + Time.now.to_s
    self.uuid = md5.hexdigest
  end



  private

  def set_default_slideshow
    self.seed = "00000000-0000-0000-0000-000000000001"
  end


end
