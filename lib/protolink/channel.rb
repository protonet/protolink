module Protolink
  class Channel
    attr_reader :id, :name, :description, :global, :uuid

    def initialize(connection, attributes = {})
      @connection  = connection
      @id          = attributes['id']
      @name        = attributes['name']
      @description = attributes['description']
      @global      = attributes['global']
      @uuid        = attributes['uuid']
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
    
    def listen
      
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
        connection.post("/api/v1/meeps", :body => {:channel_id => self.id, :message => message})
      end

      def connection
        @connection
      end

  end
end
