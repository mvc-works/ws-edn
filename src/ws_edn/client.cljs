
(ns ws-edn.client (:require [cljs.reader :refer [read-string]]))

(defonce *global-ws (atom nil))

(defn ws-connect! [ws-url options]
  (assert (string? ws-url) "reqiured an url for ws server")
  (let [ws (js/WebSocket. ws-url)]
    (reset! *global-ws ws)
    (set!
     (.-onopen ws)
     (fn [event] (when-let [on-open (:on-open options)] (on-open event))))
    (set!
     (.-onclose ws)
     (fn [event]
       (reset! *global-ws nil)
       (when-let [on-close (:on-close options)] (on-close event))))
    (set!
     (.-onmessage ws)
     (fn [event]
       (when-let [on-data (:on-data options)] (on-data (read-string (.-data event))))))
    (set!
     (.-onerror ws)
     (fn [error]
       (js/console.error "Failed to establish connection" error)
       (when-let [on-error (:on-error options)] (on-error error))))))

(defn ws-connected? [] (some? @*global-ws))

(defn ws-send! [data]
  (let [ws @*global-ws]
    (if (some? ws) (.send ws (pr-str data)) (js/console.warn "WebSocket at close state!"))))
