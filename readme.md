
ws-json adds a little abstraction to websocket
------

JS prefers JSON-like objects while WebScokets uses strings,  
I made this module to make WebSockets easier for JS.  
Read `ws-json-client` for the client part.  
Note that this is only a demo, it hasn't been tested.  

### Usage

Run `npm install ws-json-server` to install.  

```coffee
delay = (t, f) -> setTimeout f, t

server = require("ws-json-server")
server.listen(3000).each (ws) ->
  console.log "start"
  ws.emit "greet", "hello"
  ws.on "call", (data) ->
    console.log "call", data

  delay 2000, ->
    ws.emit "delay", "delay can send"

  ws.on "repeat", (data) ->
    ws.emit "repeat", data + 1

    console.log "repeating", data
```

### API

* `server.listen(3000).each`: port is required.

It accepts a callback function that defines how socket runs.

* `ws.emit`: accepts a key and a value, sends value to clients.

* `ws.on`: accepts a key and a value

### Develop

I use `node-dev dev.coffee` to debug this module