require 'rubygems'
require 'eventmachine'

module EchoServer

  def post_init
    @@client_list ||= {}
    @@client_list.merge!({self.object_id => self})
  end

  def unbind
    @@client_list.delete(self.object_id)
  end

  def receive_data(data)
    others.each do |client|
      client.send_data(data)
    end
    close_connection if data =~ /quit|exit/i
  end

  def others
    all = @@client_list.clone
    all.delete(object_id)
    all.values
  end
end

EventMachine::run do
  EventMachine::start_server "127.0.0.1", 6789, EchoServer
end
