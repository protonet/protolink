module Protolink
  class Channel
    attr_reader :id, :name, :description, :global, :uuid, :rendezvous, :last_read_meep, :listen_id

    def initialize(connection, attributes = {})
      @connection     = connection
      @id             = attributes['id']
      @name           = attributes['name']
      @description    = attributes['description']
      @global         = attributes['global']
      @uuid           = attributes['uuid']
      @rendezvous     = attributes['rendezvous']
      @last_read_meep = attributes['last_read_meep']
      @listen_id      = attributes['listen_id']
      @loaded         = false
    end
    

    # Post a new message to the chat channel
    def speak(message, options = {})
      send_message(message, options)
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

      def send_message(message, option)
        connection.post("/api/v1/meeps", :body => {:channel_id => self.id, :message => message, :text_extension => option[:text_extension]})
      end

      def connection
        @connection
      end

  end
end
