module Protolink
  class Meep
    attr_reader :id, :user_id, :stream_id, :message, :type, :created_at

    def initialize(connection, attributes = {})
      @connection = connection
      @id         = attributes['id']
      @stream_id  = attributes['stream_id']
      @message 	  = attributes['message']
      @type       = attributes['type']
      @created_at = attributes['created_at']
    end

    protected
    
      def connection
        @connection
      end

  end
end