
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

server.listen(3000).each (ws) ->
  console.log 'new connection'

  ws.emit "greet", "hello"
  
  ws.on "greet", (data) -> console.log "greet", data

  setTimeout (-> ws.emit "delay", "delay can send"), 2000

  ws.on "repeat", (data) ->
    setTimeout (-> ws.emit "repeat", data + 1), 1000

    console.log "repeating", data

  ws.emit "repeat", 1

```

### API

* `server.listen(port).each`: `(ws) ->`
* `ws.emit`: `key, value`
* `ws.on`: `key, (value) ->`
* `ws.onclose`: `->`
* `ws.closed`

### Protocol

This implementation is simple, just using `[key, value]` as JSON.

### Development

Read `make.coffee` for more.