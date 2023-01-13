
%{
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "VSM.h"

extern FILE *yyin;
extern int Pctr;

int yylex(void);
void yyerror(const char *s);

%}

%union{
    int     ival;
    double  rval;
}
%start expr_list /*開始記号を定義*/
%token <ival> INTC
%token <rval> REALC
%type <ival> expr

/* 下に行くほど優先順位が高い */
%left   <ival> ADDOP                /* ADDOP = +, - */
%left   <ival> MULOP                /* MULOP = *, /, ^ */
%left  <ival> FUNCOP               /* FUNCOP = log, sqrt, sin系, arcsin系  */
%right  <ival> UMINUS               

%%
expr_list: line                   {Pout(HALT);}
        ;
line    : 
        | line  expr     ';'     { Pout(OUTPUT); }     
        | line  error    ';'     { yyerrok; } /* yyerrokは標準マクロ、構文エラーがあったら次の改行まで読み飛ばす */
        ;


expr    : expr  ADDOP expr            { Pout($2); }              
        | expr  MULOP expr            { Pout($2); }     
        | ADDOP expr %prec UMINUS   { if ($1 == SUB) Pout(CSIGN); } /* precでこの規則にUMINUSの優先度、つまり最も高い優先度を与える */           
        | '(' expr ')'              
        | FUNCOP  '(' expr ')'         { Pout($1);  } 
        | INTC                      {  Cout(PUSHI,(double)$1); }   
        | REALC                     { Cout(PUSHI, $1); }   
        ;


%%
FILE *fp;
int main(int argc, char* argv[]){


int  ObjOutSW=1;
  
    if ((yyin=fopen(argv[1], "r")) == NULL) {         /* オープン */
      fprintf(stderr, "Source file cannot be opened.");
      exit(-1); }                                   /* コンパイル中止 */
  yyparse();                                        /* コンパイル (.tcファイルの内容を解析して、Isegに書き込んでる)*/
  if (ObjOutSW) {
        fp = fopen("source.to", "w");
        if(fp == NULL){
                printf("cannot open\n");
                exit(-1);
        }
        for (int i = 0; i<=Pctr-1; i++){
    FprintIns(i, fp);
        }
        fclose(fp);
}
}





