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
    disconnect_if_no_ping_received
  end
  
  def receive_json(json)
    if json["trigger"] == "socket.ping_received"
      @last_ping_received = Time.now
      return
    end
    @message_callback.call(json)
  end
  
  def periodic_ping
    @ping ||= EventMachine.add_periodic_timer 30 do
      # log "sending ping"
      send_json :operation => 'ping'
    end
  end

  def disconnect_if_no_ping_received
    @ping_check ||= EventMachine.add_periodic_timer 30 do
      if @last_ping_received && @last_ping_received < (Time.now - 60)
        close_connection
      end      
    end
  end
  
  def unbind
    puts "DISCONNECTED"
    EventMachine::cancel_timer @ping
    EventMachine::cancel_timer @ping_check
    EventMachine::add_timer(30) {
      EventMachine.connect URI.parse(@connection.class.base_uri).host, 5000, ProtoSocket, @connection, @message_callback
    }
  end
  
end