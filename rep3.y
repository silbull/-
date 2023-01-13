/*簡単な電卓*/

%{
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "VSM.h"
#define M_SIZE 16
extern FILE *yyin;

int yylex(void);
void yyerror(const char *s);

double Memory[M_SIZE];
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

int        StartP=0, SymPrintSW=0;                  /* オプション用の */
static int ExecSW=1, ObjOutSW=0, TraceSW=0, StatSW=0;   /* フラグ変数 */

static int  ErrorC=0;                               /* エラーカウンタ */
static char SourceFile[20];


static void SetUpOpt(int, char *[]); /* ポインタ */

FILE *fp;
int main(int argc, char* argv[]){


  ObjOutSW=1;
  SetUpOpt(argc, argv);                             /* オプションの処理 */
  if (SourceFile[0] != NULL)                        /* 入力ファイルを */
    if ((yyin=fopen(SourceFile, "r")) == NULL) {         /* オープン */
      fprintf(stderr, "Source file cannot be opened.");
      exit(-1); }                                   /* コンパイル中止 */
  yyparse();                                        /* コンパイル */
  if (ObjOutSW) {
        fp = fopen("test.to", "w");
        if(fp == NULL){
                printf("cannot open\n");
                exit(-1);
        }
        for (int i = 0; i<=PC()-1; i++){
    FprintIns(i, fp);
        }
        fclose(fp);
}
        //DumpIseg(0, PC()-1);              /* 目的コード表示 */
}

static void SetUpOpt(int argc, char *argv[])
{
  char *s;

  if (--argc>0 && (*++argv)[0]=='-') {             /* オプション指定 ? */
    for (s = *argv+1; *s != '\0'; s++)             /* オプションの走査 */
      switch(tolower(*s)) {                        /* 小文字でチェック */
        case 'c': StatSW = 1;     break;           /* 実行データの表示 */
        case 'd': DebugSW = 1;    break;           /* デバッグモード */
        case 'n': ExecSW = 0;     break;           /* コンパイルだけ */
        case 'o': ObjOutSW = 1;   break;           /* 目的コードの表示 */
        case 's': SymPrintSW = 1; break;           /* 記号表の表示 */
        case 't': TraceSW = 1;    break; }         /* トレースモード */
    argc--; argv++; }
  if (argc > 0)                                    /* 入力ファイル名を */
    strcpy(SourceFile, *argv);                     /* コピー */
}

        


