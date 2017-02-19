require 'rubygems'
require 'openssl'
require 'websocket-client-simple'
require 'json'

for num in 0..10 do

#ws = WebSocket::Client::Simple.connect 'wss://mona.okamu.ro/cable'
ws = WebSocket::Client::Simple.connect 'ws://54.238.236.121/cable'

ws.on :message do |msg|
  result = JSON.parse(msg.data.to_s)
  if result["type"].to_s == "ping"
    ws.send "{\"command\":\"message\",\"identifier\":\"{\\\"channel\\\":\\\"RoomChannel\\\", \\\"room_id\\\":\\\"611531309\\\"}\",\"data\":\"{\\\"message\\\":\\\"aaaaaaaaaaaaa\\\",\\\"action\\\":\\\"speak\\\"}\"}"
  end
  p result
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
end
