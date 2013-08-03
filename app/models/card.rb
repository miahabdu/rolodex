require 'tesserack'

class Card < ActiveRecord::Base
  attr_accessible :card, :ocr_info, :user_id, :card_file_name, :tag_list
  has_many :card_taggings
  has_many :card_tags, through: :card_taggings

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

  # def self.search(search)
  #   if search
  #     find(:all, :conditions => ['ocr_info LIKE ?', "%#{search}%"])
  #   else
  #     find(:all)
  #   end
  # end
  def self.search(search)
    if search
      where 'ocr_info LIKE ?', "%#{search}%"
    else
      scoped
    end
  end
  
  def self.tagged_with(name)
    CardTag.find_by_name!(name).cards
  end

  def self.tag_counts
    CardTag.select("card_tags.*, count(card_taggings.card_tag_id) as count").
      joins(:cad_taggings).group("card_taggings.card_tag_id")
  end

  def tag_list
    card_tags.map(&:name).join(", ")
  end

  def tag_list=(names)
    self.card_tags = names.split(",").map do |n|
      CardTag.where(name: n.strip).first_or_create!
    end
  end
end
