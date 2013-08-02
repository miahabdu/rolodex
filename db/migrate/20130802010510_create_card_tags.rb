class CreateCardTags < ActiveRecord::Migration
  def change
    create_table :card_tags do |t|
      t.string :name

      t.timestamps
    end
  end
end
