#ifndef SE_H
#define SE_H

/* se_type encodes number of arguments in lower nibble and flags in next one */
#define SE(i, f, n)  ((i) << 8 | (f) << 4 | (n))

enum se_type
{
	SE_NUMBER	= SE (0, 1, 1),
	SE_ADD		= SE (0, 0, 2),
	SE_SUB		= SE (1, 0, 2),
	SE_MUL		= SE (2, 0, 2),
	SE_DIV		= SE (3, 0, 2),
};

static int se_is_terminal (enum se_type type)
{
	return (type & 0x10) != 0;
}

static int se_count (enum se_type type)
{
	return type & 0xf;
}

struct se
{
	enum se_type type;
	void *item[];
};

#include <stdarg.h>

struct se *se (enum se_type type, ...);
void se_free (struct se *b);

#endif  /* SE_H */
