;; extends

; Hide the backslash in escapes like \[ so only the escaped character shows
((backslash_escape) @conceal
  (#offset! @conceal 0 0 0 -1)
  (#set! conceal ""))
