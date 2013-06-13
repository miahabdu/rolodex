class Card < ActiveRecord::Base
  attr_accessible :card, :ocr_info, :user_id

  has_attached_file :card, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :url => "/images/:class/:style/:basename.:extension"

  belongs_to :user
  
  def save_with_ocr
    if self.save
      txt = Tesserack.tessrack(self.card.path)
      self.ocr_info = txt
      self.save
    else
      false
    end
  end
end
