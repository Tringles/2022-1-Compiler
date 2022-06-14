%{
#include<stdio.h>
#include<stdlib.h>
#include "y.tab.h"
%}

%%

int {
	yylval.t = 0;
	return TYPE;
}
float {
	yylval.t = 1;
	return TYPE;
}

[0-9]+ {
	strcpy(yylval.s, yytext);
	return INT;
}
[0-9]+(\.[0-9]+)?(E[+\-]?[0-9]+)? {
	strcpy(yylval.s, yytext);
	return FLOAT;
}
= {
	strcpy(yylval.s, yytext);
	return ES;
}
[a-zA-Z]([a-zA-Z]|[0-9])* {
	strcpy(yylval.s, yytext);
	return ID;
}


[ \t]+ ;
[-+/*()] return *yytext;
\n return *yytext;
; return *yytext;
. return OTHER;

%%

int yywrap(){
	return 1;
}
