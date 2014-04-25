
server = require("./src/")

server.listen 3000, (ws) ->
  console.log 'new connection'

  ws.emit "greet", "hello"
  
  ws.on "greet", (data) -> console.log "greet", data

  setTimeout (-> ws.emit "delay", "delay can send"), 2000

  ws.on "repeat", (data) ->
    setTimeout (-> ws.emit "repeat", data + 1), 1000

    console.log "repeating", data

  ws.onclose ->
    console.log 'connect closed'

  ws.emit "repeat", 1
