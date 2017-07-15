%{

#include <stdio.h>
#include "se.h"

#define yylex    calclex
#define yyparse  calcparse	/* define api.prefix for bison >= 2.6 */

int yyparse (struct se **o, void *scanner);

static void yyerror (struct se **o, void *scanner, const char *msg)
{
	fprintf (stderr, "E: %s\n", msg);
}

%}

%define api.pure

%lex-param   { void *scanner }
%parse-param { struct se **o }
%parse-param { void *scanner }

%code requires {
#define YYSTYPE  struct se *
}

%code provides {
int calclex (YYSTYPE *ret, void *scanner);
}

%token TOKEN_ERROR

%left TOKEN_PLUS TOKEN_MINUS
%left TOKEN_MULTIPLY TOKEN_DIVIDE

%token TOKEN_NUMBER
%token TOKEN_LPAREN TOKEN_RPAREN

%%

input
	: expr { *o = $1; }
	;

expr
	: expr[L] TOKEN_PLUS     expr[R]	{ $$ = se (SE_ADD, $L, $R); }
	| expr[L] TOKEN_MINUS    expr[R]	{ $$ = se (SE_SUB, $L, $R); }
	| expr[L] TOKEN_MULTIPLY expr[R]	{ $$ = se (SE_MUL, $L, $R); }
	| expr[L] TOKEN_DIVIDE   expr[R]	{ $$ = se (SE_DIV, $L, $R); }
	| TOKEN_LPAREN expr[E] TOKEN_RPAREN	{ $$ = $E; }
	| TOKEN_NUMBER[N]			{ $$ = $N; }
	;

%%
