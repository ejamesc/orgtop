God.watch do |w|
  w.name = "stalker"
  w.group = "emails"
  w.start = "stalk /home/shadowsun7/webapps/orgtop/orgtop/jobs.rb"
  w.keepalive(:memory_max => 50.megabytes)
end

God.watch do |w|
  w.name = "clockwork"
  w.group = "emails"
  w.start = "clockwork /home/shadowsun7/webapps/orgtop/orgtop/clock.rb"
  w.keepalive(:memory_max => 40.megabytes)
end

God.watch do |w|
  w.name = "mailman"
  w.group = "emails"
  w.start = "ruby /home/shadowsun7/webapps/orgtop/orgtop/mailman_app.rb"
  w.keepalive(:memory_max => 50.megabytes)
end
