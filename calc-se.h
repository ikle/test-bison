/*
 * Sample Calculator S-Expressions
 *
 * Copyright (c) 2017 Alexei A. Smekalkine
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

#ifndef CALC_SE_H
#define CALC_SE_H

#include "se.h"

enum se_type
{
	SE_NUMBER	= SE (0, 1, 1),
	SE_ADD		= SE (0, 0, 2),
	SE_SUB		= SE (1, 0, 2),
	SE_MUL		= SE (2, 0, 2),
	SE_DIV		= SE (3, 0, 2),
};

#endif  /* CALC_SE_H */
