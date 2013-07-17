require 'stalker'
require 'pony'
include Stalker

CONFIG_FILE = Dir.pwd + "/config.yml"
EMAIL_USERNAME = YAML.load_file(CONFIG_FILE)["production"]['gmail_email']
EMAIL_PASSWORD = YAML.load_file(CONFIG_FILE)["production"]['gmail_password']

job 'send.prompt' do |args|
  send_email("ejames@nushackers.org", "[orgtop] Hello World", "Hello there, this is orgtop speaking.")
end

job 'send.digest' do |args|
  send_email("ejames@nushackers.org", "[orgtop] Daily Summary", "HTML body for the daily summary goes here")
end

def send_email(email_add, subject, body)
  Pony.mail({
    :to => email_add,
    :subject => subject,
    :body => body,
    :via => :smtp,
    :via_options => {
      :address              => 'smtp.gmail.com',
      :port                 => '587',
      :enable_starttls_auto => true,
      :user_name            => EMAIL_USERNAME,
      :password             => EMAIL_PASSWORD,
      :authentication       => :plain, 
      :domain               => "localhost.localdomain", # the HELO domain provided by the client to the server
    }
  })
end
