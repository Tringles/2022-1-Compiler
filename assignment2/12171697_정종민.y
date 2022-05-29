%{
#include<stdio.h>
#include<ctype.h>
%}

%define api.value.type {double}
%token NUM
%left '+' '-'
%left '*' '/'
%left '(' ')'
%left UnaryMinus

%%

lines:
		lines stmt
		|
		lines '\n'
		|
		;

stmt:
		expr ';'
		;

expr:
		E{
		printf("%g\n", $$);
		}
		;

E:
		E '+' E{
			$$ = $1 + $3;
		}
		|
		E '-' E{
			$$ = $1 - $3;
		}
		|
		E '*' E{
			$$ = $1 * $3;
		}
		|
		E '/' E{
			$$ = $1 / $3;
		}
		|
		'(' E ')'{
			$$ = $2;
		}
		|
		'-' E{
			$$ = -$2;
		}
		|
		NUM{
			$$ = $1;
		}
		;

%%

void main(){
	yyparse();
}

void yyerror(){
	printf("Error\n");
}
