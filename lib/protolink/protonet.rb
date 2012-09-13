require 'httparty'

module Protolink
  
  #   protonet = Protolink::Protonet.new 'domain', :user => 'john.doe', :password => 'secret', :token => 'xyz'
  #
  #   channel = protonet.find_channel_by_name 'home'
  #   channel.speak 'Hello world!'
  class Protonet
    include HTTParty
    class ApiException < RuntimeError; end
    
    # Create a new connection to the account with the given +uri+.
    #
    # == Options:
    # * +:username+: your api users username
    # * +:password+: your api users password
    # * +:proxy+: a hash with your proxy options (e.g. {:uri => 'http://user:pass@example.com', :port => 8800})
    #
    def self.open(uri, username = nil, password = nil, proxy = nil)
      # this allows you to use the httparty class helpers (base_uri...) with multiple connections
      clazz = self.dup
      clazz.base_uri(uri)
      clazz.basic_auth(username, password) if username && password
      if proxy
        clazz.http_proxy(proxy[:uri], proxy[:port])
      end
      clazz.new(username)
    end
    
    # CHANNELS
    
    def initialize(username)
      @current_user_name = username
      super()
    end
    
    def current_user
      @current_user ||= find_user_by_login(@current_user_name)
    end
    
    # Get an array of all the available channels
    def channels
      get('/api/v1/channels').map do |channel|
        Channel.new(self, channel)
      end
    end

    # Creates and returns a new Channel with the given +name+ and optionally a +description+
    def create_channel(options={})
      name          = options[:name] || raise(ArgumentError, "Please provide a name for the channel")
      description   = options[:description]
      display_name  = options[:display_name]
      skip_autosubscribe = options[:skip_autosubscribe]
      global = options[:global]
      post('/api/v1/channels', :body => { :name => name, :description => description, :display_name => display_name, :skip_autosubscribe => skip_autosubscribe, :global => global } )
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
      response = get("/api/v1/channels/find_by_name/#{name}")
      Channel.new(self, response) if response
    end
    
    def find_channel_by_uuid(uuid)
      response = get("/api/v1/channels/find_by_uuid/#{uuid}")
      Channel.new(self, response) if response
    end
    
    def create_rendezvous(first_user_id, second_user_id)
      response = post('/api/v1/rendezvous', :body => { :first_user_id => first_user_id, :second_user_id => second_user_id } )
      Channel.new(self, response) if response
    end
    
    def find_rendezvous(first_user_id, second_user_id)
      response = get('/api/v1/rendezvous', :query => {:first_user_id => first_user_id, :second_user_id => second_user_id})
      Channel.new(self, response) if response
    end

    def global_channels
      response = get('/api/v1/channels?global=true')
      
      response && response.map do |channel|
        Channel.new(self, channel)
      end
    end

    # AUTHENTICATION

    def auth
      get('/api/v1/users/auth')
    end

    def reset_password email, host = nil
      get('/api/v1/users/reset_password', :query => {:user => {:login => email}, :host => host })
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
      login                 = options[:login] || raise(ArgumentError, "Please provide a login for this user")
      password              = options[:password]
      name                  = options[:name]
      email                 = options[:email] || raise(ArgumentError, "Please provide an email for this user")
      avatar_url            = options[:avatar_url]
      external_profile_url  = options[:external_profile_url]
      channels              = options[:channels]
      if channels
        # not implemented yet
        no_channels = "true"
      else
        no_channels = "false"
      end
      post('/api/v1/users', :body => {:login => login, :name => name, :password => password, :email => email, :avatar_url => avatar_url, :no_channels => no_channels, :channels_to_subscribe => nil, :external_profile_url => external_profile_url } )
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
      response = get("/api/v1/users/find_by_login/#{login}")
      User.new(self, response) if response
    end
    
    def find_subscribed_channels
      response = get("/api/v1/channels").map do |channel|
        Channel.new(self, channel)
      end
    end

    # LISTENS
    def create_listen(user_id, channel_id)
      channel_query = channel_id.to_s.match("-") ? {:channel_uuid => channel_id} : {:channel_id => channel_id}
      post('/api/v1/listens', :body => {:user_id => user_id}.merge(channel_query) )
    end

    def destroy_listen(user_id, channel_id)
      channel_query = channel_id.to_s.match("-") ? {:channel_uuid => channel_id} : {:channel_id => channel_id}
      delete('/api/v1/listens', :body => {:user_id => user_id}.merge(channel_query) )
    end
    
    def couple(node_data)
      response = post("/api/v1/couplings", :body => {:node_data => node_data})
      [User.new(self, response[0]), response[1]] if response
    end
    
    # MEEPS
    
    def find_meeps_by_channel channel_id, limit = nil, offset = nil
      response = get("/api/v1/channels/#{channel_id}/meeps?limit=#{limit}&offset=#{offset}").map do |meep|
        Meep.new(self, meep)
      end
    end
    
    # NODE
    
    def node
      response = get("/api/v1/nodes/1")
      Node.new(self, response) if response
    end
    
    def socket(&blk)
      EventMachine.run {
        EventMachine.connect URI.parse(self.class.base_uri).host, 5000, ProtoSocket, self, blk
      }
    end
    
    [:get, :post, :update, :delete].each do |method|
      class_eval <<-EOS
        def #{method}(uri, options = {})
          response = self.class.#{method}(uri, options)
          if response.code.to_s.match(/2../)
            response
          else
            response['errors'] ? raise(ApiException, response['errors']) : nil
          end
        end
      EOS
    end

  end
end
