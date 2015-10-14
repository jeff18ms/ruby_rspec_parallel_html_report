require_relative '../spec/spec_helper'
require_relative '../page_objects_and_ui_html_locators/yaml_properties_holder'

class AmazonPageObjects
  def self.properties_file
    Constants.const_get(:AMAZON_PAGE_OBJECTS)
  end
  extend YAMLPropertiesHolder
end





