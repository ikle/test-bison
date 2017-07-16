%{
/*
 * Sample Calculator Parser
 *
 * Copyright (c) 2017 Alexei A. Smekalkine
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

#include "se.h"

#define yylex    calclex
#define yyparse  calcparse	/* define api.prefix for bison >= 2.6 */

static void yyerror (struct se **o, void *scanner, const char *msg);

%}

%define api.pure

%lex-param   { void *scanner }
%parse-param { struct se **o }
%parse-param { void *scanner }

%code requires {
#define YYSTYPE  struct se *
}

%code provides {
#include "calc-se.h"

int calclex (YYSTYPE *ret, void *scanner);
int calcparse (struct se **o, void *scanner);
}

%token TOKEN_ERROR

%left '+' '-'
%left '*' '/'

%token TOKEN_NUMBER
%destructor { se_free ($$); } TOKEN_NUMBER

%token '(' ')'

%%

input
	: expr { *o = $1; }
	;

expr
	: expr[L] '+' expr[R]		{ $$ = se (SE_ADD, $L, $R); }
	| expr[L] '-' expr[R]		{ $$ = se (SE_SUB, $L, $R); }
	| expr[L] '*' expr[R]		{ $$ = se (SE_MUL, $L, $R); }
	| expr[L] '/' expr[R]		{ $$ = se (SE_DIV, $L, $R); }
	| '(' expr[E] ')'		{ $$ = $E; }
	| TOKEN_NUMBER[N]		{ $$ = $N; }
	;

%%

#include <stdio.h>

static void yyerror (struct se **o, void *scanner, const char *msg)
{
	fprintf (stderr, "E: %s\n", msg);
}
