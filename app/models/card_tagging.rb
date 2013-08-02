class CardTagging < ActiveRecord::Base
  belongs_to :card_tag
  belongs_to :card
  # attr_accessible :title, :body
end
