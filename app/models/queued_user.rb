class QueuedUser < ApplicationRecord

  validates :name, :number, presence: true
  before_save :strip_number

  def waiting?
    finished_at.blank? && confirmed_at.present?
  end

  def valid_token?(token)
    token == self.confirm_token
  end

  def strip_number
    # Remove all non numbers: http://rubular.com/r/71Skn8LXOW
    self.number = self.number.gsub(/\D/, '')
  end

  def url_helpers
    Rails.application.routes.url_helpers
  end

  def confirm_url
    url_helpers.confirm_queue_url(id: self.id, confirm_token: self.confirm_token)
  end

  def you_are_next!
    $TwilioClient.messages.create(
      from: ENV['TWILIO_PHONE_NUMBER'],
      to:   self.number,
      body: "You're next! Go line up in person now!"
    )
  end

  def send_confirmation!
    $TwilioClient.messages.create(
      from: ENV['TWILIO_PHONE_NUMBER'],
      to:   self.number,
      body: "Confirm your phone number by visiting #{ confirm_url }"
    )
  rescue Twilio::REST::RequestError => e
    logger.error(e.message)
    self.destroy
    self.errors.add(:number, :not_valid, message: "Number was not valid")
    false
  end

  def self.next_in_line
    where("queued_at is not null"). # they have a confirmed phone number
      where("notified_at is not null"). # have not already been notified
      where(finished: false).       # have not finished
      order(:queued_at)
  end

  def self.waiting_users
    where.not(queued_at: nil). # they have a confirmed phone number
      where(notified_at: nil). # have not already been notified
      where(finished_at: nil). # have not finished
      order(:queued_at)
  end

  def place_in_line
    QueuedUser.waiting_users.where("queued_at < ?", self.queued_at).count
  end
end
