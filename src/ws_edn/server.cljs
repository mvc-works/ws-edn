
(ns ws-edn.server )

(defonce *registry (atom {}))

(defn run-server! [on-action! port]
  (let [WebSocketServer (.-Server ws), wss (new WebSocketServer (js-obj "port" port))]
    (.on
     wss
     "connection"
     (fn [socket]
       (let [sid (.generate shortid)]
         (on-action! :session/connect nil sid)
         (swap! *registry assoc sid socket)
         (.info js/console "New client.")
         (.on
          socket
          "message"
          (fn [rawData]
            (let [action (reader/read-string rawData), [op op-data] action]
              (on-action! op op-data sid))))
         (.on
          socket
          "close"
          (fn []
            (.warn js/console "Client closed!")
            (swap! *registry dissoc sid)
            (on-action! :session/disconnect nil sid)))
         (.on socket "error" (fn [error] (.error js/console error))))))))
