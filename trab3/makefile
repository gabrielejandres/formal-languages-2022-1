IN = in/in.txt

run:
	flex analyzer.l
	bison -d -v analyzer.y
	gcc lex.yy.c analyzer.tab.c -o analyzer
	./analyzer $(IN)
	
clean:
	rm analyzer lex.yy.c analyzer.tab.c analyzer.tab.h analyzer.output