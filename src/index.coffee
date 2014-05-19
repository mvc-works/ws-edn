
WebSocket = require("ws").Server

exports.listen = (port, handle) ->
  (new WebSocket {port}).on "connection", (socket) ->
    handle (new WS socket)