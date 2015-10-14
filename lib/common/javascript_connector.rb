require_relative '../../spec/spec_helper'
require_relative '../../lib/common/configuration'

module JavascriptConnector

  def browser_open_new_window
    execute_js('window.open()')
  end

  def wait_for_ajax_complete
    handle_service_unavailable
    alert_accept if alert_present?
    Selenium::WebDriver::Wait.new(:timeout => Constants::FORTY_FIVE_SECOND_TIMEOUT_VALUE,:message => "unable to load AJAX contents within #{Constants::FORTY_FIVE_SECOND_TIMEOUT_VALUE} seconds time frame").until{execute_js("return jQuery.active ==0")}
  end

  def form_submit
    if !(get_web_elements :css => "input[type='submit']").empty?
      get_web_elements(:css => "input[type='submit']").first.submit
    elsif !(get_web_elements :css => "button[type='submit']").empty?
      get_web_elements(:css => "button[type='submit']").first.submit
    else !(get_web_elements :css => "button[class='btn btn-primary']").empty?
      get_web_elements(:css => "button[class='btn btn-primary']").first.click
    end
    wait_for_page_load
  end

  def js_open_page url
    execute_js("window.location.href = '#{url}'")
    wait_for_page_load
  end

  def is_element_visible? locator
    get_locator_type(locator).eql?(:id) ?execute_js("return $('##{get_locator_value locator}').is(':visible')") : execute_js("return $(\"#{get_locator_value locator}\").is(':visible')")
  end

  def unfocus_element(locator)
    get_locator_type(locator).eql?(:id) ? execute_js("$('##{get_locator_value locator}').blur()") : execute_js("$(\"#{get_locator_value locator}\").blur()")
  end

  def js_is_element_disabled? locator
    get_locator_type(locator).eql?(:id) ?execute_js("return $('##{get_locator_value locator}').is(':disabled')") : execute_js("return $(\"#{get_locator_value locator}\").is(':disabled')")
  end

  def set_DOM_attribute locator,attribute,value
    get_locator_type(locator).eql?(:id) ?execute_js("$('##{get_locator_value locator}').prop('#{attribute}', '#{value}')") : execute_js("$(\"#{get_locator_value locator}\").prop('#{attribute}', '#{value}')")
  end

  def update_DOM_attribute_value locator,attribute,value
    get_locator_type(locator).eql?(:id) ? execute_js("$('##{get_locator_value locator}').attr('#{attribute}', '#{value}')") : execute_js("$(\"#{get_locator_value locator}\").attr('#{attribute}', '#{value}')")
  end

  def get_DOM_attribute_value locator,attribute
    get_locator_type(locator).eql?(:id) ? execute_js("return $('##{get_locator_value locator}').attr('#{attribute}')") : execute_js("return $(\"#{get_locator_value locator}\").attr('#{attribute}')")
  end

  def get_page_background_color
    execute_js("return $('body').css('backgroundColor')")
  end

  def set_dynamic_option_value(locator,option_name,option_value)
    get_locator_type(locator).eql?(:id) ? execute_js("$('##{get_locator_value locator}').append(new Option('#{option_name}', '#{option_value}'))") : execute_js("return $(\"#{get_locator_value locator}\").append(new Option('#{option_name}', '#{option_value}'))")
  end

  def get_element_color locator
    get_locator_type(locator).eql?(:id) ? execute_js("return $('##{get_locator_value locator}').css('color')") : execute_js("return $(\"#{get_locator_value locator}\").css('color')")
  end

  def get_css_property_value locator, property
    get_locator_type(locator).eql?(:id) ? execute_js("return $('##{get_locator_value(locator)}').css('#{property}')") : execute_js("return $('#{get_locator_value(locator)}').css('#{property}')")
  end

  def click_through_JS locator_or_element
    (execute_js("arguments[0].click(0)",(get_web_element locator_or_element)) if locator_or_element.class == Hash) || (execute_js("arguments[0].click(0)",locator_or_element) if locator_or_element.class == Selenium::WebDriver::Element)
  end

  def native_js_set_text(locator,text_to_set)
    get_locator_type(locator).eql?(:id) ? execute_js("document.getElementById('#{get_locator_value locator}').value = '#{text_to_set}';") : execute_js("document.querySelector('#{get_locator_value locator}').value = '#{text_to_set}';")
  end

  def jQuery_click locator
    get_locator_type(locator).eql?(:id) ? execute_js("$('##{get_locator_value locator}').trigger('click')") : execute_js("$(\"#{get_locator_value locator}\").trigger('click')")
  end

  def jquery_input_type_checkbox_checked? locator
    puts get_locator_type(locator).class.name
    case get_locator_type(locator)
    when :id
      execute_js("return $('##{get_locator_value locator}:checked').length")>0
    when :css
      execute_js("return $(\"#{get_locator_value locator}:checked\").length")>0
    end
  end

  def js_set_value locator,text_to_set
    get_locator_type(locator).eql?(:id) ?execute_js("$('##{get_locator_value locator}').val('#{text_to_set}')") : execute_js("$(\"#{get_locator_value locator}\").val('#{text_to_set}')")
  end

  def js_set_value_input_number_type locator,value_to_set
    get_locator_type(locator).eql?(:id) ? execute_js("$('##{get_locator_value locator}').val(#{value_to_set})") : execute_js("$(\"#{get_locator_value locator}\").val(#{value_to_set})")
  end

  def get_text_through_JS locator_or_element
    (execute_js("return arguments[0].innerHTML",(get_web_element locator_or_element)) if locator_or_element.class == Hash) || (execute_js("return arguments[0].innerHTML",locator_or_element) if locator_or_element.class == Selenium::WebDriver::Element)
  end

  def js_select_dropdown_by_text locator, text_to_select
    get_locator_type(locator).eql?(:id) ? execute_js("$('##{get_locator_value locator}').find('option:contains(' + '#{text_to_select}' + ')').attr('selected', 'selected').trigger('change')") : execute_js("$(\"#{get_locator_value locator}\").find('option:contains(' + '#{text_to_select}' + ')').attr('selected', 'selected').trigger('change')")
  end

  def js_dropdown_get_selected_text locator
    get_locator_type(locator).eql?(:id) ? execute_js("return $('##{get_locator_value locator} option:selected').text()") : execute_js("return $(\"#{get_locator_value locator} option:selected\").text()")
  end

  def js_select_input_field_content(locator)
    get_locator_type(locator).eql?(:id) ? execute_js("document.getElementById('#{get_locator_value locator}').select();") : execute_js("document.querySelector('#{get_locator_value locator}').select();")
  end

  def js_dropdown_get_selected_value(locator)
    get_locator_type(locator).eql?(:id) ? execute_js("return $('##{get_locator_value locator} option:selected').val()") : execute_js("return $(\"#{get_locator_value locator} option:selected\").val()")
  end

  def js_get_child_element_contents locator
    get_locator_type(locator).eql?(:id) ? execute_js("return $('##{get_locator_value locator}').children().text()") : execute_js("return $(\"#{get_locator_value locator}\").children().text()")
  end




  #********************************************************************************************************
  #Generic Methods: They don't fall under WebDriver or Javascript, but keeping them here for temporarily. *
  #********************************************************************************************************

  def get_csrf_token_from_page page_source
    csrf_token =[]
    parse_html = Nokogiri::HTML page_source
    parse_html.xpath("//meta[@name='csrf-token']").each  do|t|
      csrf_token.push(t['content'])
    end
    csrf_token.first.to_s
  end

end




