Red [ needs 'view ]

;; interactive syntax highlight designer
;; by c.p.brown 2021
;;
;; very early work-in-progress!


marg: 10
tabh: 0 ;; height of the statusbar (none atm)
noupdate: false	;; stop ui chain-reactions

lexdat: context [
	control: context [
		nom: "control"
		fgc: 200.80.80
		bgc: none
		bol: true
		tal: false
		words: ["Red" "opt" "attempt" "break" "catch" "compose" "disarm" "dispatch" "does" "either" "else" "exit" "forall" "foreach" "for" "forever" "forskip" "func" "function" "halt" "has" "if" "launch" "loop" "next" "quit" "reduce" "remove-each" "repeat" "return" "switch" "throw" "try" "unless" "until" "while" "do"]
		rule: function [ s l fg ] [
			o: copy []
			foreach w l [
				while [(find s w) <> none] [
					rv: to-pair reduce [ (index? find s w)  (length? w) ]
					append o reduce [ (rv) (fg) ]
					replace s w (pad "" (length? w))
				]
			]
			o
		]
	]
	series: context [
		nom: "series"
		fgc: "#FF0000"
		bgc: none
		bol: true
		tal: false
		words: ["alter" "append" "array" "at" "back" "change" "clear" "copy" "difference" "exclude" "extract" "find" "first" "found?" "free" "head" "index?" "insert" "intersect" "join" "last" "length?" "load" "maximum-of" "minimum-of" "offset?" "parse" "pick" "poke" "remove" "remove-each" "repend" "replace" "reverse" "select" "skip" "sort" "switch" "tail" "union" "unique"]
	]
]

cxhx: function [ c ] [
	rejoin reduce [ "#" (to-hex/size c/1 2) (to-hex/size c/2 2) (to-hex/size c/3 2) ] 
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
	zz/offset/x: min (max 100 zz/offset/x) (tp/size/x - 100)
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
	cryn/size/x: mbbp/size/x - (4 * marg)
	fgcp/size/x: cryn/size/x
	fcr/size/x: fgcp/size/x - (2 * marg)
	fcg/size/x: fcr/size/x
	fcb/size/x: fcr/size/x
	bgcp/size/x: cryn/size/x
	bcr/size/x: bgcp/size/x - (2 * marg)
	bcg/size/x: bcr/size/x
	bcb/size/x: bcr/size/x
	ambold/size/x: cryn/size/x
	amital/size/x: cryn/size/x
    wordpane/size/x: cryn/size/x
	wrdlbl/size/x: wordpane/size/x - (marg + marg)
	theword/size/x: wrdlbl/size/x - 165
	addword/offset/x: (theword/offset/x + theword/size/x + 5)
	remword/offset/x: (addword/offset/x + addword/size/x + 5)
	srtword/offset/x: (remword/offset/x + remword/size/x + 5)
	thewords/size/x: wrdlbl/size/x
	zz/draw: compose/deep [ 
		pen off 
		fill-pen 100.100.100
		circle (to-pair compose/deep [5 (to-integer (zz/size/y * 0.5) - 10)]) 2 2 
		circle (to-pair compose/deep [5 (to-integer (zz/size/y * 0.5))]) 2 2
		circle (to-pair compose/deep [5 (to-integer (zz/size/y * 0.5) + 10)]) 2 2 
	]
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
				lexers/selected: index? find lexers/data newlexername
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
				text 200x30 "crayons" font-name "consolas" font-size 24 font-color 80.80.80 bold
			]
			maap: panel 400x245 [
				below
				text-list 400x245
			] 
		]
		zz: panel 10x390 30.30.30 loose [] on-drag [ nudgez ]
		mbb: panel 390x400 40.40.40 [
			mbbp: panel 400x1000 [
				below
				cryn: field 380x30 40.40.40
				fgcp: panel 380x180 [
				    text 80x30 "fg color" on-dbl-click [ 
						either (fgcp/size/y > 55) [ 
							fgcp/size/y: 55 
							bgcp/offset/y: fgcp/offset/y + fgcp/size/y + 10
							ambold/offset/y: bgcp/offset/y + bgcp/size/y + 10
							amital/offset/y: ambold/offset/y + ambold/size/y + 10
							wordpane/offset/y: amital/offset/y + amital/size/y + 10
						] [ 
							fgcp/size/y: 180
							bgcp/offset/y: fgcp/offset/y + fgcp/size/y + 10
							ambold/offset/y: bgcp/offset/y + bgcp/size/y + 10
							amital/offset/y: ambold/offset/y + ambold/size/y + 10
							wordpane/offset/y: amital/offset/y + amital/size/y + 10
						] 
					]
					fghx: field 160x30
					nofg: button 50x30 "X" [ noupdate: true fcr/data: none fcg/data: none fcb/data: none noupdate: false fghx/text: none fgcp/color: none ]
					return
					fcr: slider 360x30 on-change [ face/data: round/to face/data 0.1 unless noupdate [ fgcp/color: to-tuple reduce [ (to-integer (fcr/data * 255))  (to-integer (fcg/data * 255)) (to-integer (fcb/data * 255)) ] fghx/text: cxhx fgcp/color  ]]
					return
					fcg: slider 360x30 on-change [ face/data: round/to face/data 0.1 unless noupdate [ fgcp/color: to-tuple reduce [ (to-integer (fcr/data * 255)) (to-integer (fcg/data * 255)) (to-integer (fcb/data * 255)) ] fghx/text: cxhx fgcp/color  ]]
					return
					fcb: slider 360x30 on-change [ face/data: round/to face/data 0.1 unless noupdate [ fgcp/color: to-tuple reduce [ (to-integer (fcr/data * 255)) (to-integer (fcg/data * 255)) (to-integer (fcb/data * 255)) ] fghx/text: cxhx fgcp/color  ]]
				]
				bgcp: panel 380x180 [
				    text 80x30 "bg color" on-dbl-click [ 
						either (bgcp/size/y > 55) [ 
							bgcp/size/y: 55 
							ambold/offset/y: bgcp/offset/y + bgcp/size/y + 10
							amital/offset/y: ambold/offset/y + ambold/size/y + 10
							wordpane/offset/y: amital/offset/y + amital/size/y + 10
						] [ 
							bgcp/size/y: 180
							ambold/offset/y: bgcp/offset/y + bgcp/size/y + 10
							amital/offset/y: ambold/offset/y + ambold/size/y + 10
							wordpane/offset/y: amital/offset/y + amital/size/y + 10
						] 
					]
					bghx: field 160x30
					nobg: button 50x30 "X" [  noupdate: true bcr/data: none bcg/data: none bcb/data: none noupdate: false bghx/text: none bgcp/color: none ]
					return
					bcr: slider 360x30 on-change [ face/data: round/to face/data 0.1 unless noupdate [ bgcp/color: to-tuple reduce [ (to-integer (bcr/data * 255)) (to-integer (bcg/data * 255)) (to-integer (bcb/data * 255)) ] bghx/text: cxhx bgcp/color  ]]
					return
					bcg: slider 360x30 on-change [ face/data: round/to face/data 0.1 unless noupdate [ bgcp/color: to-tuple reduce [ (to-integer (bcr/data * 255)) (to-integer (bcg/data * 255)) (to-integer (bcb/data * 255)) ] bghx/text: cxhx bgcp/color  ]]
					return
					bcb: slider 360x30 on-change [ face/data: round/to face/data 0.1 unless noupdate [ bgcp/color: to-tuple reduce [ (to-integer (bcr/data * 255)) (to-integer (bcg/data * 255)) (to-integer (bcb/data * 255)) ] bghx/text: cxhx bgcp/color  ]]
				]
				ambold: check 200x30 "bold"
				amital: check 200x30 "italic"
				wordpane: panel 380x500 [
					wrdlbl: text 200x30 "words"
					return
					theword: field 80x30
					addword: button 50x30 "+" [ 
						if (theword/text <> none) and (theword/text <> "") and ((find thewords/data theword/text) = none) [ 
							append thewords/data theword/text
							thewords/selected: (index? find thewords/data theword/text)
						] 
					]
					remword: button 50x30 "-" [ 
						if (theword/text <> none) and (theword/text <> "") and ((find thewords/data theword/text) <> none) [
							widx: thewords/selected
							unless (widx = (length? thewords/data)) [ widx: widx - 1 ]
						    remove-each w thewords/data [ w = theword/text ]
							thewords/selected: widx
							theword/text: thewords/data/:widx
						] 
					]
					srtword: button 50x30 "↓" [
						if (length? thewords/data) > 0 [ sort thewords/data ]
					]
					return
					thewords: text-list 380x200 35.35.35 data lexdat/control/words [ widx: face/selected theword/text: thewords/data/:widx ]
				]
			] on-wheel [
				probe mbb/size/y
				probe face/size/y
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
		if exists? %./default.parse [ 
			lset: load %./default.parse
			lexname/text: "default"
			lexers/selected: index? find lexers/data "./default.dyslex"
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
