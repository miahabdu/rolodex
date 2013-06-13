require 'spec_helper'

describe "cards/new" do
  before(:each) do
    assign(:card, stub_model(Card,
      :user => "",
      :ocr_info => "MyText",
      :card => ""
    ).as_new_record)
  end

  it "renders new card form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", cards_path, "post" do
      assert_select "input#card_user[name=?]", "card[user]"
      assert_select "textarea#card_ocr_info[name=?]", "card[ocr_info]"
      assert_select "input#card_card[name=?]", "card[card]"
    end
  end
end
