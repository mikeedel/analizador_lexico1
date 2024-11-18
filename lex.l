%{
#include "y.tab.h"
#include <stdio.h>
%}

%option noyywrap

%%

"COMMENT"           { return COMMENT; }
"floatdcl"          { return floatdcl; }
"intdcl"            { return intdcl; }
"print"             { return print; }
"id"                { return id; }
"inum"              { return inum; }
"fnum"              { return fnum; }
"assign"            { return assign; }
"plus"              { return plus; }
"minus"             { return minus; }
"multiply"          { return multiply; }
"divide"            { return divide; }
\n                  { return '\n'; } 
[ \t]+              { /* Ignorar espacios */ }
.                   { /* Ignorar cualquier otro carácter */ }

%%
