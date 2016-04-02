#lang racket
(require
  racket/gui
  file/sha1
  "dial.rkt"
  "getip.rkt")

;;必要的头文件
; Make a frame by instantiating the frame% class
(define frame (new frame% [label "闪讯拨号器"]))
; Make a static text message in the frame
(define msg (new message% [parent frame]
                 [label "请输入闪讯密码\n然后按拨号(点一下就好)"]))
(define account-text-file (new text-field%
                               [label "账号"]
                               [parent frame]))

;建立一个输入框
(define password (new text-field%
                 [label "密码"]
                 [parent frame]))


(define btn-area (new horizontal-pane%
                      [parent frame]
                      [alignment '(center center )]))

; Make a button in the frame
(define dail-btn (new button% [parent btn-area]
                 [label "拨号"]
                 ; Callback procedure for a button click:
                 [callback (lambda (button event)
                             (and
                               (dial (send (send password get-editor) get-text))
                               (send msg set-label (getip))))]))
(define save-btn (new button%
                      [parent btn-area]
                      [label "保存"]))

; Show the frame by calling its show method
(send frame show #t)

