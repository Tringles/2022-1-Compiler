%{
#include<stdio.h>
#include "y.tab.h"
extern double yylval;
%}

%%

[0-9]+(\.[0-9]+)?(E[+\-]?[0-9]+)? {
		yylval=atof(yytext);
		return NUM;
	}
[ \t]+ ;
[\n] return 0;
. return yytext[0];

%%

int yywrap(){
	return 1;
}
