setlocal path=/usr/local/go/src/**/*
setlocal suffixesadd=.go,/
setlocal include=^\\t\\%(\\w\\+\\s\\+\\)\\=\"\\zs[^\"]*\\ze\"$
