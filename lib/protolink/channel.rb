module Protolink
  class Channel
    attr_reader :id, :name, :description

    def initialize(connection, attributes = {})
      @connection  = connection
      @id          = attributes['id']
      @name        = attributes['name']
      @description = attributes['description']
      @loaded      = false
    end
    

    # Post a new message to the chat channel
    def speak(message, options = {})
      send_message(message)
    end

    def delete!
      connection.delete("/api/v1/channels/#{self.id}")
    end
    
    def listener
      users = connection.get("/api/v1/channels/#{self.id}/users")
      users && users.map do |user|
        User.new(connection, user)
      end
    end

    protected

      def load
        reload! unless @loaded
      end

      # does not work yet
      def reload!
        attributes = connection.get("/api/v1/channels/#{@id}.json")['channel']

        @id          = attributes['id']
        @name        = attributes['name']
        @description = attributes['description']
        @loaded      = true
      end

      def send_message(message)
        connection.post("/api/v1/meeps/create", :body => {:channel_id => self.id, :message => message})
      end

      def connection
        @connection
      end

  end
end
