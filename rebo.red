Red [ needs 'view ]

;; interactive syntax highlight designer
;; by c.p.brown 2021
;;
;; very early work-in-progress!
;; if there's no compiled binary here assume its busted
;; 32-bit linux only

;; ! : doing it
;; ? : having problems with it
;; - : probably dropping it
;; X : testing it
;;
;;
;; TODO: [!] add crayon toolbar: add remove sort move-up move-down
;; TODO: [!] add button to save crayon capture rule
;; TODO: [X] add sort by char-count
;; TODO: [ ] investigate drag to re-order crayons
;; TODO; [?] investigate loopless access to the data and ui items
;; TODO; [-] add 3rd pane to top half, make it a tab-pane with: raw-data, console output
;; TODO; [X] add backwash bold italic and words
;; TODO; [X] add bold/italic in crayon list
;; TODO; [ ] add bgcolor bold italic to rich-text data
;; TODO; [ ] add save/load dyslex files
;; TODO; [ ] add parse presets for capture rule param if its doable & doesn't lock-up
;; TODO; [ ] add complete red dyslex file, save as default, embase it when everything is done


marg: 10
tabh: 0 ;; height of the statusbar (none atm)
noupdate: false	;; stop ui chain-reactions
cidx: 0  ;; the list selection index
hil: 180.60.50

lexdat: context [
	control: context [
		cdx: 1
		nom: "control"
		fgc: 200.80.80
		bgc: none
		bol: true
		tal: true
		words: ["Red" "opt" "attempt" "break" "catch" "compose" "disarm" "dispatch" "does" "either" "else" "exit" "forall" "foreach" "for" "forever" "forskip" "func" "function" "halt" "has" "if" "launch" "loop" "next" "quit" "reduce" "remove-each" "repeat" "return" "switch" "throw" "try" "unless" "until" "while" "do"]
		rule: compose/deep [o: copy []
s: copy mccp/text
fg:  (to-path reduce [ 'lexdat to-word (nom) 'fgc ])
foreach w copy  (to-path reduce [ 'lexdat to-word (nom) 'words ]) [
	k: rejoin [ w " " ]
	while [(quote (find s k)) <> none] [
		rv: to-pair reduce [ (quote (index? find s w))  (quote (length? w)) ]
		unless none? rv [ append o rv ]
		unless none? fg [ append o fg ]
		replace s w (quote (pad "" length? w))
	]
]]
		lay: compose/deep [
			panel 300x55  with [ color: (bgc) ] extra [ idx: (cdx) cname: (nom) pos: 'bg ] draw [ ] [
				below
				text 200x30 with [ 
					text: (nom) 
					color: (either none? bgc [50.50.50] [bgc ])
					font: make font! [ 
						name: "consolas" 
						color: (fgc) 
						size: 24 
						style: [ (unless none? bol ['bold])  (unless none? tal ['italic])  ] 
					] 
				] extra [ idx: (cdx) pos: 'fg ]
			] on-down [ 
				cidx: face/extra/idx
				clear face/draw
				append face/draw compose [ pen (hil) line-width 6 box 0x0 (quote (face/size - 3x0)) ]
				doselect cidx "^-" (rejoin [ 'lexdat "/" (nom) "/" 'lay ])
			]
		]
	]
	series: context [
		cdx: 2
		nom: "series"
		fgc: 80.200.80
		bgc: none
		bol: true
		tal: none
		words: ["alter" "append" "array" "at" "back" "change" "clear" "copy" "difference" "exclude" "extract" "find" "first" "found?" "free" "head" "index?" "insert" "intersect" "join" "last" "length?" "load" "maximum-of" "minimum-of" "offset?" "parse" "pick" "poke" "remove" "remove-each" "repend" "replace" "reverse" "select" "skip" "sort" "switch" "tail" "union" "unique"]
		rule: compose/deep [o: copy []
s:  copy mccp/text
fg: (to-path reduce [ 'lexdat to-word (nom) 'fgc ])
foreach w copy (to-path reduce [ 'lexdat to-word (nom) 'words ]) [
	k: rejoin [ w " " ]
	while [(quote (find s k)) <> none] [
		rv: to-pair reduce [ (quote (index? find s w))  (quote (length? w)) ]
		append o reduce [ (quote (rv)) (quote (fg)) ]
		replace s w (quote (pad "" length? w))
	]
]]
		lay:  compose/deep [
			panel 300x55 with [ color: (bgc) ] extra [ idx: (cdx) cname: (nom) pos: 'bg ] draw [ ] [
				below
				text 200x30 with [ 
					text: (nom) 
					color: (either none? bgc [50.50.50] [bgc ])
					font: make font! [ 
						name: "consolas" 
						color: (fgc) 
						size: 24 
						style: [ (unless none? bol ['bold])  (unless none? tal ['italic])  ] 
					] 
				] extra [ idx: (cdx) pos: 'fg ]
			] on-down [ 
				cidx: face/extra/idx
				append face/draw compose [ pen (hil) line-width 6 box 0x0 (quote (face/size - 3x0)) ]
				doselect cidx "^-" (rejoin [ 'lexdat "/" (nom) "/" 'lay ])
			] 
		]
	]
]

renderitall: func [ ] [
	rxdat: copy []
	foreach c values-of lexdat [
		unless none? c/words [
			unless none? c/rule [
				do mold/only c/rule
				foreach u o [ unless none? u [ append rxdat u ] ]
			]
		]
   	]
	if (length? rxdat) > 0 [
		mddp/text: copy mccp/text
		mddp/data: copy rxdat
	]
]

cxhx: function [ c ] [
	rejoin reduce [ "#" (to-hex/size c/1 2) (to-hex/size c/2 2) (to-hex/size c/3 2) ] 
]


doselect: func [ i tabi tabf ] [
	print [ tabi "doselect triggered by " tabf " idx= " i ]
	foreach c values-of lexdat [
		if c/cdx = i [
			noupdate: true
			unless none? c/nom [ cryn/text: c/nom ]
			either none? c/fgc [ 
				fgcp/color: 50.50.50 fcr/data: 0.0 fcg/data: 0.0 fcb/data: 0.0 fghx/text: ""
			] [
				print [tabi "^-sending fg color " c/fgc " to params..." ]
				fgcp/color: c/fgc fcr/data: (c/fgc/1 / 255.0) fcg/data: (c/fgc/2 / 255.0) fcb/data: (c/fgc/3 / 255.0) fghx/text: cxhx c/fgc 
			]
			either none? c/bgc [
				bgcp/color: 50.50.50 bcr/data: 0.0 bcg/data: 0.0 bcb/data: 0.0 bghx/text: ""
			] [
				print [tabi "^-sending bg color " c/bgc " to params..." ]
				bgcp/color: c/bgc bcr/data: (c/bgc/1 / 255.0) bcg/data: (c/bgc/2 / 255.0) bcb/data: (c/bgc/3 / 255.0) bghx/text: cxhx c/bgc
			]
			print [tabi "^-^-checking sytle data: " c/bol c/tal "..." ]
			either none? c/bol [ ambold/data: false ] [ if logic? c/bol [ ambold/data: c/bol print [ tabi "^-sending bold " c/bol "to params.." ] ] ]
			either none? c/tal [ amital/data: false ] [ if logic? c/tal [ amital/data: c/tal print [ tabi "^-sending italic " c/tal "to params.." ]  ] ]
			theword/text: ""
			either none? c/words [ clear thewords/data ] [ if (length? c/words) > 0 [ thewords/data: c/words  print [ tabi "^-sending thewords to params.." ]  ] ]
		    therule/text: mold/only c/rule print [ tabi "^-sending therule to params..."]
			noupdate: false
			print [ tabi "^-params sent, breaking out of data loop..."]
			break
		]
	]
	foreach-face maap [
		unless none? face/extra/idx [
			either face/extra/idx <> i [
				if face/extra/pos = 'bg [
					print [ tabi "^-clearing crayon bg color..."]
					clear face/draw
				]
			] [
				if face/extra/pos = 'bg [ print [ tabi "^-setting crayon bg color to " bgcp/color "..." ] face/color: bgcp/color ]
				if face/extra/pos = 'fg [ 
					print [ tabi "^-setting crayon fg color to " fgcp/color "..." ]
					face/font/color: fgcp/color
					clear face/font/style
				    if (ambold/data <> none) [ print [ tabi "^-setting crayon bold to " ambold/data  "..." ] if ambold/data [ append face/font/style 'bold ] ]
				    if (amital/data <> none) [ print [ tabi "^-setting crayon italic to " amital/data  "..." ] if amital/data [ append face/font/style 'italic ] ]
					print [ tabi "^-^-style set to: " face/font/style ]				
				]
			]
		]
	]
]	

backwashfgc: func [ col tabi tabf ] [
	print [ tabi "backwashfgc triggered by " tabf "..." ]
	noupdate: true
	foreach c values-of lexdat [
		if c/cdx = cidx [
			c/fgc: col
			break
		]
	]
	foreach-face maap [
		unless none? face/extra/idx [
			if (face/extra/idx = cidx) and (face/extra/pos = 'fg) [
				either none? col [
					face/font/color: 180.180.180
				] [
					face/font/color: col
				]
				break
			]
		]
	]
]

backwashbgc: func [ col tabi tabf ] [
	print [ tabi "backwashbgc triggered by " tabf "..." ]
	noupdate: true
	foreach c values-of lexdat [
		if c/cdx = cidx [
			c/bgc: col
			break
		]
	]
	foreach-face maap [
		unless none? face/extra/idx [
		    if (face/extra/idx = cidx) and (face/extra/pos = 'bg) [
				either none? col [
					face/color: 50.50.50
				] [
					face/color: col
				]
				break
			]
		]
	]
]

backwashstyle: func [ tabi tabf ] [
	print [ tabi "backwashstyle triggered by " tabf "..." ]
	noupdate: true
	foreach-face maap [
		unless none? face/extra/idx [
		    if (face/extra/idx = cidx) and (face/extra/pos = 'fg) [
				either (ambold/data <> none) and (amital/data <> none)  [
					clear face/font/style
					print [ tabi "setting crayon bold and italic to " ambold/data " " amital/data  "..." ]
					if ambold/data [ append face/font/style 'bold ]
					if amital/data [ append face/font/style 'italic ]
				] [
					if (ambold/data <> none) [ print [ tabi "setting crayon bold to " ambold/data  "..." ] face/font/style: [ 'bold ] ]
					if (amital/data <> none) [ print [ tabi "setting crayon italic to " amital/data  "..." ] face/font/style: [ 'italic ] ]
				]
				break
			]
		]
	]
	foreach c values-of lexdat [ 
		if c/cdx = cidx [
		    either none? ambold/data [ c/bol: false ] [ c/bol: ambold/data ]
			either none? amital/data [ c/tal: false ] [ c/tal: amital/data ]
		]
	]
	noupdate: false
]

backwashwords: func [ ] [
	noupdate: true
	foreach c values-of lexdat [ 
		if c/cdx = cidx [
			unless none? thewords/data [
				if (length? thewords/data) > 0 [
					clear c/words
					c/words: copy thewords/data
				]
			]
		]
	]
]


nudgeu: func [] [
	uu/offset/x: 0
	uu/offset/y: min (max 200 uu/offset/y) 600
	uu/size/x: tp/size/x
	vv/offset/y: uu/offset/y + 10
	vv/size/y: tp/size/y - ((uu/offset/y + 10) + tabh)
	zz/offset/y: 0
	zz/size/y: uu/offset/y
	maa/offset/y: 0
	mbb/offset/y: 0
	mcc/offset/y: uu/offset/y + 10
	mdd/offset/y: uu/offset/y + 10
	maa/size/y: uu/offset/y
	mbb/size/y: uu/offset/y
	mcc/size/y: vv/size/y
	mdd/size/y: vv/size/y
	maah/offset/y: 0
	mbbh/offset/y: 0
	mcch/offset/y: 0
	mddh/offset/y: 0
	maap/offset/y: maah/size/y + marg
	;mbbp/offset/y: mbbh/size/y + marg
	mccp/offset/y: mcch/size/y + marg
	mddp/offset/y: mddh/size/y + marg
	maap/size/y: maa/size/y - (maah/size/y + (2 * marg))
	;mbbp/size/y: mbb/size/y - (mbbh/size/y + (2 * marg))
	mccp/size/y: mcc/size/y - (mcch/size/y + (2 * marg))
	mddp/size/y: mdd/size/y - (mddh/size/y + (2 * marg))
	uu/draw: compose/deep [ 
		pen off 
		fill-pen 100.100.100
		circle (to-pair compose/deep [(to-integer (uu/size/x * 0.5) - 10) 5]) 2 2 
		circle (to-pair compose/deep [(to-integer (uu/size/x * 0.5)) 5]) 2 2
		circle (to-pair compose/deep [(to-integer (uu/size/x * 0.5) + 10) 5]) 2 2 
	]
]

nudgev: func [] [
	vv/offset/y: uu/offset/y + 10
	vv/offset/x: min (max 100 vv/offset/x) (tp/size/x - 100)
	if vv/offset/x < 100 [ return 0 ]
	;maa/offset/x: 0
	;mbb/offset/x: zz/offset/x + 10
	mcc/offset/x: 0
	mdd/offset/x: vv/offset/x + 10
	;maa/size/x: zz/offset/x
	;mbb/size/x: (tp/size/x - (zz/offset/x + 10))
	mcc/size/x: vv/offset/x
	mdd/size/x: (tp/size/x - (vv/offset/x + 10))
	;maah/offset/x: 0
	;mbbh/offset/x: 0
	mcch/offset/x: 0
	mddh/offset/x: 0
	;maah/size/x: maa/size/x
	;mbbh/size/x: mbb/size/x
	mcch/size/x: mcc/size/x
	mddh/size/x: mdd/size/x
	;maap/offset/x: marg
	;mbbp/offset/x: marg
	mccp/offset/x: marg
	mddp/offset/x: marg
	;maap/size/x: maah/size/x - (marg + marg)
	;mbbp/size/x: mbbh/size/x - (marg + marg + 1)
	mccp/size/x: mcch/size/x - (marg + marg)
	mddp/size/x: mddh/size/x - (marg + marg + 1)
	vv/draw: compose/deep [ 
		pen off 
		fill-pen 100.100.100
		circle (to-pair compose/deep [5 (to-integer (vv/size/y * 0.5) - 10)]) 2 2 
		circle (to-pair compose/deep [5 (to-integer (vv/size/y * 0.5))]) 2 2
		circle (to-pair compose/deep [5 (to-integer (vv/size/y * 0.5) + 10)]) 2 2 
	]
]

nudgez: func [] [
	zz/offset/y: 0
	zz/offset/x: min (max 430 zz/offset/x) (tp/size/x - 300)
	if zz/offset/x < 100 [ return 0 ]
	maa/offset/x: 0
	mbb/offset/x: zz/offset/x + 10
	;mcc/offset/x: 0
	;mdd/offset/x: vv/offset/x + 10
	maa/size/x: zz/offset/x
	mbb/size/x: (tp/size/x - (zz/offset/x + 10))
	;mcc/size/x: vv/offset/x
	;mdd/size/x: (tp/size/x - (vv/offset/x + 10))
	maah/offset/x: 0
	mbbh/offset/x: 0
	;mcch/offset/x: 0
	;mddh/offset/x: 0
	maah/size/x: maa/size/x
	mbbh/size/x: mbb/size/x
	;mcch/size/x: mcc/size/x
	;mddh/size/x: mdd/size/x
	maap/offset/x: marg
	mbbp/offset/x: marg
	;mccp/offset/x: marg
	;mddp/offset/x: marg
	maap/size/x: maah/size/x - (marg + marg)
	mbbp/size/x: mbbh/size/x - (marg + marg + 1)
	;mccp/size/x: mcch/size/x - (marg + marg)
	;mddp/size/x: mddh/size/x - (marg + marg + 1)
;; cryl list offsets go here
	cryn/size/x: mbbp/size/x - (4 * marg)
	fgcp/size/x: cryn/size/x
	fghx/size/x: fgcp/size/x - (95 + 80)
	nofg/offset/x: fghx/offset/x + fghx/size/x + 10
	fcr/size/x: fgcp/size/x - (2 * marg)
	fcg/size/x: fcr/size/x
	fcb/size/x: fcr/size/x
	bgcp/size/x: cryn/size/x
	bghx/size/x: bgcp/size/x - (95 + 80) 
	nobg/offset/x: bghx/offset/x + bghx/size/x + 10
	bcr/size/x: bgcp/size/x - (2 * marg)
	bcg/size/x: bcr/size/x
	bcb/size/x: bcr/size/x
	ambold/size/x: cryn/size/x
	amital/size/x: cryn/size/x
    wordpanel/size/x: cryn/size/x
	wrdlbl/size/x: wordpanel/size/x - (marg + marg)
	theword/size/x: wrdlbl/size/x
	;addword/offset/x: (theword/offset/x + theword/size/x + 5)
	remword/offset/x: (addword/offset/x + addword/size/x + 5)
	srtword/offset/x: (remword/offset/x + remword/size/x + 5)
	srtlen/offset/x: (srtword/offset/x + srtword/size/x + 5)
	thewords/size/x: wrdlbl/size/x
	rulepanel/size/x: cryn/size/x
   	therule/size/x: rulepanel/size/x - (marg + marg)
	doit/size/x: therule/size/x
	foreach-face maap [
	    if face/extra/pos = 'bg [
			face/size/x: maap/size/x - (marg + marg)
			if face/extra/idx = cidx [
				clear face/draw
			    append face/draw compose [ pen (hil) line-width 6 box 0x0 (face/size - 3x0) ]
			]
		]
   	]
	zz/draw: compose/deep [ 
		pen off 
		fill-pen 100.100.100
		circle (to-pair compose/deep [5 (to-integer (zz/size/y * 0.5) - 10)]) 2 2 
		circle (to-pair compose/deep [5 (to-integer (zz/size/y * 0.5))]) 2 2
		circle (to-pair compose/deep [5 (to-integer (zz/size/y * 0.5) + 10)]) 2 2 
	]
	;probe zz/offset
]

rippleparms: func [] [
	ambold/offset/y: bgcp/offset/y + bgcp/size/y + 10
	amital/offset/y: ambold/offset/y + ambold/size/y + 10
	wordpanel/offset/y: amital/offset/y + amital/size/y + 10
	wordpanel/size/y: (rulepanel/offset/y - wordpanel/offset/y) - 10
	thewords/size/y: wordpanel/size/y - 90
]

view/tight/flags/options [
	title "rebo"
	below
	hh: panel 800x55 35.35.35 [
		lexers: drop-list 200x30 font-name "consolas" font-size 10 font-color 180.180.180 bold data (collect [foreach file read %./ [ if (find (to-string file) ".dyslex") [keep rejoin ["./" (to-string file)]] ]]) on-change []
		pad 10x0
	    lexname: field 200x30 font-name "consolas" font-size 10 font-color 180.180.180 bold
		lnew: button 80x34 "save" font-name "consolas" font-size 10 font-color 180.180.180 bold [ 
			if (lexname/text <> "") and (lexname/text <> none) [
			   	newlexname: rejoin [ "./" lexname/text ".dyslex" ]
			    write to-file newlexname lexdat
				clear lexers/data
				lexers/data: (collect [foreach file read %./ [ if (find (to-string file) ".dyslex") [keep rejoin ["./" (to-string file)]] ]])
				lexers/selected: index? find lexers/data newlexname
			]
		]
		pad 10x0
		lsave: button 160x34 "save output" font-name "consolas" font-size 10 font-color 180.180.180 bold [
			if (lexname/text <> "") and (lexname/text <> none) [
				op: request-dir
				unless none? op [ 
		    		write to-file rejoin [ op lexname "_output.txt" ] mddp/text 
				]
			]
		]
	]
	tp: panel 800x745 [
		below
		maa: panel 800x300 40.40.40 [
			maah: panel 45.45.45 800x55 [
				text 160x30 "crayons" font-name "consolas" font-size 24 font-color 80.80.80 bold
				button 30x33 "+" font-name "consolas" font-size 10 font-color 180.180.180 bold [ ]
				button 30x33 "-" font-name "consolas" font-size 10 font-color 180.180.180 bold [ ]
			    button 30x33 "▼" font-name "consolas" font-size 10 font-color 180.180.180 bold [ ]
				button 30x33 "▲" font-name "consolas" font-size 10 font-color 180.180.180 bold [ ]
				button 30x33 "↓" font-name "consolas" font-size 10 font-color 180.180.180 bold [ ]
				button 30x33 "⮍" font-name "consolas" font-size 10 font-color 180.180.180 bold [ ]
			]
			maap: panel 400x245 [
				below
			]
		]
		zz: panel 10x390 30.30.30 loose [] on-drag [ nudgez ]
		mbb: panel 390x400 40.40.40 [
			mbbp: panel 400x1100 [
				below
				cryn: field 380x30 40.40.40
				fgcp: panel 380x180 50.50.50 [
				    text 80x30 "fg color" on-dbl-click [
						either (fgcp/size/y > 55) [
							fgcp/size/y: 55
							bgcp/offset/y: fgcp/offset/y + fgcp/size/y + 10
						    rippleparms
						] [
							fgcp/size/y: 180
							bgcp/offset/y: fgcp/offset/y + fgcp/size/y + 10
						    rippleparms
						]
					]
					fghx: field 160x30 on-enter [
						unless noupdate [
							hxc: hex-to-rgb to-issue remove face/text 
							unless none? hxc [ 
								noupdate: true
								fcr/data: hxc/1 / 255.0
								fcg/data: hxc/2 / 255.0
								fcb/data: hxc/3 / 255.0
								fgcp/color: hxc 
								backwashfgc hxc  "^-" "fghx" renderitall
								noupdate: false
							]
						]
					]
					nofg: button 50x30 "X" [
						noupdate: true 
						fcr/data: 0.0 
						fcg/data: 0.0 
						fcb/data: 0.0 
						fghx/text: ""
						fgcp/color: 50.50.50
						backwashfgc none  "^-" "nofg" renderitall
						noupdate: false 
					]
					return
					fcr: slider 360x30 on-change [ 
						face/data: round/to face/data 0.1 
						unless noupdate [ 
							noupdate: true
							fgcp/color: to-tuple reduce [ (to-integer (fcr/data * 255))  (to-integer (fcg/data * 255)) (to-integer (fcb/data * 255)) ] 
							fghx/text: cxhx fgcp/color 
							backwashfgc fgcp/color "^-" "fcr" renderitall
							noupdate: false 
						]
					]
					return
					fcg: slider 360x30 on-change [ 
						face/data: round/to face/data 0.1 
						unless noupdate [ 
							noupdate: true
							fgcp/color: to-tuple reduce [ (to-integer (fcr/data * 255)) (to-integer (fcg/data * 255)) (to-integer (fcb/data * 255)) ] 
							fghx/text: cxhx fgcp/color 
							backwashfgc fgcp/color "^-" "fcg" renderitall
							noupdate: false
						]
					]
					return
					fcb: slider 360x30 on-change [ 
						face/data: round/to face/data 0.1 
						unless noupdate [
							noupdate: true
							fgcp/color: to-tuple reduce [ (to-integer (fcr/data * 255)) (to-integer (fcg/data * 255)) (to-integer (fcb/data * 255)) ] 
							fghx/text: cxhx fgcp/color 
							backwashfgc fgcp/color "^-" "fcb" renderitall
							noupdate: false
						]
					]
				]
				bgcp: panel 380x180 50.50.50 [
				    text 80x30 "bg color" on-dbl-click [
						either (bgcp/size/y > 55) [
							bgcp/size/y: 55
						    rippleparms
						] [
							bgcp/size/y: 180
						    rippleparms
						]
					]
					bghx: field 160x30 on-enter [ 
						unless noupdate [
							hxc: hex-to-rgb to-issue remove face/text 
							unless none? hxc [ 
								noupdate: true
								bcr/data: hxc/1 / 255.0
								bcg/data: hxc/2 / 255.0
								bcb/data: hxc/3 / 255.0
								bgcp/color: hxc 
								backwashbgc hxc "^-" "bghx"
								noupdate: false
							]
						]
					]
					nobg: button 50x30 "X" [ 
						noupdate: true 
						bcr/data: 0.0 
						bcg/data: 0.0 
						bcb/data: 0.0 
						bghx/text: "" 
						bgcp/color: 50.50.50
						backwashbgc none "^-" "nobg"
						noupdate: false 
					]
					return
					bcr: slider 360x30 on-change [ 
						face/data: round/to face/data 0.1 
						unless noupdate [ 
							noupdate: true
							bgcp/color: to-tuple reduce [ (to-integer (bcr/data * 255))  (to-integer (bcg/data * 255)) (to-integer (bcb/data * 255)) ] 
							bghx/text: cxhx bgcp/color 
							backwashbgc bgcp/color "^-" "bcr"
							noupdate: false 
						]
					]
					return
					bcg: slider 360x30 on-change [ 
						face/data: round/to face/data 0.1 
						unless noupdate [ 
							noupdate: true
							bgcp/color: to-tuple reduce [ (to-integer (bcr/data * 255))  (to-integer (bcg/data * 255)) (to-integer (bcb/data * 255)) ] 
							bghx/text: cxhx bgcp/color 
							backwashbgc bgcp/color "^-" "bcg"
							noupdate: false 
						]
					]
					return
					bcb: slider 360x30 on-change [ 
						face/data: round/to face/data 0.1 
						unless noupdate [ 
							noupdate: true
							bgcp/color: to-tuple reduce [ (to-integer (bcr/data * 255))  (to-integer (bcg/data * 255)) (to-integer (bcb/data * 255)) ] 
							bghx/text: cxhx bgcp/color 
							backwashbgc bgcp/color "^-" "bcb"
							noupdate: false 
						]
					]
				]
				ambold: check 200x30 "bold" [ unless noupdate [ backwashstyle "^-" "ambold" ] ]
				amital: check 200x30 "italic" [ unless noupdate [ backwashstyle "^-" "amital" ] ]
				wordpanel: panel 380x250 [
					wrdlbl: text 200x30 "words (processed in order)"
					return
					theword: field 80x30 on-change [
						unless noupdate [
							if (face/text <> none) and (face/text <> "") [
								widx: thewords/selected
								unless none? widx [
									thewords/data/:widx: face/text
									backwashwords
								]
							]
						]
					]
					return
					addword: button 40x30 "+" [ 
						if (theword/text <> none) and (theword/text <> "") [
							noupdate: true
							append thewords/data "new_word"
							thewords/selected: (length? thewords/data)
							theword/text: thewords/data/(thewords/selected)
							backwashwords
							noupdate: false
						] 
					]
					remword: button 40x30 "-" [ 
						if (theword/text <> none) and (theword/text <> "") and ((find thewords/data theword/text) <> none) [
							noupdate: true
							widx: thewords/selected
							unless (widx = (length? thewords/data)) [ widx: widx - 1 ]
						    remove-each w thewords/data [ w = theword/text ]
							thewords/selected: widx
							theword/text: thewords/data/:widx
							backwashwords
							noupdate: false
						] 
					]
					srtword: button 60x30 "↓A" [
						if (length? thewords/data) > 0 [
							noupdate: true
							g: copy thewords/data
						    o: g/1
							delt: false
						    foreach d g [ delt: (d > o) o: d if delt [ break ] ]
						    either delt [
								sort/compare g func [a b] [
									case [
										a > b [1]
										a < b [-1]
										a = b [0]
									]
								]
							] [
								sort/compare g func [a b] [
									case [
									    a > b [-1]
									    a < b [1]
									    a = b [0]
									]
								]
							]
							clear thewords/data
							thewords/data: copy g
							clear g
							theword/text: none
							backwashwords
							noupdate: false
						]
					]
					srtlen: button 60x30 "↓#" [
						if (length? thewords/data) > 0 [
							noupdate: true
							g: copy thewords/data
						    o: (length? g/1)
							delt: 0
						    foreach d g [ delt: ((length? d) - o) o: (length? d) if delt > 0 [ break ] ]
						    either delt > 0 [
								sort/compare g func [a b] [
									case [
										(length? a) > (length? b) [1]
										(length? a) < (length? b) [-1]
										(length? a) = (length? b) [0]
									]
								]
							] [
								sort/compare g func [a b] [
									case [
										(length? a) > (length? b) [-1]
										(length? a) < (length? b) [1]
										(length? a) = (length? b) [0]
									]
								]
							]
							clear thewords/data
							thewords/data: copy g
							clear g
							theword/text: none
							backwashwords
							noupdate: false
						]
					]
					return
					thewords: text-list 380x120 35.35.35 data ["one" "two"] [
						unless noupdate [
							widx: face/selected noupdate: true theword/text: thewords/data/:widx noupdate: false
						]
					]
				]
				rulepanel: panel 380x500 [
					below
					rullbl: text 120x30 "capture rule"
					therule: area 380x200 35.35.35 with [ text: "huh" ] font-name "consolas" font-size 9 font-color 255.180.80 bold
					doit: button 120x30 "try it" [
						s: copy mccp/text 
						l: copy thewords/data 
						fg: fgcp/color
						o: copy []
					    do therule/text
						mddp/text: "" clear mddp/data
						mddp/text: copy mccp/text 
						mddp/data: copy o
						clear o
						clear s
						clear l
						print [ "rtdat: " o]
					]
				]
			] on-wheel [
				either event/picked > 0 [
					face/offset/y: face/offset/y + 40
				] [
					face/offset/y: face/offset/y - 40
				]
				bo: mbb/size/y - face/size/y
				;bo: bo - 55
				bo: min bo 0
	    		face/offset/y: max bo min face/offset/y 55
			]
			mbbh: panel 390x55 45.45.45 [
				text 200x30 "params" font-name "consolas" font-size 24 font-color 80.80.80 bold
			]
		] 
		uu: panel 800x10 30.30.30 loose [] on-drag [ nudgeu ]
		across
		mcc: panel 390x400 40.40.40 [
			mcch: panel 390x55 45.45.45 [
				text 200x30 "source" font-name "consolas" font-size 24 font-color 80.80.80 bold
			]
			mccp: area 390x300 40.40.40 font-name "consolas" font-size 12 font-color 128.255.255 bold with [
				text: {Red [needs 'view]^/makepane: function [ ] [^/^-p: compose/deep [ pane 100x100 255.0.0 ]^/^-p^/]^/view [^/^-p: pane 400x400 [^/^-^-button 400x30 "make pane" [ append p/pane layout/only makepane ]^/^-]^/]
				}
			] on-change [ ] 
		]
		vv: panel 10x390 30.30.30 loose [] on-drag [ nudgev ]
		mdd: panel 390x400 40.40.40 [
			mddh: panel 390x55 45.45.45 [
				text 200x30 "result" font-name "consolas" font-size 24 font-color 80.80.80 bold
			]
			mddp: rich-text 390x345 40.40.40 font-name "consolas" font-size 12 font-color 128.128.128 bold
		]   	
	]
	do [ 
		if exists? %./default.dyslex [ 
			lset: load %./default.dyslex
			lexname/text: "default"
			lexers/selected: index? find lexers/data "./default.dyslex"
		]
	    foreach c values-of lexdat [
			;probe c/lay
			append maap/pane layout/only c/lay
		]
		foreach-face maap [
			probe face/pane
			unless none? face/extra/pos [
				probe face/extra/pos
				if face/extra/pos = 'bg [
					if none? face/color [ face/color: 50.50.50 ]
					face/offset/y: to-integer ((face/extra/idx - 1) * (face/size/y + 5))
				]
			]
		]
		lsave/offset/x: tp/size/x - (lsave/size/x + marg)
	    lnew/offset/x: lsave/offset/x - (lnew/size/x + marg)
		lexname/offset/x: (lexers/offset/x + lexers/size/x + marg)
		lexname/size/x: lnew/offset/x - (lexers/size/x + (4 * marg))
		zz/offset/x: 395
		vv/offset/x: 395
		uu/offset/y: 395
		nudgez nudgeu nudgev 
	]
] [ resize ] [
	actors: object [
		on-resizing: function [ face event ] [
			if face/size/x > 500 [
				if face/size/y > (uu/offset/y + 200) [
					hh/size/x: face/size/x
					tp/size: face/size - 0x55
					lsave/offset/x: face/size/x - (lsave/size/x + marg)
					lnew/offset/x: lsave/offset/x - (lnew/size/x + marg)
					lexname/offset/x: (lexers/offset/x + lexers/size/x + marg)
					lexname/size/x: lnew/offset/x - (lexers/size/x + (4 * marg))
					nudgez nudgeu nudgev
				]
			]
		]
	]
]
