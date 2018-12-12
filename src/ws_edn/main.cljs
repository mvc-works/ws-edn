
(ns ws-edn.main (:require [ws-edn.server :refer [wss-serve! wss-send!]]))

(defn main! []
  (println "started")
  (wss-serve!
   5001
   {:on-open! (fn [sid socket]
      (println "opened" sid)
      (wss-send! sid {:op "initial message"})),
    :on-data! (fn [sid data] (println "data" sid data)),
    :on-close! (fn [sid event] (println "close" sid))}))

(defn reload! [] (println "reload!"))
