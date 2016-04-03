#lang racket
(require 2htdp/batch-io)
(define account "")
(define password "")

;;confgure是字符串格式为account"\n"password
;将配置文件保存到config.txt中
(define (save-config acc pass)
  ;;account,password ==>保存为适合读入的格式
  (define (shape-config acc pass)
    (string-append acc "\n" pass ))
  (write-file "config.txt" (shape-config acc pass))
  ;;设定account 和password
  (set! account acc)
  (set! password pass))

(define (read-config)
  (set! account (first (read-lines "config.txt")))
  (set! password (second (read-lines "config.txt"))))

(provide account password
         save-config
         read-config)

