
u =
  n: 0
  id: -> "s#{@n += 1}"

exports.WS = class
  constructor: (@_socket) ->
    @_routers = {}
    @_emitCalls = {}
    @_events = {}
    @_closeCalls = []

    @closed = no

    @_listen()

  emit: (key, value, callback) ->
    if typeof value is 'function'
      callback = value
      value = null
    id = u.id()
    @_send [key, value, id]
    @_emitCalls[id] = 1

  on: (key, callback) ->
    @_routes[key] = callback

  _send: (data) ->
    return console.log 'WS-JSON: already closed' if @closed
    @_socket.send (JSON.stringify data)

  _listen: ->
    @_socket.on "message", (data) =>
      @_handleMessage data

    @_socket.on 'close', ->
      @_handleClose()

  listenTo: (source, affair, callback) ->
    @_affairs.push {source, affair, callback}
    source.on affair, callback

  onclose: (callback) ->
    @_closeCalls.push callback

  _handleClose: ->
    @closed = yes

    do callback for callback in @_closeCalls

    for pair in @_affairs
      {source, affair, callback} = pair
      source.removeListener affair, callback

    @_socket = null
    @_routes = null
    @_emitCalls = null
    @_affairs = null

  _handleMessage: (data) ->
    [key, value, id] = JSON.parse data
    @_routes[key]? value, (ret) => @_send [key, ret, id]
    @_emitCalls[id]? value