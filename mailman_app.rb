require 'mailman'
require 'chronic'
require File.join(File.dirname(__FILE__), 'helpers')
require File.join(File.dirname(__FILE__), 'environment')

settings_yaml = YAML.load_file(File.join(File.dirname(__FILE__), "config.yml"))["production"]

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
    time_now = with_time_zone(timezone) { Time.now }

    Mailman.logger.info "Time now is: #{time_now} prompt_time is: #{prompt_time} and digest_time is: #{digest_time}"

    user = User.first(username: username)
    if user
      Mailman.logger.info "About to save email from #{user.name} with username #{username}"
      msg_body = process_message(message)
      user.responses.create(content: msg_body)
    end
  end

  default do
    Mailman.logger.info "Email miss. Hit default method instead."
  end
end
