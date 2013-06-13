class Card < ActiveRecord::Base
  attr_accessible :card, :ocr_info, :user_id

  has_attached_file :card

  belongs_to :user
end
