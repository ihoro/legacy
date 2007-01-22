// $Id$

#pragma once


// int64 types
#define INT64S	long long
#define INT64U	unsigned long long


// all invalid symbols will be '0'
void FixHEXStr(char *str);

// all invalid symblos will be removed
void FixFloatStr(char *str);

// convert HEX-string (8 symbols) to 32-bit value
int HEXStrToInt(char *str);

// convert 32-bit value to HEX-string (8 symbols)
void IntToHEXStr(int x, char *str);

// convert to radians from coordinates of that format: DDD.MM.mmm[N|S|E|W] Note: it will corrupts input string
double CoordStrToRadians(char *str, bool lat_or_long);

// convert from radians to coordinates of that format: DDD.MM.mmm[N|S|E|W]
void RadiansToCoordStr(double rad, bool lat_or_long, char *str);

// convert to time/date from string of that format: x<sep>y<sep>z
void TimeStrToTime(char *str, char *sep, int &day, int &month, int &year);

// convert 64-bit integer to string
void Int64ToStr(INT64U x, char *s);