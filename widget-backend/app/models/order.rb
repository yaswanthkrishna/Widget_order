class Order < ApplicationRecord
  belongs_to :user

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :widget_type, presence: true
  validates :delivery_date, presence: true
  validates :color, presence: true
  validates :status, presence: true

  before_validation :set_default_status, on: :create

  validate :delivery_date_must_be_in_the_future

  private

  def set_default_status
    self.status ||= 'Order Placed'
  end

  def delivery_date_must_be_in_the_future
    if delivery_date.present? && delivery_date <= Date.today
      errors.add(:delivery_date, "must be in the future")
    end
  end
end
