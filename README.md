# rebo
primarily a (frustrating) excercise in modifying code at runtime, as well as learning parse

assume its busted unless there's a compiled binary

![screenie](210407_rebo_screenie.png)

# todo
- [ ] figure out how to backwash an object function param without turning it into a string & breaking it
- [ ] implement a parse-print-cheat for grabbing the function *exactly* as its written in an object
- [ ] finish default parse that works with 0\~1-of-charset+word+0\~1-of-charset to grab things like 'panel' in '/panel/' 'panel:' '(panel' ' panel ', but not 'mypanel'

then the boring stuff:
- [ ] crayon list remove
- [ ] crayon list move up/down
- [ ] crayon list sort
- [ ] investigate drag reordering of crayons
- [ ] finish red .dyslex file
- [ ] implement bold & italic for the rich-text field
- [ ] investigate background color for rich-text, without drawing boxes!
- [ ] add an exporter for Geany (find a compatible lexer 1st that works with semicolon comments and square brackets)
- [ ] add an exporter for emacs (probably based on lisp major mode, with overrides)
