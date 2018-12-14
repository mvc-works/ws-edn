
(ns ws-edn.page (:require [ws-edn.client :refer [ws-connect! ws-send!]]))

(defn main! []
  (println "start")
  (ws-connect!
   "ws://localhost:5001"
   {:on-open (fn [event] (println "open") (ws-send! {:op :test})),
    :on-data (fn [data] (println "data" data)),
    :on-close (fn [event] (println "close"))}))

(defn reload! [] (println "reload"))
