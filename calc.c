/*
 * Sample Calculator
 *
 * Copyright (c) 2017 Alexei A. Smekalkine
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

#include <stdio.h>

#include "calc-parser.h"
#include "calc-lexer.h"

static struct se *get_ast (const char *expression)
{
	struct se *se;
	yyscan_t scanner;
	YY_BUFFER_STATE state;

	if (calclex_init (&scanner) != 0) {
		perror ("E: cannot initialize lexer\n");
		return NULL;
	}

	state = calc_scan_string (expression, scanner);

	if (calcparse (&se, scanner) != 0)
		return NULL;

	calc_delete_buffer (state, scanner);
	calclex_destroy (scanner);

	return se;
}

static const char *se_name (const struct se *o)
{
	switch (o->type) {
	case SE_NUMBER:	return "num";
	case SE_ADD:	return "+";
	case SE_SUB:	return "-";
	case SE_MUL:	return "*";
	case SE_DIV:	return "/";
	}

	return "unknown";
}

static void show (const char *prefix, const struct se *o)
{
	int i;

	printf ("%s(%s", prefix, se_name (o));

	for (i = 0; i < se_count (o->type); ++i)
		if (se_is_terminal (o->type))
			printf (" %s", o->item[i]);
		else {
			putchar (' ');
			show ("", o->item[i]);
		}

	putchar (')');

	if (prefix[0] != '\0')
		putchar ('\n');
}

static int evaluate (struct se *o)
{
	switch (o->type) {
	case SE_NUMBER:
		return atoi (o->item[0]);
	case SE_ADD:
		return evaluate (o->item[0]) + evaluate (o->item[1]);
	case SE_SUB:
		return evaluate (o->item[0]) - evaluate (o->item[1]);
	case SE_MUL:
		return evaluate (o->item[0]) * evaluate (o->item[1]);
	case SE_DIV:
		return evaluate (o->item[0]) / evaluate (o->item[1]);
	}

	/* OOPS: throw error here */
	return 0;
}

int main (void)
{
	struct se *se = NULL;
	const char *expression = " ((3+4-5) * 7 - (\t4 * 5) +\n(1 + 17)*13)/3";

	if ((se = get_ast (expression)) == NULL)
		return 1;

	show ("se = ", se);
	printf ("'%s' -> %d\n", expression, evaluate (se));

	se_free (se);
	return 0;
}
