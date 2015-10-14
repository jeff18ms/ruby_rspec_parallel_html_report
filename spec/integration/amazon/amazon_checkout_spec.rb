
describe "Amazon Checkout" do

  let(:product) {'Fisher-Price Brilliant Basics Chatter Telephone'}
  let(:amz_locators) {AmazonPageObjects.new}


  before :all do
    set_driver
  end

  after :each do
    capture_screenshot_on_failure
    handle_service_unavailable
  end

  after :all do
    quit_webdriver
  end

  it "Should be able to delete the item" do
    open_url('https://amazon.com')
    search_amazon(product)
    click_item_to_continue(product)
    amz_add_item_to_cart
    amz_click_cart_icon
    amz_delete_item
    expect(is_text_present?('was removed from Shopping Cart.')).to be true
  end

  it "Should be able to see sign in page during checkout when not logged in" do
    open_url('https://amazon.com')
    search_amazon(product)
    click_item_to_continue(product)
    amz_add_item_to_cart
    amz_proceed_to_checkout
    sign_in_to_amazon('dummyuser@amazon.com','dummy')
    expect(get_current_url).to include('/ap/signin')
  end
end
