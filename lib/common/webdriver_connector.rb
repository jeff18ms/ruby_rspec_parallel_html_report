require_relative '../../spec/spec_helper'
require_relative '../../lib/common/configuration'

module SeleniumWebdriver
  module WebDriverConnector
    @@default_wait_options = {:timeout => Constants::MEDIUM_TIMEOUT_VALUE}

    def set_driver(browser = browser_type)
      client = Selenium::WebDriver::Remote::Http::Default.new
      client.timeout = 120

      if driver_type == :local
        @driver = Selenium::WebDriver.for(browser.to_sym,:http_client =>client)
        @driver.manage.timeouts.script_timeout = Constants::FORTY_FIVE_SECOND_TIMEOUT_VALUE
        browser
      elsif driver_type == :remote
        capabilities = Selenium::WebDriver::Remote::Capabilities.send(browser.to_sym)

        @driver = Selenium::WebDriver.for(
            :remote,url: "http://#{hub_ip}:4444/wd/hub",
            desired_capabilities: capabilities,
            :http_client =>client,
        )
        @driver.file_detector = lambda do |args|
          str = args.first.to_s
          str if File.exist?(str)
        end
        @driver.manage.timeouts.script_timeout = Constants::FORTY_FIVE_SECOND_TIMEOUT_VALUE
        browser
      end
    end

    def shutdown_selenium_server
      response = RestClient.get "#{hub_ip}/lifecycle-manager?action=shutdown"
      if response.code!= 200
        #invoke command
      end
    end

    def open_url url
      js_open_page(url)
      maximize_browser
      wait_for_page_load
    end

    def navigate_to_url(url)
      js_open_page(url)
      maximize_browser
      wait_for_page_load
    end

    def open_url_in_new_tab url
      execute_js("$('body').append('<a href=\"#{url}\" target=\"_blank\" id=\"custom_link\">TEST_LINK</a>')")
      click :id => "custom_link"
      wait_for_page_load
    end

    def close_browser_window
      @driver.close
    end

    def set_file_path_in_HTML_file_input_field(locator, file_path)
     set_DOM_attribute(locator,'style','display:block')
     if driver_type == :local
       abs_file_path = File.absolute_path(file_path)
       set_text_without_clear(locator, abs_file_path)
     else
       set_text_without_clear(locator, file_path)
     end
    end

    def get_cookie_value cookie_name
      cookie = @driver.manage.cookie_named cookie_name
      raise "Unable to obtain session cookie" if cookie.nil?
      cookie[:value].to_s
    end

    def set_cookie cookie ={}
      @driver.manage.add_cookie cookie
    end

    def set_webdriver_timeout time, message = "Your expected condition was not met in #{time} seconds"
      wait = Selenium::WebDriver::Wait.new(:timeout => time, :message => message)
      wait
    end

    def wd_delete_all_cookies
      maximize_browser
      #@driver.manage.window.resize_to(1024, 600)
      @driver.manage.delete_all_cookies
    end

    def refresh_page page_load = true
      @driver.navigate.refresh
      wait_for_page_load if page_load==true
    end

    def quit_webdriver
      if driver_type != :local
        alert_accept
        @driver.quit
      end
    end

    def switch_to_default_frame
      @driver.switch_to.default_content
    end

    def switch_to_frame frameId
      @driver.switch_to.frame frameId
    end

    def maximize_browser
      @driver.manage.window.maximize
    end

    def alert_accept
      @driver.switch_to.alert.accept rescue Selenium::WebDriver::Error::NoAlertOpenError
    end

    def alert_dismiss
      @driver.switch_to.alert.dismiss rescue Selenium::WebDriver::Error::NoAlertOpenError
    end
    def alert_present?
     begin
       @driver.switch_to.alert
       true
     rescue
       false
     end
  end
    def switch_to_last_window
      @driver.switch_to.window(@driver.window_handles.last)
    end
    def switch_to_first_window
      @driver.switch_to.window(@driver.window_handles.first)
    end

    def get_page_source
      @driver.page_source
    end

    def is_text_present? text, source=get_page_source
      source.include?(text)
    end

    def is_checkbox_checked? locator
      to_boolean(get_attribute(locator,Constants::HTML_ATTRIB_CHECKED)).eql?(true) if locator.class == Hash
    end

    def get_value_from_text_field locator_or_element
      get_attribute locator_or_element,Constants::HTML_ATTRIB_VALUE
    end

    def is_element_present? locator_or_element
      if locator_or_element.class == Hash
        elements = get_web_elements locator_or_element
        if elements.empty?
          false
        else
          elem = elements.first
          elem.displayed?
        end
      elsif locator_or_element.class == Selenium::WebDriver::Element
        locator_or_element.displayed?
      end
    end

    def is_element_disabled? locator_or_element
      if to_boolean(get_attribute(locator_or_element,'disabled'))==true
        true
      elsif get_attribute(locator_or_element,Constants::HTML_ATTRIB_CLASS).include? 'disable'
        true
      else
        false
      end
    end

    def delete_input_text_through_send_keys(locator_or_element)
      js_select_input_field_content(locator_or_element)
      get_web_element(locator_or_element).send_keys([:delete])
    end

    def is_element_enabled? locator
      elements = get_web_elements locator
      if elements.empty?
        return false
      else
        elem = elements.first
        elem.enabled?
      end
    end

    def wait_for_element_to_present(locator_or_element, wait_options = @@default_wait_options)
      begin
        wait = Selenium::WebDriver::Wait.new wait_options
        wait.until { get_web_element(locator_or_element) }
      rescue Exception => e
        handle_service_unavailable
        raise e
      end
    end

    def wait_for_text_to_present(text,wait_options = @@default_wait_options)
      begin
        wait = Selenium::WebDriver::Wait.new wait_options
        wait.until {is_text_present? text}
      rescue Exception => e
        raise e
      end
    end

    def wait_for_page_load(wait_time=Constants::LONG_TIMEOUT_VALUE)
      begin
        if environment == 'local'
          wait = set_webdriver_timeout(Constants::TOO_LONG_TIMEOUT_VALUE,"Page was not loaded in #{Constants::TOO_LONG_TIMEOUT_VALUE} seconds")
        else
          wait = set_webdriver_timeout(wait_time,"Page was not loaded in #{Constants::LONG_TIMEOUT_VALUE} seconds")
        end
        wait.until {execute_js("return document.readyState;") == "complete" }
      rescue Exception => e
        handle_service_unavailable
        raise e
      end
    end


    def stop_page_loading
      execute_js("window.stop()")
    end

    def mouse_over(locator_or_element)
      @driver.action.move_to(get_web_element locator_or_element).perform
    end

    def drag_and_drop(locator_or_element,right_by,down_by)
      @driver.action.drag_and_drop_by(get_web_element(locator_or_element),right_by,down_by).perform
    end

    def enter_keyboard_multi_keys(primary_key, secondary_key)
      @driver.action.key_down(primary_key).send_keys(secondary_key).perform
      @driver.action.key_up(primary_key).perform
    end

    def browser_back(page_load = true)
      @driver.navigate.back
      wait_for_page_load if page_load==true
    end

    def browser_forward
      @driver.navigate.forward
    end

    def click(locator_or_element, ajax_wait: true)
      wait_for_element_to_present(locator_or_element, timeout: Constants::MEDIUM_TIMEOUT_VALUE)
      (get_web_element(locator_or_element)).click
      wait_for_ajax_complete if ajax_wait
    end

    def get_text(locator_or_element)
      wait_for_element_to_present(locator_or_element, timeout: Constants::MEDIUM_TIMEOUT_VALUE)
      (get_web_element locator_or_element).text
    end

    def set_text(locator_or_element, textToSet)
      clear_text(locator_or_element)
      wait_for_element_to_present(locator_or_element, timeout: Constants::MEDIUM_TIMEOUT_VALUE)
      (get_web_element locator_or_element).send_keys(textToSet)
    end

    def set_text_without_clear(locator_or_element, textToSet)
      wait_for_element_to_present(locator_or_element, timeout: Constants::MEDIUM_TIMEOUT_VALUE)
      (get_web_element locator_or_element).send_keys(textToSet)
    end

    def get_attribute(locator_or_element,attribute)
      wait_for_element_to_present(locator_or_element, timeout: Constants::MEDIUM_TIMEOUT_VALUE)
      (get_web_element locator_or_element).attribute(attribute)
    end

    def clear_text(locator_or_element)
      wait_for_element_to_present(locator_or_element, timeout: Constants::MEDIUM_TIMEOUT_VALUE)
      (get_web_element locator_or_element).clear()
    end

    def get_current_title
      @driver.title
    end

    def get_current_url
      @driver.current_url
    end

    def get_style_attribute(locator_or_element_or_tag, style_attribute)
      (get_web_element locator_or_element_or_tag).style(style_attribute)
    end

    def execute_js(script, *args)
      @driver.execute_script(script,*args)
    end

    def capture_screenshot(example_name)
      @driver.save_screenshot "spec/reports/screenshots/#{example_name}#{Time.now.strftime("_failshot__%d_%m_%Y__%H_%M_%S")}.png"
    end

    def select_item_from_dropdown(locator,itemToSelect)
      option = Selenium::WebDriver::Support::Select.new(get_web_element locator)
      option.select_by(:text, itemToSelect)
    end

    def get_selected_item_from_dropdown(locator)
      option = Selenium::WebDriver::Support::Select.new(get_web_element locator)
      (option.first_selected_option).text
    end

    def get_dropdown_list_option_values(locator)
      if get_locator_type(locator).eql?(:id)
        with_option_tag= update_locator(locator, "", "", ">option")
        modified_locator_type = update_locator(with_option_tag,get_locator_value(with_option_tag),"##{get_locator_value(with_option_tag)}")
        modified_locator_type["css"] = modified_locator_type.delete("id")

        locator = modified_locator_type
      else
        locator = update_locator(locator, "", "", ">option") unless locator.include?("option")
      end

      option = get_web_elements(locator).count
      list_value =[]
      for i in 1..option
        list_value.push(get_text(update_locator(locator,'','',":nth-child(#{i.to_s})")))
      end
      list_value
    end

    def get_child_element_text(parent_locator_or_element, child_locator)
      begin
        parent_element = resolve_to_element(parent_locator_or_element)
        parent_element.find_element(child_locator).text
      rescue
        return nil
      end
    end

    def get_child_web_elements(parent_element, child_locator)
      parent_element.find_elements(child_locator)
    end

    def resolve_to_element(locator_or_element)
      case locator_or_element
      when Hash
        get_web_element(locator_or_element)
      when Selenium::WebDriver::Element
        locator_or_element
      end
    end

    def get_web_element(locator_or_element)
      raise "Hey pass me a valid locator or element" unless locator_or_element.class == Selenium::WebDriver::Element || locator_or_element.class == Hash
      return locator_or_element if locator_or_element.class == Selenium::WebDriver::Element
      element = Hash[locator_or_element.map{|(k,v)| [k.to_sym,v]}]
      @driver.find_element element.keys.first => element.values.first
    end

    def get_web_elements(locator)
      handle_service_unavailable
      element = Hash[locator.map{|(k,v)| [k.to_sym,v]}]
      @driver.find_elements element.keys.first => element.values.first
    end

    def get_locator_value(locator)
      element = Hash[locator.map{|(k,v)| [k.to_sym,v]}]
      element.values.first
    end

    def get_locator_type(locator)
      element = Hash[locator.map{|(k,v)| [k.to_sym,v]}]
      element.keys.first
    end

    def update_locator(locator,old_value='',to_replace='',value_to_update='')
      locator.inject({}) { |h, (k, v)| h[k] = v.sub(old_value,to_replace)+value_to_update; h }
    end

    def capture_screenshot_on_failure
      capture_screenshot RSpec.current_example.description unless RSpec.current_example.exception.nil?
    end

  end
end




