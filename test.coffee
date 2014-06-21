
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

  ws.join 'a'

  ws.on 'cast', (data, res) ->
    console.log 'cast:', data
    ws.cast 'a', 'cast', 'sent by join'

  ws.bind 'cast', (value) ->
    console.log 'hear:', value
    ws.emit 'cast', 'data'

  ws.bind 'cast', (value) ->
    console.log 'hear2:', value

  ws.emit "repeat", 1

  ws.on 'repeat', (n) ->
    console.log 'another:', n
    ws.broadcast 'cast', 'another'