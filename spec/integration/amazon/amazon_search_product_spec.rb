
describe "Amazon Search Item and Add to cart" do

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

   it "Should be able to search a specified item" do
     open_url('https://amazon.com')
     search_amazon(product)
     click_item_to_continue(product)
     expect(is_text_present?(product)).to be true
   end

  it "Should be able to add a product to cart " do
    open_url('https://amazon.com')
    search_amazon(product)
    click_item_to_continue(product)
    amz_add_item_to_cart
    expect(is_element_present?(amz_locators.amz_proceed_to_checkout_button)).to be true
  end

end
