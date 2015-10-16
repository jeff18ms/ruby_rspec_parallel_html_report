require_relative '../spec/spec_helper'
require_relative '../lib/yaml_properties_holder'

class AmazonPageObjects
  def self.properties_file
    Constants.const_get(:AMAZON_PAGE_OBJECTS)
  end
  extend YAMLPropertiesHolder
end





