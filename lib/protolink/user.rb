module Protolink
  class User
    attr_reader :id, :name, :login, :email, :avatar_url

    def initialize(connection, attributes = {})
      @connection = connection
      @id         = attributes['id']
      @name       = attributes['name']
      @login      = attributes['login']
      @email      = attributes['email']
      @avatar_url = attributes['avatar_url']
      @loaded     = false
    end

    # get token for autologin
    def auth_token
      receive_auth_token
    end

    protected

      def receive_auth_token
        connection.get("/api/v1/users/auth_token.json?user_id=#{self.id}")['token']
      end

      def load
        reload! unless @loaded
      end

      # does not work yet
      def reload!
        attributes = connection.get("/api/v1/users/#{@id}.json")['user']

        @id         = attributes['id']
        @name       = attributes['name']
        @login      = attributes['login']
        @email      = attributes['email']
        @avatar_url = attributes['avatar_url']
        @loaded    = true
      end

      def connection
        @connection
      end

  end
end