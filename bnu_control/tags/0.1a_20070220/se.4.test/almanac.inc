; $Id$

; gps 2
db 10h,40h
db 01h,2
db 10h,03h
; 6

; gln 24
db 10h,40h
db 02h,24
db 10h,03h
; 6

; gps 17
db 10h,40h
db 01h,17
db 0
db 10h,03h
; 7

; gln 7
db 10h,40h
db 02h,7
db 1
db 10h,03h
; 7




; ephemerid ---------------------------

; gps 32
db 10h,49h
db 01h,32
db 10h,03h
; 6

; gps 18
db 10h,49h
db 01h,18
db 1
db 10h,03h
; 7

; gln 11
db 10h,49h
db 02h,11
db 1
db 10h,03h
; 7

; gps 7
db 10h,49h
db 01h,7
db 00h,00h,80h,3fh
db 10h,03h
; 10