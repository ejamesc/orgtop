require 'stalker'
require 'pony'
require 'chronic'
require File.join(File.dirname(__FILE__), 'environment')
include Stalker

CONFIG_YAML = YAML.load_file(File.join(File.dirname(__FILE__), "config.yml"))
EMAIL_USERNAME = CONFIG_YAML["production"]['gmail_email']
EMAIL_PASSWORD = CONFIG_YAML["production"]['gmail_password']
CORETEAM_EMAIL = CONFIG_YAML["production"]['coreteam_email']

def with_time_zone(tz_name) 
  prev_tz = ENV['TZ']
  ENV['TZ'] = tz_name
  yield
ensure
  ENV['TZ'] = prev_tz
end

PROMPT_TIME = with_time_zone("Asia/Singapore") { Chronic.parse(CONFIG_YAML["production"]['prompt_time']) }

# Jobs Definition
job 'send.prompt' do |args|
  User.all.each do |user|
    send_email(user.email, "[orgtop] What happened over the past week?", "Hello #{user.name}!\n\nIt's time for you to make your weekly orgtop update. My records show that you're the #{user.role} for NUS Hackers. Respond to this email with a short update of events related to your responsibilities over the past week, and I'll add it to an update digest for coreteam on Monday night.\n\nWarmly,\nYour friendly neighbourhood orgtop.")
  end
end

job 'send.digest' do |args|
  html_digest = construct_html_digest

  if html_digest
    send_email(CORETEAM_EMAIL, "[orgtop] NUS Hackers Weekly Summary", nil, html_digest)
  else
    send_email("ejames@nushackers.org", "[orgtop] No Responses for Weekly Summary", "orgtop would like to inform the administrator that the lookup for responses to construct the orgtop weekly summary has failed.")
  end
end

def send_email(email_add, subject, body, html_body=nil)
  mail_args = {
    :to => email_add,
    :subject => subject,
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
  }

  mail_args.merge!(body: body) if body
  mail_args.merge!(html_body: html_body) if html_body

  Pony.mail(mail_args)
end

def construct_html_digest
  head = "<h2>[orgtop] NUS Hackers Weekly Summary</h2>
  <p>This is a summary of all responses from active coreteam members on their activities of the past week.</p>"
  body = ""
  tail = "<p>Report generated by orgtop. If you don't see your response here, you've either missed the response window, or sent an email from a non-NUS Hackers email address. Submit bug reports and pull requests to orgtop's <a href='https://github.com/ejamesc/orgtop'>Github repository</a>.</p>"

  responses = Response.all(:created_at.gte => PROMPT_TIME)
  return nil if responses.count == 0

  responses.each do |res|
    response_html = "
    <p><strong>#{res.user.name}</strong>, (#{res.user.role}):</p>
    <p>#{res.content.gsub(/\n/, "<br/>")}</p>
    <hr/>"
    body += response_html
  end
  
  head + body + tail
end
