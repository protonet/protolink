module Protolink
  class User
    attr_reader :id, :name, :login, :email, :avatar, :subscriptions, 
                :external_profile_url, :communication_token, :node_id

    def initialize(connection, attributes = {})
      @connection = connection
      @id         = attributes['id']
      @name       = attributes['name']
      @login      = attributes['login']
      @email      = attributes['email']
      @avatar     = attributes['avatar']
      @subscriptions = attributes['subscriptions']
      @node_id    = attributes['node_id']
      @external_profile_url = attributes['external_profile_url']
      @communication_token  = attributes['communication_token']
      @loaded     = false
    end

    # get token for autologin
    def auth_token
      connection.get("/api/v1/users/#{self.id}/auth_token.json")["token"]
    end
    
    def delete!
      connection.delete("/api/v1/users/#{self.id}")
    end

    protected

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