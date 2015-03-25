class Slideshow < ActiveRecord::Base

  # Validations:
  VALID_SEED_REGEX = /[A-F0-9]{8}(-[A-F0-9]{4}){3}-[A-F0-9]{12}/

  validates :seed, presence: true, length: { is: 36 }, format: VALID_SEED_REGEX, uniqueness: true

  # Relationships:
  has_and_belongs_to_many :deviations, -> { uniq }


  def results
    deviations.where(mature: false)
  end


  def nsfw
    deviations
  end

  def self.whats_hot_slideshow
    where(seed: "00000000-0000-0000-0000-000000000001").first
  end

end
