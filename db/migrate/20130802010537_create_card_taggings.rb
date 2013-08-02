class CreateCardTaggings < ActiveRecord::Migration
  def change
    create_table :card_taggings do |t|
      t.belongs_to :card_tag
      t.belongs_to :card

      t.timestamps
    end
    add_index :card_taggings, :card_tag_id
    add_index :card_taggings, :card_id
  end
end
