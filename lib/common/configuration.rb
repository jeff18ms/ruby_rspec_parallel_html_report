require_relative '../../spec/spec_helper'
require_relative '../common/constants'

module Configuration
  @@props = Utils::Properties.load_from_file (File.absolute_path(Constants::CONFIG_PROPERTIES))

  def environment
    @@props.get(:ENV,true).to_s
  end

  def self.env
    @env = @@props.get(:ENV,true).to_s
    @env
  end

  def browser_type
    @@props.get(:BROWSER_TYPE,true)
  end

  def driver_type
    @@props.get(:WEB_DRIVER_TYPE,true).to_sym
  end

  def hub_ip
    @@props.get(:HUB_IP,true).to_sym
  end

  def hub_host
    @@props.get(:HUB_HOST,true).to_sym
  end

  def gmail_id
    @@props.get(:GMAIL_ID,true)
  end

  def gmail_password
    @@props.get(:GMAIL_PWD,true)
  end



end

