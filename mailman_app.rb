require 'mailman'
require 'chronic'

settings_yaml = YAML.load_file("config.yml")["production"]

Mailman.config.rails_root = nil
Mailman.config.pop3 = { username: settings_yaml["gmail_email"],
  password: settings_yaml["gmail_password"],
  server: 'pop.gmail.com',
  port: 995, # defaults to 110
  ssl: true
}
Mailman.config.graceful_death = true
Mailman.config.poll_interval = 20

Mailman::Application.run do
  to 'orgtop@(linuxnus.org|nushackers.org)'.from('%user%@(linuxnus.org|nushackers.org)') do |username|
    prompt_time = Chronic.parse("this week monday 7:30")
    digest_time = Chronic.parse("this week monday 21:00")
    current_time = Time.now

    # if current time is between nearest prompt time and digest time
    if current_time > prompt_time && current_time < digest_time
      user = User.first(username: username)
      user.responses.create(content: message)
    end
  end

end
