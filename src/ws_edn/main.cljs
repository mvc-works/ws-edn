
(ns ws-edn.main (:require [ws-edn.server :refer [start-server! send!]]))

(defn main! []
  (println "started")
  (start-server!
   5001
   {:on-open! (fn [sid socket] (println "opened" sid) (send! sid {:op "initial message"})),
    :on-data! (fn [sid data] (println "data" sid data)),
    :on-close! (fn [sid event] (println "close" sid))}))

(defn reload! [] (println "reload!"))
