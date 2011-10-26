class ProtoSocket < FlashConnection
  
  def initialize(connection, message_callback)
    @connection = connection
    @message_callback = message_callback
    super()
  end
  
  def connection_completed
    token           = @connection.current_user.communication_token
    
    send_json :operation => 'authenticate',
              :payload => {:type => 'web', :user_id => @connection.current_user.id, :token => token}
    
    periodic_ping
  end
  
  def receive_json(json)
    @message_callback.call(json)
  end
  
  def periodic_ping
    @ping ||= EventMachine.add_periodic_timer 30 do
      # log "sending ping"
      send_json :operation => 'ping'
    end
  end
  
  def unbind
    EventMachine::cancel_timer @ping
  end
  
end