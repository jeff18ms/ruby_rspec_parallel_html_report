
module Amazon
  module AmazonHelper

    @@amazon = AmazonPageObjects.new

    def sign_in_to_amazon(email_id, password)
      amz_email_id_input(:set,email_id)
      amz_password_input(password)
      amz_click_sign_in_button
      wait_for_page_load
    end

    def search_amazon(item_to_search)
      set_text(@@amazon.amz_search_input_field,item_to_search)
      click(@@amazon.amz_search_icon,ajax_wait:false)
      wait_for_page_load
    end

    def click_item_to_continue(item_to_click)
      search_data_count = get_web_elements(@@amazon.amz_search_results_container).count
      for i in 1..search_data_count
        click(update_locator(@@amazon.amz_searched_result_product_name,'replace',i.to_s,''),ajax_wait:false) if get_text(update_locator(@@amazon.amz_searched_result_product_name,'replace',i.to_s,''))
        break
      end
    end

    def handle_service_unavailable
      alert_accept if alert_present?
      raise "503 Service Unavailable" if is_text_present?("Service Unavailable") || is_text_present?('Service Temporarily Unavailable')
      raise "404 Page Not Found" if is_text_present?("File not found (404 error)")
    end

  end
end





