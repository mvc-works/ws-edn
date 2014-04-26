
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
      if typeof value is 'function'
        callback = value
        value = null
      id = u.id()
      send [key, value, id]
      emitCalls[id] = callback
    
    socket.on "message", (data) ->
      [key, value, id] = JSON.parse data
      routes[key]? value, (ret) -> send [key, ret, id]
      emitCalls[id]? value

    affairs = []
    ws.listenTo = (source, affair, callback) ->
      affairs.push {source, affair, callback}
      source.on affair, callback
    
    closeCalls = []
    ws.closed = no
    ws.onclose = (callback) -> closeCalls.push callback
    socket.on 'close', ->
      ws.closed = yes
      do callback for callback in closeCalls

      for pair in affairs
        {source, affair, callback} = pair
        source.removeListener affair, callback

      ws = null
      socket = null
      routes = null
      emitCalls = null
      affairs = null

    handle ws