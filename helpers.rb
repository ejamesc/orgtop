# Strips out mail headers, replies and quotes and returns only the mail body
def process_message(mail)
  if mail.multipart?
    part = mail.parts.select { |p| p.content_type =~ /text\/plain/ }.first rescue nil
    unless part.nil?
      message = part.body.decoded
    end
  else
    message = mail.body.decoded
  end

  extract_msg = MailExtract.new(message).body
  encode_string(extract_msg)
end

# Deal with unicode strings
def encode_string(str)
  encoding_options = {
    :invalid           => :replace,  # Replace invalid byte sequences
    :undef             => :replace,  # Replace anything not defined in ASCII
    :replace           => '',        # Use a blank for those replacements
    :universal_newline => true       # Always break lines with \n
  }
  str.encode Encoding.find('ASCII'), encoding_options
end

# Helper function to use the right timezone within a given block
def with_time_zone(tz_name) 
  prev_tz = ENV['TZ']
  ENV['TZ'] = tz_name
  yield
ensure
  ENV['TZ'] = prev_tz
end
