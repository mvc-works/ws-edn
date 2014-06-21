
u =
  n: 0
  id: -> "s#{@n += 1}"

clients = []
channels = {}

_remove = (list, item) ->
  if item in list
    list.splice (list.indexOf item), 1

exports.WS = class
  constructor: (@_socket) ->
    @_routes = {}
    @_emitCalls = {}
    @_events = {}
    @_closeCalls = []
    @_bindings = {}

    @closed = no

    @_listen()
    clients.push @

  emit: (key, value, cb) ->
    if typeof value is 'function'
      cb = value
      value = null
    id = u.id()
    @_send [key, value, id]
    @_emitCalls[id] = cb

  on: (key, cb) ->
    unless @_routes[key]?
      @_routes[key] = []
    queue = @_routes[key]
    unless cb in queue
      queue.push cb

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

    _remove clients, @
    for _, room of channels
      _remove room, @

  _handleMessage: (data) ->
    [key, value, id] = JSON.parse data

    if @_routes[key]?
      for cb in @_routes[key]
        cb value, (ret) => @_send [key, ret, id]

    @_emitCalls[id]? value

  _trigger: (key, value) ->
    console.log '_trigger'
    if @_bindings[key]?
      for cb in @_bindings[key]
        cb value

  bind: (key, cb) ->
    unless @_bindings[key]?
      @_bindings[key] = []
    queue = @_bindings[key]
    unless cb in queue
      queue.push cb

  join: (chan) ->
    unless channels[chan]?
      channels[chan] = []
    channels[chan].push @

  leave: (chan) ->
    room = channels[chan]
    _remove room, @
    if room.length is 0
      channels[chan] = null

  broadcast: (key, value) ->
    for client in clients
      unless client is @
        client._trigger key, value

  cast: (chan, key, value) ->
    room = channels[chan]
    if room?
      for client in room
        unless client is @
          client._trigger key, value