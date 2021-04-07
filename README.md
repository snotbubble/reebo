# reebo
primarily a (frustrating) excercise in modifying code at runtime, as well as learning parse

assume its busted unless there's a compiled binary

![screenie](210407b_rebo_screenie.png)

# todo
- [ ] finish default parse that works with 0\~1-of-charset+word+0\~1-of-charset to grab things like 'panel' in '/panel/' 'panel:' '(panel' ' panel ', but not 'mypanel'
- [ ] save source sample in .dyslex file... somewhere

then the boring stuff:
- [ ] add crayon list remove
- [ ] add crayon list move up/down
- [ ] add crayon list sort
- [ ] investigate drag reordering of crayons
- [ ] investigate exposing tab-width for gtk area widget
- [ ] finish red .dyslex file
- [ ] add bold & italic for the rich-text field
- [ ] investigate background color for rich-text, without drawing boxes!
- [ ] add an exporter for Geany (find a compatible lexer 1st that works with semicolon comments and square brackets)
- [ ] add an exporter for emacs (probably based on lisp major mode, with overrides)
