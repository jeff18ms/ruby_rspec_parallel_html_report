
# Gems
require 'rubygems'
require 'nokogiri/nokogiri'
require 'selenium-webdriver'
require 'net/pop'
require 'properties-ruby'
require 'yaml'
require 'rspec_junit_formatter'
require 'yarjuf'
require 'byebug'
require 'rest_client'
require 'securerandom'
require 'savon'
require 'madison'
require 'logger'
require 'rspec/core'
require 'rspec/expectations'
require  'rspec/matchers'
require 'mail'
require 'i18n'
require 'ffaker'
require 'selenium/webdriver/remote/http/persistent'
require 'csv'
require 'madmimi'


Dir[File.expand_path('lib/common/*.rb')].each { |f| require f }
require_relative  '../page_objects_and_ui_html_locators/page_objects_aggregator'
Dir[File.expand_path('page_objects_and_ui_html_locators/pageobjects/amazon/*.rb')].each { |f| require f }
Dir[File.expand_path('spec/helpers/amazon/*.rb')].each { |f| require f }


RSpec.configure do |config|
  config.include Configuration
  config.include Constants
  config.include Emails
  config.include SeleniumWebdriver::WebDriverConnector
  config.include JavascriptConnector

  config.include Amazon::PageObjects
  config.include Amazon::AmazonHelper

  config.expose_current_running_example_as :example
end

