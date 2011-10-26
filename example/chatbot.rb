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
  response = Linkbot::Plugin.handle_message(Message.new(json["message"], json["user_id"], json["author"], :message)) if json["trigger"] == "meep.receive"
  unless response.blank?
    c = protonet.find_channel(json["channel_id"])
    c.speak(response.first)
  end
end
