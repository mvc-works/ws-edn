
(ns ws-edn.server
  (:require [cljs.reader :refer [read-string]] ["ws" :as ws] ["shortid" :as shortid]))

(defonce *global-connections (atom {}))

(defn maintain-socket! [^js socket options]
  (let [sid (shortid/generate)]
    (swap! *global-connections assoc sid socket)
    (when-let [on-open (:on-open options)] (on-open sid socket))
    (.on
     socket
     "message"
     (fn [rawData]
       (when-let [on-data (:on-data options)] (on-data sid (read-string rawData)))))
    (.on
     socket
     "close"
     (fn [event]
       (swap! *global-connections dissoc sid)
       (when-let [on-close (:on-close options)] (on-close sid event))))
    (.on
     socket
     "error"
     (fn [error]
       (swap! *global-connections dissoc sid)
       (let [on-error (:on-error options)]
         (if (some? on-error) (on-error error) (js/console.error error)))))))

(defn wss-each! [handler] (doseq [[sid socket] @*global-connections] (handler sid socket)))

(defn wss-send! [sid data]
  (let [socket (get @*global-connections sid)]
    (if (some? socket)
      (.send socket (pr-str data))
      (js/console.warn "socket not found for" sid))))

(defn wss-serve! [port options]
  (assert (number? port) "first argument is port")
  (let [WebSocketServer (.-Server ws), wss (new WebSocketServer (js-obj "port" port))]
    (.on wss "connection" (fn [socket] (maintain-socket! socket options)))
    (.on
     wss
     "listening"
     (fn [] (when-let [on-listening (:on-listening options)] (on-listening))))
    (.on
     wss
     "error"
     (fn [error]
       (let [on-error (:on-error options)]
         (if (some? on-error) (on-error error) (js/console.error error)))))))
