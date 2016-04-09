#lang racket
(require net/url
         json
         file/md5
         racket/gui
         file/sha1
         rnrs/arithmetic/bitwise-6)
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
                               (send msg set-label (url->string "http://ipinfo.io/ip"))))]))
; Show the frame by calling its show method
(send frame show #t)

(define 账号 "15381089274@GDPF.XY")
;(define 账号 "17774002784@GDPF.XY")
;(define 密码 password)
;(define 密码 (send (send txt get-editor) get-text))

(define RAD "singlenet01")
;;简化定义
(define >> bitwise-arithmetic-shift-right)
(define << bitwise-arithmetic-shift-left)
(define & bitwise-and)
(define ior bitwise-ior)
(define pin1 (list->string (list (integer->char 13) (integer->char 10))));pin的前两位
(define realUserName (substring 账号 0 11));取出手机号码
(define unixStamp (current-seconds));;当前时间
(define time/5 (floor (/ unixStamp 5)))
(define (url->json url)
  (call/input-url (string->url url) get-pure-port read-json))
;l ->list n->第n个 w-> what 变成什么
;将链表l中的 第n个元素变成n+w

(define (url->string url)
  (call/input-url (string->url url) get-pure-port port->string))


(define (add-to l n w)
  (cond
    [(= n 1) (cons (+ w (first l)) (rest l))]
    [else (cons (first l) (add-to (rest l) (- n 1) w))]))
(define timehash (list 0 0 0 0))
;timeHash[i]=timeHash[i]+(((timedivbyfive>>(i+4*j))&1)<<(7-j))
(define  (time_hash i j)
  (<< (& (>> time/5 (+ (- i 1) (* 4 (- j 1)))) 1) (- 7 (- j 1))))
(define (循环替换 l i j)
  (local
    (
     (define new-l  (add-to l i  (time_hash i j)))
     (define new-i (if (= j 1) (- i 1) i))
     (define new-j (if (= j 1) 8 (- j 1)))
     )
    (if (and ( =  i 1) (= j 1))
      new-l
      (循环替换 new-l new-i new-j))))
(define timehased (循环替换 timehash 4 8))
(define zero (first timehased))
(define one (second timehased))
(define two (third timehased))
(define three (fourth timehased))
(define pin27-0 (& (>> zero 2) 63))
(define pin27-1 (ior (&(<<(& zero 3) 4) 255) (&(>> one 4) 15)))
(define pin27-2 (ior (&(<<(& one 15) 2) 255) (&(>> two 6) 3)))
(define pin27-3 (& two 63))
(define pin27-4 (& (>> three 2) 63))
(define pin27-5 (& (<<(& three 3) 4) 255))
(define pin27 (list pin27-0 pin27-1 pin27-2 pin27-3 pin27-4 pin27-5))
(define (调整pin l)
  (cond
    [(empty? l) '()]
    [else (cons
            (if (>= (+(first l) 32) 64) (+(first l) 33) (+(first l) 32))
            (调整pin (rest l))
            )]))
(define pin2 (list->string (map integer->char (调整pin pin27))))


(define tmp_bytes (integer->integer-bytes time/5 4 false true))
(define bm (bytes-append  tmp_bytes
                          (string->bytes/utf-8 realUserName)
                          (string->bytes/utf-8 RAD) ))
(define pin3 (bytes->string/utf-8 (subbytes (md5 bm) 0 2)))


(define encode
  (string-append pin1 pin2 pin3 账号 ))

(define (run pass)
  (local (
          (define 拨号字段 (string->url (format "http://192.168.1.1/userRpm/PPPoECfgRpm.htm?wan=0&wantype=2&acc=~a&psw=~a&confirm=~a&SecType=0&sta_ip=0.0.0.0&sta_mask=0.0.0.0&linktype=4&waittime2=0&Connect=%C1%AC+%BD%D3 HTTP/1.1"  encode pass pass )))
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
;; (display (url->string "http://ipinfo.io/ip") )
#| (url->json "http://www.trackip.net/ip?json") |#
