require 'httparty'

module Protolink

  #   protonet = Protolink::Protonet.new 'domain', :user => 'john.doe', :password => 'secret', :token => 'xyz'
  #
  #   channel = protonet.find_channel_by_name 'home'
  #   channel.speak 'Hello world!'
  class Protonet
    include HTTParty
    
    # Create a new connection to the account with the given +uri+.
    #
    # == Options:
    # * +:username+: your api users username
    # * +:password+: your api users password
    # * +:proxy+: a hash with your proxy options (e.g. {:uri => 'http://user:pass@example.com', :port => 8800})
    #
    def self.open(uri, username, password, proxy = nil)
      # this allows you to use the httparty class helpers (base_uri...) with multiple connections
      clazz = self.dup
      clazz.base_uri(uri)
      clazz.basic_auth(username, password)
      if proxy
        clazz.http_proxy(proxy[:uri], proxy[:port])
      end
      clazz.new
    end
    
    # CHANNELS

    # Get an array of all the available channels
    def channels
      get('/api/v1/channels.json').map do |channel|
        Channel.new(self, channel)
      end
    end

    # Creates and returns a new Channel with the given +name+ and optionally a +description+
    def create_channel(options={})
      name        = options[:name] || raise(ArgumentError, "Please provide a name for the channel")
      description = options[:description]
      skip_autosubscribe = options[:skip_autosubscribe]
      post('/api/v1/channels', :body => { :name => name, :description => description, :skip_autosubscribe => skip_autosubscribe } )
      find_channel_by_name(name)
    end

    def find_or_create_channel_by_name(name, options = {})
      find_channel_by_name(name) || create_channel({:name => name}.merge(options))
    end

    # Find a Channel by id
    def find_channel(id)
      response = get("/api/v1/channels/#{id}")
      Channel.new(self, response) if response
    end

    # Find a Channel by name
    def find_channel_by_name(name)
      response = get("/api/v1/channels/#{name}")
      Channel.new(self, response) if response
    end

    # USERS
    
    # Get an array of all the available users
    def users
      get('/api/v1/users.json').map do |user|
        User.new(self, user)
      end
    end

    # Creates and returns a new user with the given attributes
    def create_user(options)
      login       = options[:login] || raise(ArgumentError, "Please provide a login for this user")
      password    = options[:password]
      name        = options[:name]
      email       = options[:email] || raise(ArgumentError, "Please provide an email for this user")
      avatar_url  = options[:avatar_url]
      profile_url = options[:profile_url]
      channels    = options[:channels]
      if channels
        # not implemented yet
        no_channels = "true"
      else
        no_channels = "true"
      end
      post('/api/v1/users', :body => {:login => login, :name => name, :password => password, :email => email, :avatar_url => avatar_url, :no_channels => no_channels, :channels_to_subscribe => nil } )
      find_user_by_login(login)
    end

    def find_or_create_user_by_login(login, options = {})
      find_user_by_login(login) || create_user({:login => login}.merge(options))
    end

    # Find a user by id
    def find_user(id)
      response = get("/api/v1/users/#{id}")
      User.new(self, response) if response
    end
    
    def find_user_by_login(login)
      response = get("/api/v1/users/#{login}")
      User.new(self, response) if response
    end

    # LISTENS
    def create_listen(user_id, channel_id)
      post('/api/v1/listens', :body => {:user_id => user_id, :channel_id => channel_id } )
    end

    def destroy_listen(user_id, channel_id)
      delete('/api/v1/listens', :body => {:user_id => user_id, :channel_id => channel_id } )
    end
    
    [:get, :post, :update, :delete].each do |method|
      class_eval <<-EOS
        def #{method}(uri, options = {})
          response = self.class.#{method}(uri, options)
          response.code.to_s.match(/2../) ? response : nil
        end
      EOS
    end

  end
end
