FILENAME=calc

clear: 
	rm -rf *.o

calc: ./src/calc.l ./src/calc.y
	lex ./src/calc.l
	yacc ./src/calc.y -d 
	gcc lex.yy.c y.tab.c -o calc -ll -lm  
