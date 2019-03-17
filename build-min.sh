#!/bin/sh

set -e

src=src/Main.elm
out=build/main.js
min=build/elm.min.js

elm make --optimize --output=$out $src

uglifyjs $out --compress "pure_funcs=[F2,F3,F4,F5,F6,F7,F8,F9,A2,A3,A4,A5,A6,A7,A8,A9],pure_getters,keep_fargs=false,unsafe_comps,unsafe" | uglifyjs --mangle --output=$min

echo "Initial size:  $(cat $out | wc -c) bytes  ($out)"
echo "Minified size: $(cat $min | wc -c) bytes  ($min)"
echo "Gzipped size:  $(cat $min | gzip -c | wc -c) bytes"

