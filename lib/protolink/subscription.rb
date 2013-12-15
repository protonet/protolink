module Protolink
  class Subscription
    attr_reader :id, :user_id, :project_id

    def initialize(connection, attributes = {})
      @connection = connection
      @id         = attributes['id']
      @user_id    = attributes['user_id']
      @project_id = attributes['project_id']
    end


    protected
    
      def connection
        @connection
      end

  end
end