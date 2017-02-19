require 'rubygems'
require 'websocket-client-simple'
require 'json'
require "parallel"
require 'benchmark'


exec_time = Benchmark.realtime do

  Parallel.each([*1..50], in_threads: 50) {|i|
    ws = WebSocket::Client::Simple.connect 'ws://54.238.236.121/cable'
    #ws = WebSocket::Client::Simple.connect 'wss://mona.okamu.ro/cable'
    
    ws.on :message do |msg|
      result = JSON.parse(msg.data.to_s)
      if result["type"].to_s == "ping"
        ws.send "{\"command\":\"message\",\"identifier\":\"{\\\"channel\\\":\\\"RoomChannel\\\", \\\"room_id\\\":\\\"611531309\\\"}\",\"data\":\"{\\\"message\\\":\\\"aaaaaaaaaaaaa\\\",\\\"action\\\":\\\"speak\\\"}\"}"
      else
        p '======================='
        p i 
        p '======================='
        p result
      end
    end
    
    ws.on :open do
      ws.send "{\"command\":\"subscribe\",\"identifier\":\"{\\\"channel\\\":\\\"RoomChannel\\\", \\\"room_id\\\":\\\"611531309\\\"}\"}"
      p 'open'
    end
    
    ws.on :close do |e|
      p e
      exit 1
    end
    
    loop do
      ws.send STDIN.gets.strip
    end
  }
end

