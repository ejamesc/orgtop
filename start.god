God.watch do |w|
  w.name = "stalker"
  w.group = "emails"
  w.start = "/home/shadowsun7/webapps/orgtop/bin/stalk /home/shadowsun7/webapps/orgtop/orgtop/jobs.rb"
  w.keepalive(:memory_max => 50.megabytes)
  w.behavior(:clean_pid_file)
end

God.watch do |w|
  w.name = "clockwork"
  w.group = "emails"
  w.start = "/home/shadowsun7/webapps/orgtop/bin/clockwork /home/shadowsun7/webapps/orgtop/orgtop/clock.rb"
  w.keepalive(:memory_max => 40.megabytes)
  w.behavior(:clean_pid_file)
end

God.watch do |w|
  w.name = "mailman"
  w.group = "emails"
  w.start = "ruby /home/shadowsun7/webapps/orgtop/orgtop/mailman_app.rb"
  w.keepalive(:memory_max => 50.megabytes)
  w.behavior(:clean_pid_file)
end

God.watch do |w|
  w.name = "beanstalkd"
  w.group = "emails"
  w.start = "/home/shadowsun7/beanstalkd/beanstalkd"
  w.keepalive(:memory_max => 50.megabytes)
  w.behavior(:clean_pid_file)
end
