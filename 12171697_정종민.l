%{
#include <stdio.h>

#define NUMBER 256
#define OPERATOR 257
#define EOL 258
#define WHITESPACE 259
#define ERROR 260
#define MAX_SIZE 105
%}

num [0-9]+
EOL \n
WHITESPACE [\t ]+
OPERATOR [+-]
ERROR [^0-9\n\t +-]

%%
{num} { return NUMBER; }
{EOL} { return EOL; }
{WHITESPACE} { return WHITESPACE; }
{OPERATOR} { return OPERATOR; }
{ERROR} {return ERROR;}

%%

int
main () {
    char s = '\0';
    int cur = 0;
    int token;
    int isOperator = 1;
    char ans[MAX_SIZE] = {'\0', };

    while((token = yylex()) != EOL){
        if(token == NUMBER){
            if(!isOperator){
                printf("[ERROR]: Representation does not satisfy infix format.\n");
                return 0;
            }
            isOperator = 0;
            for(int i = 0; i < yyleng; i++){
                ans[cur++] = yytext[i];
            }
            ans[cur++] = ' ';
        }
        else if(token == OPERATOR){
            if(isOperator){
                printf("[ERROR]: Representation does not satisfy infix format.\n");
                return 0;
            }
            isOperator = 1;
            if(s == '\0'){
                s = yytext[0];
            }
            else{
                ans[cur++] = s;
                ans[cur++] = ' ';
                s = yytext[0];
            }
        }
        else if(token == ERROR){
            printf("[ERROR]: [%c] does not following regular expression.\n", yytext[0]);
            return 0;
        }
    }
    for(int i = 0; i < cur; i++){
        printf("%c", ans[i]);
    }
    if(s != '\0'){
        printf("%c", s);
    }
    printf("\n");
}
