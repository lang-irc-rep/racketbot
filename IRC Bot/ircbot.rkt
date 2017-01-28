#lang racket
(require irc)
(require racket/async-channel)
(require racket/string)
(require dyoo-while-loop)
(require "irc-cmd.rkt")

(define-values (connection ready)
  (irc-connect "irc.freenode.net" 6667 "maymaybot" "markbot" "markov bot"))
(define-values (log)
  (irc-connection-incoming connection))
(define notice (irc-message-content (async-channel-get log)))
(println notice)
(define notice-list (string-split notice))
(println notice-list)
(define notice-value (list-ref notice-list 4))
(println notice-value)
(irc-send-command connection "notice" notice-value "nospoof")
(sleep 10)
(irc-join-channel connection "##/lang/")
(irc-send-message connection "##/lang/" "ayylmao")
(while (async-channel? log)
       (set! notice (irc-message-content
                (async-channel-get log)))
       (cond
        ((equal? (list-ref (string-split notice) 1) "PRIVMSG")
                      (begin
                          (println notice)
                          (println (message-trimmer notice))
                          (cmds notice connection)))))



