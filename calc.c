#include <stdio.h>

#include "se.h"
#include "parser.h"
#include "lexer.h"

int calcparse (struct se **se, void *scanner);

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

	printf ("'%s' -> %d\n", expression, evaluate (se));

	se_free (se);
	return 0;
}
