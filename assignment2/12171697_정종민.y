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

expr:
		E{
		printf("%f\n", $$);
		return 0;
		};

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
