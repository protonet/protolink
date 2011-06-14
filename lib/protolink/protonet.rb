module Protolink

  #   protonet = Protolink::Protonet.new 'domain', :user => 'john.doe', :password => 'secret', :token => 'xyz'
  #
  #   channel = protonet.find_channel_by_name 'home'
  #   channel.speak 'Hello world!'
  class Protonet
    attr_reader :connection

    # Create a new connection to the account with the given +domain+.
    #
    # == Options:
    # * +:ssl+: use SSL for the connection, which is required if you have a Protonet SSL account.
    #           Defaults to false
    # * +:proxy+: a proxy URI. (e.g. :proxy => 'http://user:pass@example.com:8000')
    #
    def initialize(domainname, username, password, options = {})
      @connection = Connection.new(domainname, username, password, options)
    end


    # CHANNELS

    # Get an array of all the available channels
    def channels
      s = connection.get('/api/v1/channels.json')
      s = Hash["channels", s]
      s['channels'].map do |channel|
        Channel.new(connection, channel)
      end
    end

    # Find a Channel by name
    def find_channel_by_name(name)
      channels.detect { |channel| channel.name == name }
    end

    # Creates and returns a new Channel with the given +name+ and optionally a +description+
    def create_channel(name, description = nil)
      connection.post('/api/v1/channels/create.json', {  :name => name, :description => description } )
      find_channel_by_name(name)
    end

    def find_or_create_channel_by_name(name, description = nil)
      find_channel_by_name(name) || create_channel(name, description)
    end


    # USERS
    
    # Get an array of all the available users
    def users
      s = connection.get('/api/v1/users.json')
      s = Hash["users", s]
      s['users'].map do |user|
        User.new(connection, user)
      end
    end

    # Creates and returns a new user with the given attributes
    def create_user(login, password, name, email, avatar_url = nil, channels = nil)
      connection.post('/api/v1/users/create.json', {:login => login, :name => name, :password => password, :email => email, :avatar_url => avatar_url, :channels => channels } )
      find_user_by_login(login)
    end

    # Find a user by name
    def find_user_by_login(login)
      users.detect { |user| user.login == login }
    end

    def find_or_create_user_by_login(login, password, name, email, avatar_url = nil, channels = nil)
      find_user_by_login(name) || create_user(login, password, name, email, avatar_url = nil, channels = nil)
    end


    # LISTENS
    def create_listen(user_id, channel_id)
      connection.post('/api/v1/listens/create.json', {:user_id => user_id, :channel_id => channel_id } )
    end

    def destroy_listen(user_id, channel_id)
      connection.post('/api/v1/listens/destroy.json', {:user_id => user_id, :channel_id => channel_id } )
    end

  end
end
