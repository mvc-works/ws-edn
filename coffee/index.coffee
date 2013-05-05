
exports.listen = (port) ->
  WebSocket = require("ws").Server
  server = new WebSocket {port}

  each: (handler) ->
    ws = {}
    route = {}
    ws.on = (key, callback) -> route[key] = callback
    server.on "connection", (socket) ->
      ws.emit = (key, value) ->
        socket.send JSON.stringify {key, value}
      
      socket.on "message", (data) ->
        data = JSON.parse data
        route[data.key]? data.value

      handler ws