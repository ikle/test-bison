%{

#include <string.h>

#include "se.h"
#include "parser.h"

%}

%option reentrant prefix="calc"
%option yylineno never-interactive
%option nodefault noyywrap

%option nounistd
%option bison-bridge

LPAREN		"("
RPAREN		")"
PLUS		"+"
MINUS		"-"
MULTIPLY	"*"
DIVIDE		"/"

NUMBER		[0-9]+
BLANK		[ \r\n\t]*

%%

{BLANK}		{ /* skip blanks */ }
{NUMBER}	{ yylval->se = se (SE_NUMBER, strdup (yytext));
		  return TOKEN_NUMBER; }

{PLUS}		{ return TOKEN_PLUS;     }
{MINUS}		{ return TOKEN_MINUS;    }
{MULTIPLY}	{ return TOKEN_MULTIPLY; }
{DIVIDE}	{ return TOKEN_DIVIDE; }

{LPAREN}	{ return TOKEN_LPAREN;   }
{RPAREN}	{ return TOKEN_RPAREN;   }
.		{ return TOKEN_ERROR;    }

%%
