require 'tesserack'

class Card < ActiveRecord::Base
  attr_accessible :card, :ocr_info, :user_id, :card_file_name

  has_attached_file :card, :styles => { :medium => "300x200>", :large => "500x500>" }, :url => "/images/:class/:style/:basename.:extension"

  belongs_to :user
  
  def save_with_ocr
    if self.save
      txt = Tesserack.ocr(self.card.path)
      self.ocr_info = txt rescue "OCR Info couldn't be scanned"
      Tesserack.delete_tmp_txt(self.card.path) rescue nil
      self.save
    else
      false
    end
  end

  def self.search(search)
    if search
      find(:all, :conditions => ['ocr_info LIKE ?', "%#{search}%"])
    else
      find(:all)
    end
  end
end
