module Protolink
  class Project
    attr_reader :id, :name, :description, :global, :uuid

    def initialize(connection, attributes = {})
      @connection  = connection
      @id          = attributes['id']
      @name        = attributes['name']
    end
    
    def destroy!
      connection.delete("/api/v1/projects/#{self.id}")
    end
    
    def listener
      users = connection.get("/api/v1/projects/#{self.id}/users")
      users && users.map do |user|
        User.new(connection, user)
      end
    end
    
    def create_topic(name)
      response = connection.post("/api/v1/projects/#{self.id}/topics", :body => { :name => name } )
      Topic.new(connection, response) if response
    end

    def topics
      topics = connection.get("/api/v1/projects/#{self.id}/topics")
      topics && topics.map do |topic|
        Topic.new(connection, topic)
      end
    end

    def find_topic_by_name
      response = get("/api/v1/topic/find_by_name", :query => {:name => name})
      Topic.new(connection, response) if response
    end

    def subscribe_user(user)
      connection.post('/api/v1/projects/#{self.id}/subscribe', :body => { :user_id => user.id } )
    end

    def unsubscribe_user(user)
      connection.delete('/api/v1/projects/#{self.id}/subscribe', :body => { :user_id => user.id } )
    end

    protected

      def connection
        @connection
      end

  end
end
