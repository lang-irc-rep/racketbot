#lang racket
(require irc)
(require racket/async-channel)
(require racket/string)
(require dyoo-while-loop)

(provide message-trimmer)
(provide cmd-check)
(provide cmds)

(define message-trimmer
  (lambda (msg)
    (cond
      ((< (length (string-split msg)) 4) '())
      ((equal? (list-ref (string-split msg) 1) "PRIVMSG")
       (list (list-ref (string-split msg) 2)
             (substring (list-ref (string-split msg) 3) 1)))
      (else (string-split msg)))))
(define cmd-check
  (lambda (msg num)
    (let ((trim-msg
          (list-ref msg 1)))
    (cond
      ((and
       (equal? (substring trim-msg 0 1) ";") 
       (equal? (string-length trim-msg) (+ 1 num))) #t)
      (else #f)
      ))))

(define cmds
  (lambda (msg connection)
    (let ((trim-msg
          (message-trimmer msg)))
          (cond
            ((and
              (cmd-check trim-msg 4)
              (equal? (substring (list-ref trim-msg 1) 1 5)
                          "ping"))
             (irc-send-message connection
                               (list-ref trim-msg 0)
                               "pong"))
            (else (println msg))
            ))))