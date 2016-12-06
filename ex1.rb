require 'socket'

class Server
  
  def initialize(hostname, port)
    @server = TCPServer.open(hostname, port)
    puts 'server is up'
    wait_for_client()
  end

  def wait_for_client()
    client = @server.accept
    puts 'client connected'
    listen(client)
  end

  def listen(client)
    loop {
      message = client.gets.chomp
      puts "server received message: #{message}"
    }
  end

end




class Client

  def initialize(hostname, port)
    @socket = TCPSocket.open(hostname, port)
    send()
  end

  def send()
    loop {
      message = $stdin.gets.chomp
      @socket.puts message
    }
  end
  
end
