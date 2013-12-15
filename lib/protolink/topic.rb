module Protolink
  class Topic
    attr_reader :id, :user_id, :project_id, :stream_id

    def initialize(connection, attributes = {})
      @connection = connection
      @id         = attributes['id']
      @user_id    = attributes['user_id']
      @project_id = attributes['project_id']
    end

    def send_meep(message)
      connection.post("/api/v1/topics/#{self.id}/meeps", :body => { :message => message })
    end

    def destroy!

    end


    protected
    
      def connection
        @connection
      end

  end
end