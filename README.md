# Analizador Léxico y Sintactico con Lex y Yacc

Este proyecto implementa un **analizador léxico y sintáctico** utilizando las herramientas **Lex** y **Yacc**. El propósito del analizador léxico es leer un archivo de entrada y dividirlo en **tokens** según las reglas definidas  en 'ex.l'. El archivo 'ex.l' es el que recibe un archivo 'input' para generar un archivo con los tokens. El archivo 'lex.l' trabaja en conjunto con 'syntax.y' para crear un parser que recibe el archivo de tokens creado por 'ex.l' y crear un arbol de la CFG para visualizarlo en Graphviz. 

Makefile:

lex ex.l

gcc lex.yy.c -o example

./example input

yacc -d syntax.y

gcc y.tab.c lex.yy.c -o parser 
 
./parser tokens.out
