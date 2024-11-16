%{
#include <stdio.h>
FILE *output_file;
%}

%option noyywrap

%%

"//".*                                 { fprintf(output_file, "COMMENT "); }
[fF]                                   { fprintf(output_file, "floatdcl "); }
[iI]                                   { fprintf(output_file, "intdcl "); }
[pP]                                   { fprintf(output_file, "print "); }
[a-eg-hj-oq-rt-zA-EG-HJ-OQ-RT-Z]       { fprintf(output_file, "id "); }
[0-9]+                                 { fprintf(output_file, "inum "); }
[0-9]+\.[0-9]+                         { fprintf(output_file, "fnum "); }
"="                                    { fprintf(output_file, "assign "); }
"\+"                                   { fprintf(output_file, "plus "); }
"-"                                    { fprintf(output_file, "minus "); }
"\*"                                   { fprintf(output_file, "multiply "); }
"/"                                    { fprintf(output_file, "divide "); }
\n                                     { fprintf(output_file, "\n"); }
[ \t]+                                 { }

%%

int main(int argc, char **argv) {
    FILE *fd;

    if (argc == 2) {
        fd = fopen(argv[1], "r");
        if (!fd) {
            perror("Error");
            return -1;
        }
        yyin = fd;

        output_file = fopen("tokens.out", "w");
        if (!output_file) {
            perror("Error al crear el archivo de salida");
            fclose(fd);
            return -1;
        }

        yylex();

        fclose(fd);
        fclose(output_file);
    } else {
        printf("Usage: %s <filename>\n", argv[0]);
    }
    return 0;
}
