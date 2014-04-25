
WebSocket = require("ws").Server

exports.listen = (port, handle) ->
  server = new WebSocket {port}

  routes = {}
  
  ws = {}
  ws.on = (key, callback) -> routes[key] = callback

  server.on "connection", (socket) ->

    console.log 'socket'

    ws.emit = (key, value) ->
      if ws.closed
        console.log 'WS-JSON: emit when closed'
        return
      socket.send JSON.stringify [key, value]
    
    socket.on "message", (data) ->
      data = JSON.parse data
      routes[data[0]]? data[1]

    
    closeCalls = []
    ws.closed = no
    ws.onclose = (callback) -> closeCalls.push callback
    socket.on 'close', ->
      ws.closed = yes
      do callback for callback in closeCalls

    handle ws