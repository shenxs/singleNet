#lang racket
(require net/url
         json
         file/md5)
 (require rnrs/arithmetic/bitwise-6)
;;必要的头文件

(define 账号 "15381089274@GDPF.XY")
(define 密码 "128596")

(define >> bitwise-arithmetic-shift-right)
(define << bitwise-arithmetic-shift-left)
(define & bitwise-and)
(define ior bitwise-ior)

(define pin0~2 (list->string (list (integer->char 13) (integer->char 10))))
pin0~2
(define realUserName (substring 账号 0 11))
(define unixStamp (current-seconds))
(define time/5 (floor (/ unixStamp 5)))
(define (url->json url)
  (call/input-url (string->url url) get-pure-port read-json))

(define zero (bitwise-bit-field time/5 24 29))
(define one (bitwise-bit-field time/5 16 24))
(define two (bitwise-bit-field time/5 8 16))
(define three (bitwise-bit-field time/5 0 8))

(define pin27-0 (& (>> zero 2) 63))
(define pin27-1 (ior (&(<<(& zero 3) 4) 255) (&(>> one 4) 15)))
(define pin27-2 (ior (&(<<(& one 15) 2) 255) (&(>> two 6) 3)))
(define pin27-3 (& two 63))
(define pin27-4 (& (>> three 2) 63))
(define pin27-5 (& (<<(& three 3) 4) 255))
(define pin_list (list pin27-0 pin27-1 pin27-2 pin27-3 pin27-4 pin27-5))

(define (foo l)
  (cond
    [(empty? l) '()]
    [else (cons
           (if (>= (+(first l) 32) 64) (+(first l) 33) (+(first l) 32))
           (foo (rest l))
           )]))

(foo pin_list)
(map integer->char (foo pin_list))
(define (encode 账号)
  账号)


(define 拨号字段 (string->url (format "http://192.168.1.1/userRpm/PPPoECfgRpm.htm?wan=0&wantype=2&acc=~a&psw=~a&confirm=~a&SecType=0&sta_ip=0.0.0.0&sta_mask=0.0.0.0&linktype=4&waittime2=0&Connect=%C1%AC+%BD%D3 HTTP/1.1" (encode 账号) 密码 密码 )))

(define (拨号 账号 密码)
  (port->string (get-pure-port
                 拨号字段
               '(
                "Host: 192.168.1.1"
                "Authorization: Basic YWRtaW46MTk5NjAxMDE="
                "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8"
                "User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/29.0.1547.76 Safari/537.36"
                "Referer: http://192.168.1.1/userRpm/PPPoECfgRpm.htm?wan=0&wantype=2&acc=~a&psw=~a&confirm=~a&SecType=0&sta_ip=0.0.0.0&sta_mask=0.0.0.0&linktype=4&waittime2=0&Disconnect=%B6%CF+%CF%DF"
                "Accept-Encoding: gzip,deflate,sdch"
                "Cookie: Authorization=Basic YWRtaW46MTk5NjAxMDE="
                "Accept-Language: zh-CN,zh;q=0.8,en;q=0.6"
                )
                #:redirections 0)))
(define (run)
  (拨号 账号 密码))
(url->json "http://lp.music.ttpod.com/lrc/down?artist=周杰伦&title=双节棍")           