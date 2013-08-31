orgtop
======
Top for humans in organizations. Sends email once a week, prompting for a summary of activities, then emails a digest at the end of the day.

Dev notes
---------
Create a database called 'orgtop_dev'

Create a config.yml file with the following properties:

```
development:
  mysql_user: "mysql_user"
  mysql_password: "mysql_password"  
  gmail_email: "gmail_email"
  gmail_password: "gmail_password"
  
production:
  mysql_user: "mysql_user"
  mysql_password: "mysql_password"  
  gmail_email: "gmail_email"
  gmail_password: "gmail_password"
```

Do a `bundle install`, then a `brew install beanstalkd`

