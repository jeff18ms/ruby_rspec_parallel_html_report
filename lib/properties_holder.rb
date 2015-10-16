#
# The `properties-ruby` gem defines a Utils::Properties class
# but that class does not have #keys method.
#
module Utils
  class Properties
    def keys
      props.map {|key,property| key }
    end
  end
end


module PropertiesHolder

  def self.extended(base)
    base.properties.keys.each do |method_name|
      base.define_property(method_name)
    end
  end

  def define_property(name)
    define_method name do
      self.class.properties.get(name,true).to_s
    end
  end

  def properties
    @properties ||= Utils::Properties.load_from_file(properties_file)
  end

end