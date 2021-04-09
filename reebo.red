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
;; TODO: [?] add sample code to dyslex file (requires extra layer of do load shitfuckery)
;; TODO: [!] add crayon toolbar: add remove sort move-up move-down
;; TODO: [!] finish default parse rule
;; TODO: [!] add complete red dyslex file, save as default, embase it when done
;; TODO: [X] add local/global source switcher to source toolbar
;; TODO: [X] add local code sample per item in lexdat
;; TODO: [X] change data to series, use position as index
;; TODO: [X] fix anything busted by the above
;; TODO: [X] fix possible face accumulation
;; TODO: [X] add exact function aquisition using parse print object
;; TODO: [X] add event that backwashes the rule function
;; TODO: [X] add sort by char-count
;; TODO: [X] add backwash bold italic and words
;; TODO: [X] add bold/italic in crayon list
;; TODO: [X] add backwash rule
;; TODO: [X] add save/load dyslex files
;; TODO: [X] add reflow params
;; TODO: [-] add 3rd pane to top half, make it a tab-pane with: raw-data, console output
;; TODO: [-] investigate loopless access to ui items
;; TODO: [-] save/load code as bin: save/as brule: #{} rule 'redbin
;; TODO: [ ] add font-size to source toolbar
;; TODO: [ ] investigate drag to re-order crayons
;; TODO: [ ] add bold and italic to rich-text field
;; TODO: [ ] add bgcolor to rich-text data
;; TODO: [ ] finish theming, test with other WMs


