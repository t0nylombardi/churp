class Churp < ApplicationRecord
  belongs_to :user
  belongs_to :churp, optional: true, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy
  has_many :comments, dependent: :destroy

  has_one_attached :churp_pic

  validates :churp_pic, acceptable_image: true
  validates :body, length: { maximum: 331 }, allow_blank: false, unless: :churp_id

  after_create :broadcast_churp

  def churp_type
    if churp_id? && body?
      'quote-churp'
    elsif churp_id?
      'rechurp'
    else
      'churp'
    end
  end

  private

  def broadcast_churp
    ActionCable.server.broadcast('churps_channel', rendered_churp)
  end

  def rendered_churp
    ApplicationController.renderer.render(
      partial: 'churps/churp',
      locals: { churp: self }
    )
  end

end
