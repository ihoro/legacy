#pragma once


#include "err.h"
#include "connection.h"

#define INT64U unsigned long long

extern char def_resp_helo[];
extern bool is_dir(char*);
extern void fix_dir(char*);

extern void Int64ToStr(INT64U, char*);