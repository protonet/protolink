module Protolink
  class PrivateChat
    attr_reader :id, :user_a_id, :user_b_id

    def initialize(connection, attributes = {})
      @connection = connection
      @id         = attributes['id']
      @user_a_id  = attributes['user_a_id']
      @user_b_id  = attributes['user_b_id']
    end

    def send_meep(message)
      response = connection.post("/api/v1/private_chats/#{self.id}/meeps", :body => { :message => message })
      Meep.new(connection, response) if response
    end

    def user_a
      response = connection.get("/api/v1/users/#{user_a_id}")
      User.new(connection, response) if response
    end

    def user_b
      response = connection.get("/api/v1/users/#{user_b_id}")
      User.new(connection, response) if response
    end

    def destroy!

    end

    protected
    
      def connection
        @connection
      end

  end
end