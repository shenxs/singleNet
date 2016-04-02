#lang racket
(require net/url
         racket/gui
         file/sha1
         "getip.rkt"
         "encode.rkt")
;;必要的头文件
; Make a frame by instantiating the frame% class
(define frame (new frame% [label "闪讯拨号器"]))
; Make a static text message in the frame
(define msg (new message% [parent frame]
                 [label "请输入闪讯密码
                        \n然后按拨号(点一下就好)
                        \n如果成功会显示本机ip"]))
;建立一个输入框
(define txt (new text-field%
                 [label "闪讯密码"]
                 [parent frame]
                 ))
; Make a button in the frame
(define btn (new button% [parent frame]
                 [label "拨号"]
                 ; Callback procedure for a button click:
                 [callback (lambda (button event)
                             (and
                               (run (send (send txt get-editor) get-text))
                               (send msg set-label (getip))))]))
; Show the frame by calling its show method
(send frame show #t)

(define 账号 "15381089274@GDPF.XY")
;(define 账号 "17774002784@GDPF.XY")
;(define 密码 password)
;(define 密码 (send (send txt get-editor) get-text))

(define (run pass)
  (local (
          (define 拨号字段 (string->url (format "http://192.168.1.1/userRpm/PPPoECfgRpm.htm?wan=0&wantype=2&acc=~a&psw=~a&confirm=~a&SecType=0&sta_ip=0.0.0.0&sta_mask=0.0.0.0&linktype=4&waittime2=0&Connect=%C1%AC+%BD%D3 HTTP/1.1"  (encode 账号) pass pass )))
          (define (拨号 账号 密码)
            (port->string (get-pure-port
                            拨号字段
                            '(
                              "Accept:text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8"
                              "Accept-Encoding:gzip, deflate, sdch"
                              "Accept-Language:zh-CN,zh;q=0.8,en;q=0.6"
                              "Connection:keep-alive"
                              "Cookie:Authorization=Basic%20YWRtaW46MTk5NjAxMDE%3D; ChgPwdSubTag="
                              "DNT:1"
                              "Host:192.168.1.1"
                              "Referer:http://192.168.1.1/userRpm/PPPoECfgRpm.htm"
                              "Upgrade-Insecure-Requests:1"
                              "User-Agent:Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/48.0.2564.116 Safari/537.36"
                              )
                            #:redirections 0)))
          )
    (拨号 账号 pass)))
