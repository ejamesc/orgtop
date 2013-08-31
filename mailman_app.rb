require 'mailman'

settings_yaml = YAML.load_file("config.yml")["production"]

Mailman.config.rails_root = nil
Mailman.config.pop3 = {
  username: settings_yaml["gmail_email"],
  password: settings_yaml["gmail_password"],
  server: 'pop.gmail.com',
  port: 995, # defaults to 110
  ssl: true
}
Mailman.config.graceful_death = true
Mailman.config.poll_interval = 20

Mailman::Application.run do
  to 'orgtop@(linuxnus.org|nushackers.org)' do
    puts "Email Received!"
  end

end
