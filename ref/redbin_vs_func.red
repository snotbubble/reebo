Red []
dat: context [
	cdx: 0
	nom: "zero"
	col: 255.80.80
	sty: false
	lst: [ "a" "list" "goes" "here" ]
	fnc: function [ ] [ print [ "my list is: " lst ] foreach l lst [ print [ "listitem =" l ] ] ]
]
s: copy []
append s copy dat
append s copy dat
s/1/cdx: 1
s/2/cdx: 2
s/1/nom: "one"
s/2/nom: "two"
s/2/col: 80.180.255
s/2/sty: true
s/2/lst: [ "another" "list" "goes" "here" ]

print [ "template data:^/" dat "^/" ]
foreach w s [ print [ "verifying template data "w/cdx":^/" w "^/" ] ]
foreach w s [ print [ "verifying template func"w/cdx":" ] w/fnc print "^/" ]

save/as bdat: #{} s 'redbin
write/binary %./redbin.dat bdat
b: read/binary %./redbin.dat
backwash: load/as b 'redbin

foreach w backwash [ print [ "verifying data "w/cdx":^/" w "^/" ] ]
foreach w backwash [ print [ "verifying func"w/cdx":" ] w/fnc print "^/" ]

print "^/since the functions aren't data I can't investigate further, so trying this:^/"

sdat: context [
	cdx: 0
	nom: "zero"
	col: 255.80.80
	sty: false
	lst: [ "a" "list" "goes" "here" ]
	fnc: mold [function [ /local l ] [ print [ "my list is: " lst ] foreach l lst [ print [ "listitem =" l ] ] ]]
]
g: copy []
append g copy sdat
append g copy sdat
g/1/cdx: 1
g/2/cdx: 2
g/1/nom: "one"
g/2/nom: "two"
g/2/col: 80.180.255
g/2/sty: true
g/2/lst: [ "another" "list" "goes" "here" ]

print [ "template data:^/" sdat "^/" ]
foreach w g [ print [ "verifying template data "w/cdx":^/" w "^/" ] ]
foreach w g [ print [ "verifying template func"w/cdx":" ] do (load w/fnc) print "^/" ]
print "do load fnc does nothing, just puts it into a block, which can't be run as do block/1"
;probe load g/2/fnc
;c: load g/2/fnc
;probe c
;do c/1 ;; complains of missing 'spec'

save/as bsdat: #{} g 'redbin
write/binary %./sredbin.dat bsdat
bs: read/binary %./sredbin.dat
backwashed: load/as bs 'redbin

foreach w backwashed [ print [ "verifying data "w/cdx":^/" w "^/" ] ]
foreach w backwashed [ print [ "verifying func"w/cdx":" ] do (load w/fnc) print "^/" ]

print "pre-molding functions causes them to loose their context, so args have to be supplied"


print "^/trying once more with args:^/"

odat: context [
	cdx: 0
	nom: "zero"
	col: 255.80.80
	sty: false
	lst: [ "a" "list" "goes" "here" ]
	fnc: mold [function [ lst /local l ] [ print [ "my list is: " lst ] foreach l lst [ print [ "listitem =" l ] ] ]]
]
k: copy []
append k copy odat
append k copy odat
k/1/cdx: 1
k/2/cdx: 2
k/1/nom: "one"
k/2/nom: "two"
k/2/col: 80.180.255
k/2/sty: true
k/2/lst: [ "another" "list" "goes" "here" ]

print [ "template data:^/" odat "^/" ]
foreach w k [ print [ "verifying template data "w/cdx":^/" w "^/" ] ]
foreach w k [ print [ "verifying template func"w/cdx":" ] v: do (load w/fnc) do v w/lst print "^/" ]
print "it can't be run as do do load fnc or do (load fnc)/1, has to be saved as a variable 1st^/"

save/as bodat: #{} k 'redbin
write/binary %./oredbin.dat bodat
bo: read/binary %./oredbin.dat
backwasher: load/as bo 'redbin

foreach w backwasher [ print [ "verifying data "w/cdx":^/" w "^/" ] ]
foreach w backwasher [ print [ "verifying func"w/cdx":" ] v: do (load w/fnc) do v w/lst print "^/" ]

print "finally, correct data!  fucksakes that was onerous..."
