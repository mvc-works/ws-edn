
server = require("./src/")

server.listen 3000, (ws) ->

  ws.on 'greet', (data, res) ->
    console.log 'cient sent:', data
    res 'hello client'

  ws.emit 'welcome', 'websocket', (data) ->
    console.log 'client returns:', data

  ws.on "repeat", (data, res) ->
    setTimeout (-> res (data + 1)), 2000
    console.log "repeat", data

  ws.onclose ->
    console.log 'connect closed'

  ws.emit "repeat", 1
