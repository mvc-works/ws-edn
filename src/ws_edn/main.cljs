
(ns ws-edn.main (:require [ws-edn.server :refer [wss-serve! wss-send! wss-each!]]))

(defn main! []
  (println "started")
  (wss-serve!
   5001
   {:on-listening! (fn [] (println "server listening")),
    :on-open! (fn [sid socket]
      (println "opened" sid)
      (wss-send! sid {:op "initial message"})),
    :on-data! (fn [sid data] (println "data" sid data)),
    :on-close! (fn [sid event] (println "close" sid))})
  (js/setInterval
   (fn [] (println "heartbeat") (wss-each! (fn [sid socket] (println sid socket))))
   2000))

(defn reload! [] (println "reload!"))
