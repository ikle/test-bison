%{
/*
 * Sample Calculator Lexical Analyzer
 *
 * Copyright (c) 2017 Alexei A. Smekalkine
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

#include <string.h>

#include "calc-parser.h"

%}

%option reentrant prefix="calc"
%option yylineno never-interactive
%option nodefault noyywrap

%option nounistd
%option bison-bridge

SIMPLE		[+\-*/()]
NUMBER		[0-9]+
BLANK		[ \r\n\t]*

%%

{BLANK}		{ /* skip blanks */ }
{SIMPLE}	{ return yytext[0]; }

{NUMBER}	{ *yylval = se (SE_NUMBER, strdup (yytext));
		  return TOKEN_NUMBER; }

.		{ return TOKEN_ERROR;    }

%%
