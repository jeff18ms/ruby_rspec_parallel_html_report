require 'mail'
require 'gmail'
require 'waitutil'

module Emails

  def replace_mime_message
    rep = File.join(Gem::Specification.find_by_name('gmail').full_gem_path)+ "/lib/gmail/message.rb"
    IO.write(rep, File.open(rep) do |f|
      f.read.gsub('require \'mime/message\'','')
    end
    )
  end

  def delete_all_emails
    replace_mime_message
    gmail = Gmail.connect(get_sf_registered_user_name, get_gmail_password)
    gmail.inbox.emails(:all).each do |email|
      email.delete!
    end
    gmail.logout
  end

  def delete_email_by_subject subject
    replace_mime_message
    gmail = Gmail.connect(get_sf_registered_user_name, get_gmail_password)
    gmail.inbox.find(subject: subject).each do |email|
      email.delete!
    end
    gmail.logout
  end

  def convert_email_body_to_text(email_body)
    Nokogiri::HTML(email_body.decoded.to_s).text
  end

  def find_and_return_email_body(subject)
    replace_mime_message
    gmail = Gmail.connect(get_sf_registered_user_name, get_gmail_password)
    loop_sleep_time = 20 # seconds

    10.times do
      sleep loop_sleep_time
      return gmail.inbox.find(subject: subject).first.body unless gmail.inbox.find(subject: subject).empty?
    end
  end

  def find_email_by_subject(subject)
    replace_mime_message
    gmail = Gmail.connect(get_sf_registered_user_name, get_gmail_password)
    loop_sleep_time = 20 # seconds

    10.times do
      sleep loop_sleep_time
      return gmail.inbox.find(subject: subject).first unless gmail.inbox.find(subject: subject).empty?
    end
  end

end




