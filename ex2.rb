require 'eventmachine'

class Server <EventMachine::Connection

  def self.start(hostname, port)
    EventMachine.run {
      EventMachine::start_server(hostname, port, Server)
      puts 'server is up'
    }
  end

  def post_init
    puts "client connected"
  end
  
  def receive_data message
    puts "server received message: #{message}"
  end
  
end





class Client < EventMachine::Connection
  attr_reader :queue
  
  def self.start(hostname, port)
    EventMachine.run {
      q = EventMachine::Queue.new
      EventMachine::connect(hostname, port, Client, q)
      puts "connected to server"
      EventMachine.open_keyboard(KeyboardHandler, q)
    }
  end

  def initialize(q)
    
    cb = Proc.new do |message|
      send_data(message)
      q.pop &cb
    end

    q.pop &cb
  end

end

class KeyboardHandler < EM::Connection
  include EventMachine::Protocols::LineText2

  attr_reader :queue

  def initialize(q)
    @queue = q
  end
  
  def receive_line(message)
    @queue.push message
  end
end
