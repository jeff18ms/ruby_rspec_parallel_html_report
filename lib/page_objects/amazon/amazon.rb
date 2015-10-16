require_relative '../../../spec/spec_helper'

module Amazon
  module PageObjects

    @@amz= AmazonPageObjects.new

    def amz_email_id_input(get_or_set = :set, email_id = nil)
      get_or_set==:set ? set_text(@@amz.amz_input_email_id, email_id) : get_value_from_text_field(@@amz.amz_input_email_id)
    end

    def amz_password_input password
      set_text(@@amz.amz_input_password, password)
    end

    def amz_sign_in_error_message
      get_text(@@amz.amz_authentication_alert)
    end

    #jQuery is not loaded in Amazon pages hence has to pass param to not to wait for ajax load
    def amz_click_sign_in_button
      click(@@amz.amz_sign_in_button,ajax_wait:false)
    end

    def amz_add_item_to_cart
      click(@@amz.amz_add_to_cart_button,ajax_wait:false)
      wait_for_page_load
    end

    def amz_proceed_to_checkout
      click(@@amz.amz_proceed_to_checkout_button,ajax_wait:false)
      wait_for_page_load
    end

    def amz_click_cart_icon
      click(@@amz.amz_cart_icon,ajax_wait:false)
      wait_for_page_load
    end

    def amz_delete_item
      click(@@amz.amz_delete_item,ajax_wait:false)
      wait_for_page_load
    end


  end
end
