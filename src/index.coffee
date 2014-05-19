
WebSocket = require("ws").Server

{WS} = require './ws'

exports.listen = (port, handle) ->
  (new WebSocket {port}).on "connection", (socket) ->
    handle (new WS socket)