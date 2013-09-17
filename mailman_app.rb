require 'mailman'
require 'chronic'
require 'mail_extract'
require File.join(File.dirname(__FILE__), 'environment')

settings_yaml = YAML.load_file(File.join(File.dirname(__FILE__), "config.yml"))["production"]

# Strips out mail headers, replies and quotes and returns only the mail body
def process_message(mail)
  if mail.multipart?
    part = mail.parts.select { |p| p.content_type =~ /text\/plain/ }.first rescue nil
    unless part.nil?
      message = part.body.decoded
    end
  else
    message = mail.body.decoded
  end

  extract_msg = MailExtract.new(message).body
  encode_string(extract_msg)
end

def encode_string(str)
  encoding_options = {
    :invalid           => :replace,  # Replace invalid byte sequences
    :undef             => :replace,  # Replace anything not defined in ASCII
    :replace           => '',        # Use a blank for those replacements
    :universal_newline => true       # Always break lines with \n
  }
  str.encode Encoding.find('ASCII'), encoding_options
end

def with_time_zone(tz_name) 
  prev_tz = ENV['TZ']
  ENV['TZ'] = tz_name
  yield
ensure
  ENV['TZ'] = prev_tz
end

# Mailman configuration
Mailman.config.rails_root = nil
Mailman.config.logger = Logger.new(File.join(File.dirname(__FILE__), "mailman.log"))
Mailman.config.pop3 = { username: settings_yaml["gmail_email"],
  password: settings_yaml["gmail_password"],
  server: 'pop.gmail.com',
  port: 995, # defaults to 110
  ssl: true
}
Mailman.config.graceful_death = true
Mailman.config.poll_interval = 300

# Chronic settings
timezone = "Asia/Singapore"

Mailman::Application.run do
  from(/(.*)@(linuxnus.org|nushackers.org)/) do |username|
    prompt_time = with_time_zone(timezone) { Chronic.parse(settings_yaml["prompt_time"]) }
    digest_time = with_time_zone(timezone) { Chronic.parse(settings_yaml["digest_time"]) } 

    # if current time is between nearest prompt time and digest time
    if Time.now > prompt_time && Time.now < digest_time
      user = User.first(username: username)
      if user
        Mailman.logger.info "About to save email from #{user.name} with username #{username}"
        msg_body = process_message(message)
        user.responses.create(content: msg_body)
      end
    end
  end

  default do
    Mailman.logger.info "Email miss. Hit default method instead."
  end
end
