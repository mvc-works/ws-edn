
u =
  n: 0
  id: -> "s#{@n += 1}"

exports.WS = class
  constructor: (@_socket) ->
    @_routes = {}
    @_emitCalls = {}
    @_events = {}
    @_closeCalls = []

    @closed = no

    @_listen()

  emit: (key, value, cb) ->
    if typeof value is 'function'
      cb = value
      value = null
    id = u.id()
    @_send [key, value, id]
    @_emitCalls[id] = 1

  on: (key, cb) ->
    @_routes[key] = cb

  _send: (data) ->
    if @closed
      return console.log 'WS-JSON: already closed'
    @_socket.send (JSON.stringify data)

  _listen: ->
    @_socket.on "message", (data) =>
      @_handleMessage data

    @_socket.on 'close', =>
      @_handleClose()

  listenTo: (source, message, cb) ->
    @_events.push [source, message, cb]
    source.on message, cb

  onclose: (cb) ->
    @_closeCalls.push cb

  _handleClose: ->
    @closed = yes

    do cb for cb in @_closeCalls

    for pair in @_events
      [source, message, cb] = pair
      source.removeListener message, cb

    @_socket = null
    @_routes = null
    @_emitCalls = null
    @_events = null
    @_closeCalls = null

  _handleMessage: (data) ->
    [key, value, id] = JSON.parse data
    @_routes[key]? value, (ret) => @_send [key, ret, id]
    @_emitCalls[id]? value