require 'mailman'
require 'chronic'
require 'mail_extract'
require File.join(File.dirname(__FILE__), 'environment')

settings_yaml = YAML.load_file("config.yml")["production"]

def process_message(mail)
  if mail.multipart?
    part = mail.parts.select { |p| p.content_type =~ /text\/html/ }.first rescue nil
    unless part.nil?
      message = part.body.decoded
    end
  else
    message = mail.body.decoded
  end
  MailExtract.new(message).body
end

Mailman.config.rails_root = nil
#Mailman.config.logger = Logger.new("mailman.log")
Mailman.config.pop3 = { username: settings_yaml["gmail_email"],
  password: settings_yaml["gmail_password"],
  server: 'pop.gmail.com',
  port: 995, # defaults to 110
  ssl: true
}
Mailman.config.graceful_death = true
Mailman.config.poll_interval = 10 # change to something logical for production

Mailman::Application.run do
  from(/(.*)@(linuxnus.org|nushackers.org)/) do |username|
    prompt_time = Chronic.parse(settings_yaml["prompt_time"])
    digest_time = Chronic.parse(settings_yaml["digest_time"])
    current_time = Time.now

    #Mailman.logger.info "Successfully entered method body with username #{username}"
    #Mailman.logger.info "Prompt time: #{prompt_time}, Digest time: #{digest_time}, Current time: #{current_time} Boolean: #{current_time > prompt_time && current_time < digest_time}"

    # if current time is between nearest prompt time and digest time
    if current_time > prompt_time && current_time < digest_time
      user = User.first(username: username)
      if user
        msg_body = process_message(message)
        user.responses.create(content: msg_body)
      end
    end
  end

  default do
    Mailman.logger.info "Hit default method instead."
  end
end
