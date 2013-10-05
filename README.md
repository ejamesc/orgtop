orgtop
======
Top for humans in organizations. Sends email once a week, prompting for a summary of activities, then emails a digest at the end of the day.

Dev notes
---------
Create a database called 'shadowsun7_orgtop' (Or change the database url in
`environment.rb` - forgive me, I was too lazy to generalize this). Run `rake db:upgrade`

Create a config.yml file with the following properties:

```
development:
  mysql_user: "mysql_user"
  mysql_password: "mysql_password"  
  gmail_email: "gmail_email"
  gmail_password: "gmail_password"
  coreteam_email: "coreteam_email"
  prompt_time: "this week monday 7:30" # chronic parseable date time
  digest_time: "this week monday 21:00" 
  username: "A username for login"
  token: "A long random string of numbers and letters"
  password: "A password for login"

production:
  mysql_user: "mysql_user"
  mysql_password: "mysql_password"  
  gmail_email: "gmail_email"
  gmail_password: "gmail_password"
  coreteam_email: "coreteam_email"
  prompt_time: "this week monday 7:30"
  digest_time: "this week monday 21:00" 
  username: "A username for login"
  token: "A long random string of numbers and letters"
  password: "A password for login"
```

Do a `bundle install`, then install beanstalkd

To run orgtop, ensure beanstalkd is running, then `stalk jobs.rb` and `clockwork clock.rb`. You may start the webapp with `rerun application.rb`.
