require 'json'

class FlashConnection < EventMachine::Connection
  def initialize
    @buffer = ''
    
    set_comm_inactivity_timeout 60
  end
  # JSON packets
  def send_json json
    send_data json.to_json + "\0"
  end
  
  # Null-terminated lines
  def send_line line
    send_data line + "\0"
  end
  
  def receive_line line
    receive_json JSON.parse(line)
  rescue JSON::ParserError
    log "JSON parsing error"
  end
  
  # Raw bytes
  def receive_data data
    @buffer += data
    
    while @buffer.include? "\0"
      packet = @buffer[0, @buffer.index("\0")]
      @buffer = @buffer[(@buffer.index("\0")+1)..-1]
      
      receive_line packet
    end
  rescue => ex
    p ex, ex.backtrace
  end

  # TODO: redundant code
  def log text
    puts "#{self}: #{text}" if Rails.env != "production" || $DEBUG
  end
  
  def to_s
    "connection #{inspect}"
  end
end
