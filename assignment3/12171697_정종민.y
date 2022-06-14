%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>

int idx;
int type_bit = 0;

char tmp[10], check[10];
int tcnt = 0;

struct Symbol{
	char c[256];
	int t;
} symbol[1005];
int scnt = 0;

int findById(const char* c){
	for(int i = 0; i < scnt; i++){
		if(!strcmp(symbol[i].c, c))return i;
	}
	return -1;
}
%}

%union{
	int t;
	char s[256];
}

%token<s> FLOAT
%token<s> INT
%token<s> ID
%token<s> ES
%token<t> TYPE
%token OTHER

%left '+' '-'
%left '*' '/'
%left UnaryMinus

%type<s> E

%%

lines:
		lines stmt
		|
		lines '\n'
		|
		;

stmt:
		assign ';'
		|
		declare ';'
		;

assign:
		ID ES E{
			idx = findById($1);
			if(idx == -1){
				printf("Error!\n%s is unknown id\n", $1);
				exit(0);
			}

			sprintf(check, "t%d", tcnt - 1);
			if(strcmp(check, $3)){
				sprintf(tmp, "t%d", tcnt++);
				printf("%s = %s\n", tmp, $3);
				strcpy($3, tmp);
			}
			printf("%s = %s\n", $1, $3);

			if(type_bit != (symbol[idx].t + 1))
				printf("//warning: type mismatch\n");
			type_bit = 0;
		}

declare:
		TYPE ID{
			if(findById($2) != -1){
				printf("Error!\n(%s is already declared)\n", $2);
				exit(0);
			}
			strcpy(symbol[scnt].c, $2);
			symbol[scnt++].t = $1;
		}

E:
		INT{
			type_bit |= 1;
			strcpy($$, $1);
		}
		|
		FLOAT{
			type_bit |= 2;
			strcpy($$, $1);
		}
		|
		ID{
			idx = findById($1);
			if(idx == -1){
				printf("Error!\n(%s is unknown id)\n", $1);
				exit(0);
			}
			strcpy($$, $1);
		}
		|
		E '+' E{
			sprintf(tmp, "t%d", tcnt++);
			strcpy($$, tmp);
			printf("%s = %s + %s\n", $$, $1, $3);
		}
		|
		E '-' E{
			sprintf(tmp, "t%d", tcnt++);
			strcpy($$, tmp);
			printf("%s = %s - %s\n", $$, $1, $3);
		}
		|
		E '*' E{
			sprintf(tmp, "t%d", tcnt++);
			strcpy($$, tmp);
			printf("%s = %s * %s\n", $$, $1, $3);
		}
		|
		E '/' E{
			sprintf(tmp, "t%d", tcnt++);
			strcpy($$, tmp);
			printf("%s = %s / %s\n", $$, $1, $3);
		}
		|
		'-' E{
			sprintf(tmp, "t%d", tcnt++);
			strcpy($$, tmp);
			printf("%s = -%s\n", $$, $2);
		}
		;
%%

void main(){
	yyparse();
}

void yyerror(const char* s){
	printf("%s\n", s);
}
