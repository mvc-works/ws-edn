
ws-edn adds a little abstraction to websocket
------

### Usage

[![Clojars Project](https://img.shields.io/clojars/v/mvc-works/ws-edn.svg)](https://clojars.org/mvc-works/ws-edn)

```edn
[mvc-works/ws-edn "0.1.0-a2"]
```

```clojure
(ws-edn.server/wss-serve!
   5001
   {:on-open! (fn [sid socket] (println "opened" sid)),
    :on-data! (fn [sid data] (println "data" sid data)),
    :on-close! (fn [sid event] (println "close" sid))})

(ws-edn.server/wss-send! sid data)
```

```clojure
(ws-edn.client/ws-connect!
   "ws://localhost:5001"
   {:on-open! (fn [event] (println "open")),
    :on-data! (fn [data] (println "data" data)),
    :on-close! (fn [event] (println "close"))})

(ws-edn.client/ws-send! data)
```

### License

MIT
