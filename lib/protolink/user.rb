module Protolink
  class User
    attr_reader :id, :first_name, :last_name, :username, :email

    def initialize(connection, response)
      attributes = if response.respond_to?(:parsed_response)
        response.parsed_response
      else
        response
      end

      @connection     = connection
      @id             = attributes['id']
      @first_name     = attributes['first_name']
      @last_name      = attributes['last_name']
      @username       = attributes['username']
      @email          = attributes['email']
    end

    # get token for autologin
    def login_token
      connection.get("/api/v1/users/#{self.id}/login_token").parsed_response["login_token"]
    end
    
    def login_cookies
      connection.get("/api/v1/users/login_cookies").parsed_response["cookies"]
    end

    def subscribed_projects
      projects = connection.get("/api/v1/users/#{self.id}/subscribed_projects")
      projects && projects.map do |project|
        Project.new(connection, project)
      end
    end

    def subscribed_topics
      topics = connection.get("/api/v1/users/#{self.id}/subscribed_topics")
      topics && topics.map do |topic|
        Topic.new(connection, topic)
      end
    end

    def destroy!
      connection.delete("/api/v1/users/#{self.id}")
    end

    protected

      def connection
        @connection
      end

  end
end