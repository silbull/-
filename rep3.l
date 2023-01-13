%{
    #include "y.tab.h"
    #include "VSM.h"
%}

ws     [ \t\n]
symbol [();]
digit  [0-9]
other  .    


%%
{ws}+
{symbol}                { return(yytext[0]); }
"+"                     { yylval.ival = ADD; return ADDOP;}
"-"                     { yylval.ival = SUB; return ADDOP;}
"*"                     { yylval.ival = MUL; return MULOP;}
"/"                     { yylval.ival = DIV; return MULOP;}
"%"                     { yylval.ival = MOD; return MULOP;}
"^"                     { yylval.ival = POW; return MULOP;} 
"log"                   { yylval.ival = LOG; return FUNCOP;}
"fabs"                  { yylval.ival = FABS; return FUNCOP;}
"sqrt"                  { yylval.ival = SQRT; return FUNCOP;}
"exp"                  { yylval.ival = EXP; return FUNCOP; }
"sin"                   { yylval.ival = SIN; return FUNCOP; } 
"cos"                   { yylval.ival = COS; return FUNCOP;}
"tan"                { yylval.ival = TAN; return FUNCOP; }
"arcsin"             { yylval.ival = ARCSIN; return FUNCOP;}
"arccos"             { yylval.ival = ARCCOS; return FUNCOP;}
"arctan"             { yylval.ival = ARCTAN; return FUNCOP;}
{digit}+                { sscanf(yytext, "%d", &yylval.ival); return(INTC); }
{digit}+"."{digit}*     { sscanf(yytext, "%lf", &yylval.rval); return(REALC); }
{other}                 { fprintf(stderr, "Illegal char '%c' ignored\n", yytext[0]); }

%%