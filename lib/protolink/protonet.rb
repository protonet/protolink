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
    
    def projects
      get('/api/v1/projects').map do |project|
        Project.new(self, project)
      end
    end

    # Creates and returns a new Channel with the given +name+ and optionally a +description+
    def create_project(name)
      post('/api/v1/projects', :body => { :name => name } )
      find_project_by_name(name)
    end

    def find_or_create_project_by_name(name, options = {})
      find_channel_by_name(name) || create_channel({:name => name}.merge(options))
    end

    # Find a Channel by id
    def find_project(id)
      response = get("/api/v1/projects/#{id}")
      Project.new(self, response) if response
    end

    # Find a Channel by name
    def find_project_by_name(name)
      response = get("/api/v1/projects/find_by_name", :query => {:name => name})
      Project.new(self, response) if response
    end

    def find_topic(id)
      response = get("/api/v1/topics/#{id}")
      Topic.new(self, response) if response
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
      first_name            = options[:first_name] || raise(ArgumentError, "Please provide a first name for this user")
      last_name             = options[:last_name] || raise(ArgumentError, "Please provide a last name for this user")
      password              = options[:password]
      email                 = options[:email] || raise(ArgumentError, "Please provide an email for this user")
      post('/api/v1/users', :body => {
        :first_name => first_name,
        :last_name => last_name,
        :password => password,
        :email => email
      })
      find_user_by_email(email)
    end

    def find_or_create_user_by_username(username, options = {})
      find_user_by_username(username) || create_user({:username => username}.merge(options))
    end

    # Find a user by id
    def find_user(id)
      response = get("/api/v1/users/#{id}")
      User.new(self, response) if response
    end
    
    def find_user_by_username(username)
      response = get("/api/v1/users/find_by_username", :query => {:username => username})
      User.new(self, response) if response
    end

    def find_user_by_email(email)
      response = get("/api/v1/users/find_by_email", :query => {:email => email})
      p response
      User.new(self, response) if response
    end

    # MEEPS
    def find_meep(id)
      response = get("/api/v1/meeps/#{id}")
      p response
      Meep.new(self, response) if response
    end

    def find_meeps_for_stream(stream_id, lt = nil, gt = nil, limit = nil)
      query = {}
      query[:lt] = lt if lt
      query[:gt] = gt if gt
      query[:limit] = limit if limit
      response = get("/api/v1/streams/#{stream_id}/meeps", :query => query).map do |meep|
        Meep.new(self, meep)
      end
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
