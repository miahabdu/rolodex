class CardTag < ActiveRecord::Base
  attr_accessible :name
  has_many :card_taggings
	has_many :cards, through: :card_taggings
end
