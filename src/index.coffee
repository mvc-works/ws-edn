
WebSocket = require("ws").Server

u = n: 0, id: -> "s#{@n += 1}"

exports.listen = (port, handle) ->
  (new WebSocket {port}).on "connection", (socket) ->

    ws = closed: no

    send = (data) ->
      return console.log 'WS-JSON: already closed' if ws.closed
      socket.send (JSON.stringify data)
    
    routes = {}
    ws.on = (key, callback) -> routes[key] = callback

    emitCalls = {}
    ws.emit = (key, value, callback) ->
      callback = value unless callback?
      id = u.id()
      send [key, value, id]
      emitCalls[id] = callback
    
    socket.on "message", (data) ->
      [key, value, id] = JSON.parse data
      routes[key]? value, (ret) -> send [key, ret, id]
      emitCalls[id]? value
    
    closeCalls = []
    ws.closed = no
    ws.onclose = (callback) -> closeCalls.push callback
    socket.on 'close', ->
      ws.closed = yes
      do callback for callback in closeCalls

    handle ws