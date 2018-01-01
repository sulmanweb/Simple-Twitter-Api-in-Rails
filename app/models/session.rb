class Session < ApplicationRecord
  belongs_to :user

  ## VALIDATIONS
  validates :utoken, presence: true, uniqueness: true, length: {is: UTOKEN_LENGTH}

  ## SCOPES
  scope :active_sessions, -> {where active: true}

  ## MODEL FUNCTIONS CALLINGS
  before_validation :generate_utoken, on: :create
  after_create :current_time_to_last_user_at

  private

  # Generate random unique utoken for the model
  def generate_utoken
    self.utoken = loop do
      random_token = SecureRandom.base58(UTOKEN_LENGTH)
      break random_token unless Session.exists?(utoken: random_token)
    end
  end

  def current_time_to_last_user_at
    self.update(last_used_at: Time.zone.now)
  end
end
