#lang racket
(require net/url
         parsack)
;; http://ip.6655.com/ip.aspx?area=1
;;ip查询url

;;拿到url中的内容,string,无格式
(define (url->string url)
  (call/input-url (string->url url) get-pure-port port->string))

;;void -> strig
;得到当前的ip和地理位置
;如果没有网络连接则显示"无网络连接"
(define (getip)
  (with-handlers
    ([exn? (λ (x) "无网络连接,未能获取当前的ip和地理位置")])
    (url->string "http://ip.6655.com/ip.aspx?area=1")))

(provide getip)

