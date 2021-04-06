Red []
dat: context [
	cdx: 0
	nom: "zero"
	col: 255.80.80
	lst: [ "a" "list" "goes" "here" ]
	fnc: function [ ] [ foreach l lst [ print [ "listitem =" l ] ] ]
]
print [ "raw data:^/" dat "^/" ]
save/as bdat: #{} dat 'redbin
write/binary %./redbin.dat bdat
b: read/binary %./redbin.dat
backwash: load/as b 'redbin
print [ "verifying data:^/" backwash ]
