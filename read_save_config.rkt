#lang racket
(require 2htdp/batch-io)
(define account "")
(define password "")
(define router-password "")

;;confgure是字符串格式为account"\n"password
;将配置文件保存到config.txt中
(define (save-config acc pass rt-pass)
  ;;account,password ==>保存为适合读入的格式
  (define (shape-config acc pass)
    (string-append acc "\n" pass  "\n" rt-pass))
  (write-file "config.txt" (shape-config acc pass))
  ;;设定account 和password
  (set! account acc)
  (set! password pass))

(define config (read-lines "config.txt"))


(define (read-config)
  (set! account (first config))
  (set! password (second config))
  (set! router-password (third config)))

(provide account password router-password
         save-config
         read-config)