marg: 10
tabh: 0 ;; height of the statusbar (none atm)
noupdate: false	;; stop ui chain-reactions
cidx: 0  ;; the list selection index
hil: 180.60.50
srctxt: {source text goes here}
globsrc: {Red [needs 'view]
makepanel: function [ ] [
	p: compose/deep [ panel 100x100 255.0.0 loose [
			l: text 120x30 font-name "consolas" font-size 10 font-color 180.180.180 bold
			field 120x30 with [ text: "txt goes here" ] on-change [ l/text: face/text ]
		]
	]
	p
]
view [
	p: panel 400x400 [
		below
		button 400x30 "make panel" [ append p/ pane layout/only makepanel ]
	]
	do [ button/offset: 0x370 button/size: 400x30 ]
]}

getmylayout: func [ cdx nom fgc bgc bol tal ] [ 
    compose/deep [
	    panel 300x55  with [ color: (bgc) ] extra [ idx: (cdx) cname: (nom) pos: 'bg ] draw [ ] [
			below
		    text 200x30 with [ 
				text: (nom) 
				color: (either none? bgc [50.50.50] [bgc ])
				font: make font! [ 
					name: "consolas" 
					color: (fgc) 
					size: 24 
					style: [ (unless none? bol [if bol ['bold]])  (unless none? tal [if tal ['italic]])  ] 
				] 
			] extra [ idx: (cdx) cname: (nom) pos: 'fg ]
		] on-down [ 
			cidx: face/extra/idx
			clear face/draw
			append face/draw compose [ pen (hil) line-width 6 box 0x0 (quote (face/size - 3x0)) ]
			doselect "^-" (rejoin [ 'lexdat "/" (cdx) "/" 'lay ])
		] 
	]
]

parseruletest: {rtdat: copy []
s: copy mccp/text
pos: 1x1
foreach w thewords/data [
	parse s [any (pos: 0x0) [ to w mi: (pos/x: index? mi) thru w mo: (pos/y: (index? mo) -  (index? mi)) ] (append rtdat pos append rtdat fgcp/color) ]
]
mddp/data: rtdat}

crayon: context [
	cdx: 0
	nom: "new_crayon"
	fgc: 200.0.0
	bgc: none
	bol: true
	tal: true
	words: ["keywords"]
	rule: func [][
o: copy [] 
p: 0x0 
s: copy srctxt 
ws: charset [ " /:()[]^/^-" ]
foreach w words [
	wl: (length? w)
	parse s [
		any [ 
			(p: 0x0)
			to [1 ws ahead w] skip mi: 
			(p/x: index? mi) 
			wl skip mo: 
			[ahead 1 ws (p/y: (index? mo) - p/x) (unless none? fgc [append o p append o fgc]) | skip ] ; | <emacs issue :(
		]
	]
] 
o
]
	scratch: {per-crayon sample code goes here^\it is saved with the crayon}
]

lexdat: copy []
append lexdat copy/deep crayon
append lexdat copy/deep crayon
;probe lexdat
lexdat/1/nom: "control"
lexdat/2/nom: "series"
lexdat/1/cdx: 1
lexdat/2/cdx: 2
;probe lexdat
lexdat/1/words: copy ["Red" "opt" "attempt" "break" "catch" "compose" "disarm" "dispatch" "does" "either" "else" "exit" "forall" "foreach" "for" "forever" "forskip" "func" "function" "halt" "has" "if" "launch" "loop" "next" "quit" "reduce" "repeat" "return" "switch" "throw" "try" "unless" "until" "while" "do"]
lexdat/2/words: copy ["alter" "append" "array" "at" "back" "change" "clear" "copy" "difference" "exclude" "extract" "find" "first" "found?" "free" "head" "index?" "insert" "intersect" "join" "last" "length?" "maximum-of" "minimum-of" "offset?" "pick" "poke" "remove" "remove-each" "repend" "replace" "reverse" "select" "skip" "sort" "switch" "tail" "union" "unique"]
lexdat/1/scratch: {attempt (attempt) attempt123 'attempt attempt? to-attempt /attempt [attempt]^/attempt makeattempt^-attempt^/:attempt^-attempt: attempt}
lexdat/2/scratch: {append (append) append123 'append append? to-append /append [append]^/append makeappend^-append^/:append^-append: append}

localrender: func [] [
	noupdate: true
	unless none? srctxt [
		unless srctxt = "" [
			rxdat: copy [] 
			foreach c lexdat [
				if c/cdx = cidx [
					tdat: c/rule
					break
				]
			]
			if (length? tdat) > 0 [
				clear mddp/data
				foreach d tdat [ unless none? d [ append rxdat d ] ]
				mddp/text: copy srctxt
				mddp/data: copy rxdat
				;clear rxdat
			]
		]
	]
	noupdate: false
]

renderitall: func [ tabi tabf ] [
	print [ tabi "renderitall triggered by" tabf "..."]
	;clear mddp/data
	noupdate: true
    rxdat: copy []
	foreach c lexdat [	
		unless none? c/words [
		    print [ tabi "^-parsing words for" c/nom "..." ]
		    o: c/rule
		    print [ tabi "^-cleansing parse results..."  ]
		    foreach r o [ unless none? r [ append rxdat r ] ]
		]
   	]
	if (length? rxdat) > 0 [
		print [ tabi "^-sending srctxt to mddp..."]
		mddp/text: copy srctxt 
		mddp/data: copy rxdat
		;clear rxdat
	]
	noupdate: false
	print [ tabi "renderitall is done."]
]

cxhx: function [ c ] [
	rejoin reduce [ "#" (to-hex/size c/1 2) (to-hex/size c/2 2) (to-hex/size c/3 2) ] 
]



doselect: func [ tabi tabf ] [
	print [ tabi "doselect triggered by " tabf " idx= " cidx ]
	allgood: false
	print [ tabi "^-checking cdx: " lexdat/:cidx/cdx ]
	if lexdat/:cidx/cdx = cidx [
		allgood: true
		print [ tabi "^-cdx is in sync with" cidx " setting params..." ]
		noupdate: true
		unless none? lexdat/:cidx/nom [ cryn/text: lexdat/:cidx/nom ]
		either none? lexdat/:cidx/fgc [ 
			fgcp/color: 50.50.50 
			fcr/data: 0.0 
			fcg/data: 0.0 
			fcb/data: 0.0 
			fghx/text: ""
		] [
			print [tabi "^-^-sending fg color " lexdat:cidx/fgc " to params..." ]
			fgcp/color: lexdat/:cidx/fgc 
			fcr/data: (lexdat/:cidx/fgc/1 / 255.0) 
			fcg/data: (lexdat/:cidx/fgc/2 / 255.0) 
			fcb/data: (lexdat/:cidx/fgc/3 / 255.0) 
			fghx/text: cxhx lexdat/:cidx/fgc 
		]
		either none? c/bgc [
			bgcp/color: 50.50.50 
			bcr/data: 0.0 
			bcg/data: 0.0 
			bcb/data: 0.0 
			bghx/text: ""
		] [
			print [tabi "^-^-sending bg color " c/bgc " to params..." ]
			bgcp/color: lexdat/:cidx/bgc 
			bcr/data: (lexdat/:cidx/bgc/1 / 255.0) 
			bcg/data: (lexdat/:cidx/bgc/2 / 255.0) 
			bcb/data: (lexdat/:cidx/bgc/3 / 255.0) 
			bghx/text: cxhx lexdat/:cidx/bgc
		]
		print [tabi "^-^-checking sytle data: " lexdat/:cidx/bol c/tal "..." ]
		either none? lexdat/:cidx/bol [ ambold/data: false ] [ if logic? lexdat/:cidx/bol [ print [ tabi "^-^-sending bold " lexdat/:cidx/bol "to params.." ] ambold/data: lexdat/:cidx/bol ] ]
		either none? lexdat/:cidx/tal [ amital/data: false ] [ if logic? lexdat/:cidx/tal [ print [ tabi "^-^-sending italic " lexdat/:cidx/tal "to params.." ] amital/data: lexdat/:cidx/tal ] ]
		theword/text: ""
		print [ tabi "^-^-checking words " lexdat/:cidx/words ]
		either none? lexdat/:cidx/words [ clear thewords/data ] [ print [ tabi "^-^-sending thewords to params.." ] thewords/data: lexdat/:cidx/words ]
		print [ tabi "^-^-sending therule to params..."] 
		;therule/text: mold get 'lexdat/:cidx/rule
		ftxt: "" parse (form lexdat/:cidx) [ thru "rule: " copy ftxt thru "o^/]" ]
		therule/text: ftxt
		if sourcemode/selected = 1 [ mccp/text: copy globsrc srctxt: copy globsrc ]
		if sourcemode/selected = 2 [ mccp/text: copy lexdat/:cidx/scratch srctxt: copy lexdat/:cidx/scratch ]
		noupdate: false
		print [ tabi "^-^-params sent."]
	]
	either allgood [
		foreach-face maap [
			unless none? face/extra/idx [
				if  face/extra/idx <> cidx [
					if face/extra/pos = 'bg [
						print [ tabi "^-clearing crayon draw..."]
						clear face/draw
					]
				]
			]
		]
		foreach-face maap [
			if face/extra/idx = cidx [
				if face/extra/pos = 'bg [ print [ tabi "^-setting crayon bg color to " bgcp/color "..." ] face/color: bgcp/color ]
				if face/extra/pos = 'fg [ 
					print [ tabi "^-setting crayon fg color to " fgcp/color "..." ]
					face/font/color: fgcp/color
					clear face/font/style
					if (ambold/data <> none) [ print [ tabi "^-setting crayon bold to " ambold/data  "..." ] if ambold/data [ append face/font/style 'bold ] ]
					if (amital/data <> none) [ print [ tabi "^-setting crayon italic to " amital/data  "..." ] if amital/data [ append face/font/style 'italic ] ]
					print [ tabi "^-^-style set to: " face/font/style ]			
				]
				break
			]
		]
		renderitall "^-" "doselect"
	] [ print [ "cdx " lexdat/:cidx/cdx " is not in sync with current selection, lexdat needs to be sorted by cdx after any change to cdx" ] probe lexdat/(cidx) ]
	print [ tabi "doselect function is done."]
]	

backwashfgc: func [ col tabi tabf ] [
	print [ tabi "backwashfgc triggered by " tabf "..." ]
	noupdate: true
	if lexdat/:cidx/cdx = cidx [
		lexdat/:cidx/fgc: col
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
	print [ tabi "backwashfgc is done." ]
]

backwashbgc: func [ col tabi tabf ] [
	print [ tabi "backwashbgc triggered by " tabf "..." ]
	noupdate: true
	if lexdat/:cidx/cdx = cidx [
		lexdat/:cidx/bgc: col
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
	if lexdat/:cidx/cdx = cidx [
		either none? ambold/data [ lexdat/:cidx/bol: false ] [ lexdat/:cidx/bol: ambold/data ]
		either none? amital/data [ lexdat/:cidx/tal: false ] [ lexdat/:cidx/tal: amital/data ]
	]
	noupdate: false
]

backwashwords: func [ ] [
	print [ "^-backwashwords triggered at index: " cidx ]
	noupdate: true
	;probe lexdat/:cidx/cdx
	either lexdat/:cidx/cdx = cidx [
		print [ "^-^-checking thewords param: " thewords/data ]
		unless none? thewords/data [
			print [ "^-^-^-old words: " lexdat/:cidx/words ]
		    ;clear lexdat/:cidx/words
		    lexdat/:cidx/words: copy thewords/data
		    print [ "^-^-^-new words: " lexdat/:cidx/words ]
		]
	] [ print "lexdat position and index are out of sync" ]
	noupdate: false
	print "^-backwashwords is done."
]

backwashrule: func [ ] [
	print [ "backwashrule func triggered..." ]
	noupdate: true
	if lexdat/:cidx/cdx = cidx [
		unless none? therule/text [
			if therule/text <> "" [
				newobj: context [
					cdx: cidx
					nom: copy lexdat/:cidx/nom
					fgc: lexdat/:cidx/fgc
					bgc: lexdat/:cidx/bgc
					bol: lexdat/:cidx/bol
					tal: lexdat/:cidx/tal
					words: copy lexdat/:cidx/words
					rule: do (load therule/text)
				]
				lexdat/:cidx: copy/deep newobj

				; lexdat/:cidx/rule: do (bind load therule/text lexdat/:cidx)
				; bind seems to be doing the same thing as rebuilding the object, disabling until I know exactly what its doing...

			    rr: "" parse (form lexdat/:cidx) [ thru "rule:" copy rr thru "o^/]" ]
				print [ "changed rule:^/" rr ]
			]
		]
	]
	noupdate: false
]

ripplecrayons: func [ ] [
	print [ "ripplecrayons triggered..." ] 
	print [ "^-current cidx is:" cidx ]
	;; stacks crayons by id, which should be synced to lexdat cdx
	lo: 0
	tmarg: 20
	foreach-face maap [
		;probe face/pane
		unless none? face/extra/pos [
			;probe face/extra/pos
			if face/extra/pos = 'bg [
				;print [ "^-checking crayon" face/extra/cname "index:" face/extra/idx ]
				if none? face/color [ face/color: 50.50.50 ]
				either face/extra/idx = cidx [ append face/draw compose [ pen (hil) line-width 6 box 0x0 (face/size - 3x0) ] ] [ clear face/draw ]
				print [ "^-offsetting face" face/extra/cname "at cdx" face/extra/idx "..."]
				face/offset/y: tmarg + to-integer ((face/extra/idx - 1) * (face/size/y + 5))
				print [ "^-^-face offset to:" face/offset/y ]
				lo: max lo (face/offset/y + face/size/y)
			]
		]
	]
	maap/size/y: lo + 50
	;probe maap/size/y
]

refloparams: func [ pp ] [

	cx: pp/size/x

	su: 0
	n: 1
	rows: copy/deep [ [] [] [] [] ]
	r: 1
	i: 1

	foreach-face pp [
		if face/extra/reflo [
			su: su + face/size/x
			either su >= (cx - 30) [ 
				r: r + 1 append rows/:r face 
				su: face/size/x
			] [
				append rows/:r face
			]
			n: n + 1
		]
	]

	rk: 55
	mxy: 0

	foreach rw rows [
		if (length? rw) > 0 [
			mk: marg
			foreach co rw [
				p: reduce co
				p/offset/x: mk
				mk: mk + p/size/x + marg
				p/offset/y: rk
				mxy: max mxy (p/offset/y + p/size/y)
			]
			rk: mxy + marg
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
	;maap/size/y: maa/size/y - (maah/size/y + (2 * marg))
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
	;fgcp/size/x: cryn/size/x
	fghx/size/x: fgcp/size/x - (95 + 80)
	nofg/offset/x: fghx/offset/x + fghx/size/x + 10
	fcr/size/x: fgcp/size/x - (2 * marg)
	fcg/size/x: fcr/size/x
	fcb/size/x: fcr/size/x
	;bgcp/size/x: cryn/size/x
	bghx/size/x: bgcp/size/x - (95 + 80) 
	nobg/offset/x: bghx/offset/x + bghx/size/x + 10
	bcr/size/x: bgcp/size/x - (2 * marg)
	bcg/size/x: bcr/size/x
	bcb/size/x: bcr/size/x
	;ambold/size/x: cryn/size/x
	;amital/size/x: cryn/size/x
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
	doit/size/x: therule/size/x - (marg + revertit/size/x)
	revertit/offset/x: doit/offset/x + doit/size/x + marg
	refloparams mbbp
	rippleparms
	foreach-face maap [
	    if face/extra/pos = 'bg [
			face/size/x: maap/size/x - (to-integer (4 * marg))
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
	wordpanel/offset/y: max (bgcp/offset/y + bgcp/size/y + 10) (amital/offset/y + amital/size/y + 10)
	;wordpanel/size/y: (rulepanel/offset/y - wordpanel/offset/y) - 10
	;thewords/size/y: wordpanel/size/y - 90
    rulepanel/offset/y: wordpanel/offset/y + wordpanel/size/y + 10
	rulepanel/size/y: mbbp/size/y - (rulepanel/offset/y + 20)
	therule/size/y: rulepanel/size/y - 100
	doit/offset/y: rulepanel/size/y - 40
	revertit/offset/y: doit/offset/y
]

view/tight/flags/options [
	title "reebo"
	below
	hh: panel 800x55 35.35.35 [
		lexers: drop-list 200x30 font-name "consolas" font-size 10 font-color 180.180.180 bold data (collect [foreach file read %./ [ if (find (to-string file) ".dyslex") [keep rejoin ["./" (to-string file)]] ]]) on-change [
			unless noupdate [
				print [ "lexers change event triggered..." ]
				noupdate: true
				;probe face/data/(face/selected)
				lxn: copy face/data/(face/selected)
				parse lxn [ remove thru "./" to "." remove to end ]
				lexname/text: lxn
				;probe face/data/(face/selected)
				;blexdat: read/binary to-file face/data/(face/selected)
				;lexdat: load/as blexdat 'redbin
				lexdat: do [ reduce load to-file face/data/(face/selected) ]
			    clear maap/pane
				foreach c lexdat [
					print [ "restoring list ui for crayon" c/nom "at index" c/cdx ]
					append maap/pane layout/only getmylayout c/cdx c/nom c/fgc c/bgc c/bol c/tal
					;probe maap/pane
				]
				;; sort incoming data, just in case cdx was changed
				sort/compare lexdat func [ a b ] [
					case [
						a/cdx > b/cdx [-1]
						a/cdx < b/cdx [1]
						a/cdx = b/cdx [0]
					]
				]
			    ripplecrayons
				nudgez
				cidx: 1
				noupdate: false
				doselect "^-" "lexers"
			]
		]
		pad 10x0
	    lexname: field 200x30 font-name "consolas" font-size 10 font-color 180.180.180 bold on-change [ unless noupdate [ print [ "lexname change event triggered..." ] ] ]
		lnew: button 80x34 "save" font-name "consolas" font-size 10 font-color 180.180.180 bold [ 
			if (lexname/text <> "") and (lexname/text <> none) [
				noupdate: true
			   	newlexname: rejoin [ "./" lexname/text ".dyslex" ]
				print [ "lnew button event triggered, writing lexdat..." ]
				;save/as blexdat: #{} lexdat 'redbin
				;probe blexdat
			    ;write/binary to-file newlexname blexdat
				write to-file newlexname lexdat
				clear lexers/data
				lexers/data: (collect [foreach file read %./ [ if (find (to-string file) ".dyslex") [keep rejoin ["./" (to-string file)]] ]])
				lexers/selected: index? find lexers/data newlexname
				noupdate: false
			]
		]
		pad 10x0
		lsave: button 160x34 "export" font-name "consolas" font-size 10 font-color 180.180.180 bold [
			if (lexname/text <> "") and (lexname/text <> none) [
				estr: ""
				foreach c lexdat [
					unless none? c/nom [
						estr: rejoin [ estr "name:^-^-^-" c/nom "^/"]
						either none? c/fgc 		[ estr: rejoin [ estr "foreground:^/" ] ]	[ estr: rejoin [ estr "foreground:^-^-" (cxhx c/fgc) "^/"]	]
						either none? c/bgc 		[ estr: rejoin [ estr "background:^/" ] ]	[ estr: rejoin [ estr "background:^-^-" (cxhx c/bgc) "^/"]	]
						either none? c/bol 		[ estr: rejoin [ estr "bold:^/" ] 		]	[ estr: rejoin [ estr "bold:^-^-^-" c/bol "^/"]				]
						either none? c/tal 		[ estr: rejoin [ estr "italic:^/" ] 	]	[ estr: rejoin [ estr "italic:^-^-^-" c/tal "^/"]				]
						either none? c/words 	[ estr: rejoin [ estr "words:^/" ]		]	[ estr: rejoin [ estr "words:^-^-^-" c/words "^/^/^/^/"] 		]
					]
				]
				op: request-dir
				unless none? op [
		    		write to-file rejoin [ op lexname/text "_export.txt" ] estr
				]
			]
		]
	]
	tp: panel 800x745 [
		below
		maa: panel 800x300 40.40.40 [
			maap: panel 400x245 [
				below
			] on-wheel [				
				either event/picked > 0 [
					face/offset/y: face/offset/y + 40
				] [
					face/offset/y: face/offset/y - 40
				]
				bo: maa/size/y - face/size/y
				bo: min bo 0
	    		face/offset/y: max bo min face/offset/y 55 
			]
			maah: panel 45.45.45 800x55 [
				text 160x30 "crayons" font-name "consolas" font-size 24 font-color 80.80.80 bold
				button 30x33 "+" font-name "consolas" font-size 10 font-color 180.180.180 bold [
					print [ "new-crayon button event triggered..." ]
					noupdate: true
				    cidx: (length? lexdat) + 1
					print [ "making new crayon at cidx: " cidx ]
				    append lexdat copy/deep crayon
					;probe lexdat/:cidx
					lexdat/:cidx/cdx: cidx
				    append maap/pane layout/only getmylayout cidx lexdat/:cidx/nom lexdat/:cidx/fgc lexdat/:cidx/bgc lexdat/:cidx/bol lexdat/:cidx/tal
					ripplecrayons
					nudgez
					noupdate: false
					doselect "^-" "new-crayon button"	
			    ]
				pad 5x0 button 30x33 "-" font-name "consolas" font-size 10 font-color 180.180.180 bold [ ]
			    pad 5x0 button 30x33 "▼" font-name "consolas" font-size 10 font-color 180.180.180 bold [ 
					if cidx < (length? lexdat) [
						fromname: lexdat/:cidx/nom
						toname: lexdat/(cidx + 1)/nom
						print [ "changing lexdat" lexdat/(cidx + 1)/cdx "to" cidx ]
						lexdat/(cidx + 1)/cdx: cidx
						print [ "changing lexdat" lexdat/(cidx)/cdx "to" (cidx + 1) ]
						lexdat/:cidx/cdx: (cidx + 1)
						foreach-face maap [
							print [ "checking crayon" face/extra/cname ]
						    if face/extra/cname = fromname [
								print [ "^-changing crayon" face/extra/cname "idx from" face/extra/idx "to" (cidx + 1) ]
								face/extra/idx: (cidx + 1)
								print [ "^-^-verifying crayon" face/extra/cname "idx:" face/extra/idx ]
							] 
						    if face/extra/cname = toname [
							    print [ "^-changing crayon" face/extra/cname "idx from" face/extra/idx "to" cidx ]
							    face/extra/idx: cidx
							    print [ "^-^-verifying crayon" face/extra/cname "idx:" face/extra/idx ]
							]
						]
						sort/compare lexdat func [ a b ] [
							case [
								a/cdx > b/cdx [-1]
								a/cdx < b/cdx [1]
								a/cdx = b/cdx [0]
							]
						]
						foreach c lexdat [ probe c/cdx ]
						cidx: cidx + 1
						ripplecrayons
					]
				]
				pad 5x0 button 30x33 "▲" font-name "consolas" font-size 10 font-color 180.180.180 bold [ ]
				pad 5x0 button 30x33 "↓" font-name "consolas" font-size 10 font-color 180.180.180 bold [
					noupdate: true
					print ["crayon sorting started..."]
					cn: lexdat/:cidx/nom
					print [ "^-current crayon is: " cn ]
					o: lexdat/1/nom
					delt: false
					foreach c lexdat [ delt: (c/nom > o) o: c/nom if delt [ break ] ]
					sby: -1x1
					if delt [ sby: 1x-1 ]
					sort/compare lexdat func [ a b ] [
						case [
							a/nom > b/nom [sby/x]
							a/nom < b/nom [sby/y]
							a/nom = b/nom [0]
						]
					]
					n: 1
					foreach c lexdat [
						foreach-face maap [ 
							if face/extra/cname = c/nom [ 
								;print ["^-changing face" face/extra/cname "index from:" face/extra/idx " to: " n ] 
								face/extra/idx: n 
								;print ["^-^-doublechecking face" face/extra/cname "index:" face/extra/idx ] 
							]
						]
				    	c/cdx: n if c/nom = cn [ 
							print [ "^-^-new index of current crayon" cn "is" n ] 
							cidx: n
						]
						n: n + 1 
					]
					;clear maap/pane
					;foreach c lexdat [ append maap/pane layout/only getmylayout c/cdx c/nom c/fgc c/bgc c/bol c/tal ]
					ripplecrayons
					nudgez
					noupdate: false
					;probe cidx				
				]
				;button 30x33 "⮍" font-name "consolas" font-size 10 font-color 180.180.180 bold [ ]
			]
		]
		zz: panel 10x390 30.30.30 loose [] on-drag [ nudgez ]
		mbb: panel 390x400 40.40.40 [
			mbbp: panel 400x1100 [
				below
				cryn: field 380x30 40.40.40 on-change [ 
					probe noupdate
					unless noupdate [
						unless none? face/text [
							unless face/text = "" [
								lexdat/:cidx/nom: replace face/text " " "_"
								foreach-face maap [ if face/extra/idx = cidx [ if face/extra/pos = 'fg [ face/text: lexdat/:cidx/nom ] ] ]
							]
						]
					]
				]
				fgcp: panel 280x180 50.50.50 extra [ reflo: true ] [
				    text 80x30 "fg color" on-dbl-click [
						either (fgcp/size/y > 55) [
							fgcp/size/y: 55
							bgcp/offset/y: fgcp/offset/y + fgcp/size/y + 10
						    refloparams mbbp rippleparms
						] [
							fgcp/size/y: 180
							bgcp/offset/y: fgcp/offset/y + fgcp/size/y + 10
						    refloparams mbbp rippleparms
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
								backwashfgc hxc  "^-" "fghx" renderitall "^-" "fghx field edit"
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
						backwashfgc none  "^-" "nofg" renderitall "^-" "nofg check"
						noupdate: false 
					]
					return
					fcr: slider 360x30 on-change [ 
						face/data: round/to face/data 0.1 
						unless noupdate [ 
							noupdate: true
							fgcp/color: to-tuple reduce [ (to-integer (fcr/data * 255))  (to-integer (fcg/data * 255)) (to-integer (fcb/data * 255)) ] 
							fghx/text: cxhx fgcp/color 
							backwashfgc fgcp/color "^-" "fcr" renderitall "^-" "fcr slider change"
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
							backwashfgc fgcp/color "^-" "fcg" renderitall "^-" "fcg slider change"
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
							backwashfgc fgcp/color "^-" "fcb" renderitall "^-" "fcb slider change"
							noupdate: false
						]
					]
				]
				bgcp: panel 280x180 50.50.50 extra [ reflo: true ] [
				    text 80x30 "bg color" on-dbl-click [
						either (bgcp/size/y > 55) [
							bgcp/size/y: 55
						    refloparams mbbp rippleparms
						] [
							bgcp/size/y: 180
						    refloparams mbbp rippleparms
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
				ambold: check 100x30 "bold" extra [ reflo: true ] [ unless noupdate [ backwashstyle "^-" "ambold" ] ]
				amital: check 100x30 "italic" extra [ reflo: true ] [ unless noupdate [ backwashstyle "^-" "amital" ] ]
				wordpanel: panel 380x250 [
					wrdlbl: text 200x30 "words (processed in order)"
					return
					theword: field 80x30 on-change [
						unless noupdate [
							if (face/text <> none) and (face/text <> "") [
								widx: thewords/selected
								unless none? widx [
									thewords/data/:widx: face/text
								]
							]
						]
					] on-enter [ backwashwords renderitall "^-" "theword area edit" ]
					return
					addword: button 40x30 "+" [ 
						noupdate: true
						append thewords/data "new_word"
						thewords/selected: (length? thewords/data)
						theword/text: copy thewords/data/(thewords/selected)
						backwashwords
						noupdate: false
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
							;g: copy thewords/data
						    o: thewords/data/1
							delt: false
						    foreach d thewords/data [ delt: (d > o) o: d if delt [ break ] ]
						    either delt [
								sort/compare thewords/data func [a b] [
									case [
										a > b [1]
										a < b [-1]
										a = b [0]
									]
								]
							] [
								sort/compare thewords/data func [a b] [
									case [
									    a > b [-1]
									    a < b [1]
									    a = b [0]
									]
								]
							]
							;clear thewords/data
							;thewords/data: copy g
							;clear g
							theword/text: none
							backwashwords
							noupdate: false
						]
					]
					srtlen: button 60x30 "↓#" [
						if (length? thewords/data) > 0 [
							noupdate: true
							; g : copy thewords/data
						    o: (length? thewords/data/1)
							delt: 0
						    foreach d thewords/data [ delt: ((length? d) - o) o: (length? d) if delt > 0 [ break ] ]
						    either delt > 0 [
								sort/compare thewords/data func [a b] [
									case [
										(length? a) > (length? b) [1]
										(length? a) < (length? b) [-1]
										(length? a) = (length? b) [0]
									]
								]
							] [
								sort/compare thewords/data func [a b] [
									case [
										(length? a) > (length? b) [-1]
										(length? a) < (length? b) [1]
										(length? a) = (length? b) [0]
									]
								]
							]
							;clear thewords/data
							;thewords/data: copy g
							;clear g
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
					therule: area 380x200 35.35.35 with [ text: "rich-text data-building code goes here" ] font-name "consolas" font-size 9 font-color 255.180.80 bold on-change [ backwashrule ]
					across
					doit: button 120x30 "try it" [
						clear mddp/data
						;s: copy mccp/text 
						;o: copy []
					    ;lexdat/(cidx)/rule s o
						
					   	mddp/text: copy mccp/text 
						foreach c lexdat [
							if c/cdx = cidx [
								rdat: c/rule
								;print [ "lexdat" cidx "rule returns:" rdat ]
								break
							]
						]
						mddp/data: rdat
						;clear s
						;print [ "rtdat: " o ]
						;clear o
					]
				    revertit: button 80x30 "revert" [ therule/text: copy mold get 'crayon/rule backwashrule ]
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
				text 160x30 "source" font-name "consolas" font-size 24 font-color 80.80.80 bold
				sourcemode: drop-list 100x30 data [ "global" "local" ] select 1  font-name "consolas" font-size 9 font-color 180.180.180 bold [
					noupdate: true
					switch sourcemode/selected [
						1 [ mccp/font/color: 80.255.80 mccp/text: copy globsrc srctxt: copy globsrc renderitall "^-" "sourcemode selection change"  ]
						2 [ mccp/font/color: 255.80.80 mccp/text: copy lexdat/:cidx/scratch srctxt: copy lexdat/:cidx/scratch localrender ]
					]
					noupdate: false
				]
				text 80x30 "font size" font-name "consolas" font-size 10 font-color 180.180.180 bold
				drop-list 60x30 data [ "9" "12" "14" "16" "18" "24" ] select 1 font-name "consolas" font-size 9 font-color 180.180.180 bold [
				    mccp/font/size: to-integer face/data/(face/selected)
				]
			]
			mccp: area 390x300 40.40.40 font-name "consolas" font-size 9 font-color 128.255.255 bold with [
				text: srctxt
			] on-change [ 
			    unless noupdate [
					unless none? face/text [
						print [ "mccp text change event triggered..." ]
						srctxt: copy face/text
						switch sourcemode/selected [
							1 [ globsrc: copy face/text renderitall "^-" "mccp area edit" ]
							2 [ lexdat/:cidx/scratch: copy face/text localrender ]
						]
					]
				]
			]
		]
		vv: panel 10x390 30.30.30 loose [] on-drag [ nudgev ]
		mdd: panel 390x400 40.40.40 [
			mddh: panel 390x55 45.45.45 [
				text 160x30 "result" font-name "consolas" font-size 24 font-color 80.80.80 bold
				text 80x30 "font size" font-name "consolas" font-size 10 font-color 180.180.180 bold
				drop-list 60x30 data [ "9" "12" "14" "16" "18" "24" ] select 1 font-name "consolas" font-size 9 font-color 180.180.180 bold [
				    mddp/font/size: to-integer face/data/(face/selected)
				]
			]
			mddp: rich-text 390x345 40.40.40 font-name "consolas" font-size 9 font-color 128.128.128 bold
		]   	
	]
	do [ 
		if exists? %./default.dyslex [ 
			lset: load %./default.dyslex
			lexname/text: "default"
			lexers/selected: index? find lexers/data "./default.dyslex"
		]
	    foreach c lexdat [
			;probe c
			;append maap/pane layout/only  c/lay
			;print [ "making ui from data..." c/cdx c/nom c/fgc/ c/rule ]
			append maap/pane layout/only getmylayout c/cdx c/nom c/fgc c/bgc c/bol c/tal
		]
	    ripplecrayons
		cidx: 1
		doselect "^-" "view initialize"
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
