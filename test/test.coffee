
delay = (t, f) -> setTimeout f, t

server = require("../lib")
server.listen(3000).each (ws) ->
  console.log "start"
  ws.emit "greet", "hello"
  ws.on "call", (data) ->
    console.log "call", data

  delay 2000, ->
    ws.emit "delay", "delay can send"

  ws.on "repeat", (data) ->
    ws.emit "repeat", data + 1

    console.log "repeating", data

  # ws.emit "repeat", 1