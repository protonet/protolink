module Protolink
  class Listen
    attr_reader :id, :user_id, :channel_id

    def initialize(connection, attributes = {})
      @connection = connection
      @id         = attributes['id']
      @user_id    = attributes['user_id']
      @channel_id = attributes['channel_id']
      @loaded     = false
    end


    protected

      def load
        reload! unless @loaded
      end

      # does not work yet
      def reload!
        attributes  = connection.get("/api/v1/listens/#{@id}.json")['listen']

        @id         = attributes['id']
        @user_id    = attributes['user_id']
        @channel_id = attributes['channel_id']
        @loaded     = true
      end

      def connection
        @connection
      end

  end
end