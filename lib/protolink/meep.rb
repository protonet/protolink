module Protolink
  class Meep
    attr_reader :id, :user_id, :channel_id, :message, :author, :created_at, :text_extension, :avatar

    def initialize(connection, attributes = {})
      @id         = attributes['id']
      @user_id    = attributes['user_id']
      @channel_id = attributes['channel_id']
      @message    = attributes['message']
      @author     = attributes['author']
      @created_at = attributes['created_at']
      @text_extension = attributes['text_extension']
      @avatar = attributes['avatar']
    end
  end
end