
ws-json-server adds a little abstraction to websocket
------

EventEmitter like API for WebSocket, in server-side.

### Usage

Get package via npm:

```bash
npm install ws-json-server
```

```coffee
server = require 'ws-json-server'

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

  ws.emit "repeat", 1
```

### API

Start server:

* `server.listen(port).each`: `(ws) ->`

Communication is based on `[key, value, id]`:

* `ws.emit`: `key, value, (data) ->`,
`data` is what client callbacked,
both `value` and data are optional.

* `ws.on`: `key, (value, res) ->`,
`res` can be used like `res value` to send data back

When close:

* `ws.onclose`: `->`
* `ws.closed`

Since there might be lots of connections and many instances of `ws`.
`ws` objects may fail to be garbage collected.
To stay away from memory leak, a solution from Backbone.

* `ws.listenTo`: `source, eventName, (value) ->`,
it uses `.removeListener()` internally

### Development

Read `make.coffee` for more.