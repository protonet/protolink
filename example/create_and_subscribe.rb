$LOAD_PATH.unshift "#{File.dirname(__FILE__)}/../lib"

require 'rubygems'
require 'protolink'

# FOR MORE CURRENT EXAMPLES PLEASE CHECK test/all_tests.rb - THANKS!

protonet   = Protolink::Protonet.open('http://localhost:3000', 'admin', 'admin')

user       = protonet.find_or_create_user_by_login("johndoe", :password => "password", :name => "John Doe", :email => "john@doe.com")
auth_token = user.auth_token
puts       "user_id     : #{user.id}"
puts       "user_login  : #{user.login}"
puts       "auth_token  : #{auth_token}"

channel    = protonet.find_or_create_channel_by_name("test", :description => "This is a test channel!")
puts       "channel_id  : #{channel.id}"
puts       "channel_name: #{channel.name}"
puts       "channel_desc: #{channel.description}"

protonet.create_listen(user.id, channel.id)

puts       "\nhttp://localhost:3000/?auth_token=#{auth_token}"
