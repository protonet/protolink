# ProtoLink - Access your ProtoNet

ProtoLink is a library for interfacing with ProtoNet, the next-gen internet infrastructure. Truly social and people-powered.

Version: 0.1.0

Sorry, there are no tests at all yet...


## Dependencies

    httparty
    crack

## Usage

    # CHANNELS

    # simple message
    require 'rubygems'
    require 'protolink'

    protonet = Protolink::Protonet.new('HTTP://SUBDOMAIN.DOMAIN.DE', 'USERLOGIN', 'PASSWORD')
    channel  = protonet.channels.first
    channel.speak 'Hello world!'


    # post message in specific channel
    require 'rubygems'
    require 'protolink'

    protonet = Protolink::Protonet.new('SUBDOMAIN.DOMAIN.DE', 'USERLOGIN', 'PASSWORD', :ssl => false)
    channel  = protonet.find_channel_by_name("test")
    channel.speak 'Hello world!'


    # create a channel
    require 'rubygems'
    require 'protolink'

    protonet = Protolink::Protonet.new('SUBDOMAIN.DOMAIN.DE', 'USERLOGIN', 'PASSWORD', :ssl => false)
    channel  = protonet.create_channel("test", "This is the description... woah")
    channel.speak 'Hello world!'


    # find channel by id
    require 'rubygems'
    require 'protolink'

    protonet = Protolink::Protonet.new('SUBDOMAIN.DOMAIN.DE', 'USERLOGIN', 'PASSWORD', :ssl => false)
    channel  = protonet.find_channel(117)
    channel.speak 'Hello world!'


    # find or create a channel
    require 'rubygems'
    require 'protolink'

    protonet = Protolink::Protonet.new('SUBDOMAIN.DOMAIN.DE', 'USERLOGIN', 'PASSWORD', :ssl => false)
    channel  = protonet.find_or_create_channel_by_name("test", "This is the description... woah")
    channel.speak 'Hello world!'


    # USERS

    # find user by login
    require 'rubygems'
    require 'protolink'

    protonet = Protolink::Protonet.new('SUBDOMAIN.DOMAIN.DE', 'USERLOGIN', 'PASSWORD', :ssl => false)
    user     = protonet.find_user_by_login("bjoern.dorra")

    # find user by id
    require 'rubygems'
    require 'protolink'

    protonet = Protolink::Protonet.new('SUBDOMAIN.DOMAIN.DE', 'USERLOGIN', 'PASSWORD', :ssl => false)
    user     = protonet.find_user(117)

    # create a user
    require 'rubygems'
    require 'protolink'

    protonet = Protolink::Protonet.new('SUBDOMAIN.DOMAIN.DE', 'USERLOGIN', 'PASSWORD', :ssl => false)
    user     = protonet.create_user("testuser", "mymassword", "Test-User", "test@test.de")


    # find or create a user
    require 'rubygems'
    require 'protolink'

    protonet = Protolink::Protonet.new('SUBDOMAIN.DOMAIN.DE', 'USERLOGIN', 'PASSWORD', :ssl => false)
    user     = protonet.find_or_create_user_by_login("testuser", "mymassword", "Test-User", "test@test.de")


    # get users auth_token for auto-login
    require 'rubygems'
    require 'protolink'

    protonet = Protolink::Protonet.new('SUBDOMAIN.DOMAIN.DE', 'USERLOGIN', 'PASSWORD', :ssl => false)
    user     = protonet.find_user_by_name("bjoern.dorra")
    user.auth_token
      => "A19zNgCzgv4RGDGPc2mL" 


    # LISTENS

    # create a listen
    require 'rubygems'
    require 'protolink'

    protonet   = Protolink::Protonet.new('SUBDOMAIN.DOMAIN.DE', 'USERLOGIN', 'PASSWORD', :ssl => false)
    user       = protonet.find_user_by_login("bjoern.dorra")
    channel    = protonet.find_channel_by_name("test")
    protonet.create_listen(user.id, channel.id)

    # destroy a listen
    require 'rubygems'
    require 'protolink'

    protonet   = Protolink::Protonet.new('SUBDOMAIN.DOMAIN.DE', 'USERLOGIN', 'PASSWORD', :ssl => false)
    user       = protonet.find_user_by_login("bjoern.dorra")
    channel    = protonet.find_channel_by_name("test")
    protonet.destroy_listen(user.id, channel.id)


    # CREATE AND SUBSCRIBE

    require 'rubygems'
    require 'protolink'

    protonet   = Protolink::Protonet.new('localhost:3000', 'bjoern.dorra', 'geheim')

    user       = protonet.find_or_create_user_by_login("johndoe", "password", "JohnDoe", "john@doe.com")
    auth_token = user.auth_token
    channel    = protonet.find_or_create_channel_by_name("test", "This is a test channel!")
    protonet.create_listen(user.id, channel.id)
    "\nhttp://localhost:3000/?auth_token=#{auth_token}"


## Installation

    gem install protolink


## How to contribute

If you find what looks like a bug:

1. Check the GitHub issue tracker to see if anyone else has had the same issue.
   http://github.com/protonet/protolink/issues/
2. If you don't see anything, create an issue with information on how to reproduce it.

If you want to contribute an enhancement or a fix:

1. Fork the project on github.
   http://github.com/protonet/protolink
2. Make your changes with tests.
3. Commit the changes without making changes to the Rakefile, VERSION, or any other files that aren't related to your enhancement or fix
4. Send a pull request.
