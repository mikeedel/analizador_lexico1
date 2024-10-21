%{
#include <stdio.h>
%}

%option noyywrap

%%


"//".*                                 { printf("COMMENT "); }


[fF]                                   { printf("floatdcl "); }
[iI]                                   { printf("intdcl "); }


[pP]                                   { printf("print "); }


[a-eg-hj-oq-rt-zA-EG-HJ-OQ-RT-Z]       { printf("id "); }

[root@host-1-17 ~]# lex example.k
lex: can't open example.k
[root@host-1-17 ~]# lex example.l
[root@host-1-17 ~]# ls
anaconda-ks.cfg  example.l  initial-setup-ks.cfg  input  lex.yy.c  m1
[root@host-1-17 ~]# gcc lex.yy.c -o example
[root@host-1-17 ~]# ./example input
COMMENT 

COMMENT 
floatdcl id 

COMMENT 
intdcl id 

COMMENT 
id assign inum 

COMMENT 
id assign id plus fnum 

COMMENT 
print id 
[root@host-1-17 ~]# cat example.l
%{
#include <stdio.h>
%}

%option noyywrap

%%


"//".*                                 { printf("COMMENT "); }


[fF]                                   { printf("floatdcl "); }
[iI]                                   { printf("intdcl "); }


[pP]                                   { printf("print "); }


[a-eg-hj-oq-rt-zA-EG-HJ-OQ-RT-Z]       { printf("id "); }


[0-9]+                                 { printf("inum "); }


[0-9]+\.[0-9]+                         { printf("fnum "); }


"="                                    { printf("assign "); }


"\+"                                   { printf("plus "); }


\n                                     { printf("\n"); }


[ \t]+                               { /* Ignorar espacios */ }

%%

int main(int argc, char **argv) {
    FILE *fd;

[root@host-1-17 ~]# cat example.l
%{
#include <stdio.h>
%}

%option noyywrap

%%


"//".*                                 { printf("COMMENT "); }


[fF]                                   { printf("floatdcl "); }
[iI]                                   { printf("intdcl "); }


[pP]                                   { printf("print "); }


[a-eg-hj-oq-rt-zA-EG-HJ-OQ-RT-Z]       { printf("id "); }


[0-9]+                                 { printf("inum "); }


[0-9]+\.[0-9]+                         { printf("fnum "); }


"="                                    { printf("assign "); }


"\+"                                   { printf("plus "); }


\n                                     { printf("\n"); }


[ \t]+                               { /* Ignorar espacios */ }

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
        yylex();
        fclose(fd);
    } else {
        printf("Usage: %s <filename>\n", argv[0]);
    }
    return 0;
}
