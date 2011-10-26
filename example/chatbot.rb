$LOAD_PATH.unshift "#{File.dirname(__FILE__)}/../lib"

require 'rubygems'
require 'protolink'
require 'linkbot/base_plugins'

# require 'ruby-debug'
# Debugger.start

# from https://github.com/markolson/linkbot
Linkbot::Plugin.collect

# change this if you need to connect to another server
PTN_SERVER = "http://localhost:3000"
PTN_USER   = "admin"
PTN_PASS   = "admin"
protonet = Protolink::Protonet.open(PTN_SERVER, PTN_USER, PTN_PASS)
protonet.socket do |json|
  if json["trigger"] == "meep.receive" && json["user_id"] != protonet.current_user.id.to_s
    response = Linkbot::Plugin.handle_message(Message.new(json["message"], json["user_id"], json["author"], :message)) 
  end
  unless response.blank?
    c = protonet.find_channel(json["channel_id"])
    response = response.first
    if response.is_a?(Hash)
      image_url = (response[:image] || response[:images].first)
      text_extension = {
        "title"         => "bot",
        "titleAppendix" => "image",
        "url"           => image_url,
        "type"          => "Image",
        "image"         => image_url
      }
      c.speak("", :text_extension => text_extension) if image_url
    else
      c.speak(response)
    end
  end
end
