#include "stdafx.h"
#include "bnu_ctrl.h"


char hexsym[] = "0123456789ABCDEF";
char floatsym[] = "+-.0123456789";

void FixHEXStr(char *str)			// str[] must be in UPPERcase!
{
	for (; *str; str++)
		for (int i=0; i<sizeof(hexsym); i++)
			if (*str == hexsym[i])
				break;
			else
				if (i == sizeof(hexsym) - 1)
					*str = '0';
}

int HEXStrToInt(char *str)
{
	int x = 0;

	for (; *str; str++)
	{
		x <<= 4;
		if (*str - 0x30 < 10)
			x |= *str - 0x30;
		else
			x |= *str - 0x37;
	}

	return x;
}

void IntToHEXStr(int x, char *str)
{
	for (int i=0; i<8; i++)
		*str++ = hexsym[ (x & (0xF0000000 >> (i*4))) >> ((7-i)*4) ];
	*str = 0;
}

void FixFloatStr(char *str)
{
	bool wasSign = false;
	bool wasPoint = false;
	char *s = str;

	for (bool first = true; *s; s++, first = false)
	{
		if (*s == ',')
			*s = '.';

		for (int i=0; i<sizeof(floatsym); i++)
			if (*s == floatsym[i])
			{
				if (i <= 1)
					if (!wasSign && first)
						wasSign = true;
					else
					{
						strcpy(s, s+1);
						s--;
					}

				if (i == 2)
					if (!wasPoint)
						wasPoint = true;
					else
					{
						strcpy(s, s+1);
						s--;
					}
				break;
			}
			else
				if (i == sizeof(floatsym) - 1)
				{
					strcpy(s, s+1);
					s--;
					break;
				}
	}
}

double CoordStrToRadians(char *str, bool lat_or_long)
{
	char *s;			// search string
	char *f;			// found string	
	int len;
	char *se;			// last byte in str
	bool neg;			// if it's S or W
	int deg;			// DDD
	double min = 0;		// MM.mm

	// get string length
	len = (int)strlen(str);
	if (!len)
		return 0;

	// get neg
	switch ( *(str + len - 1) )
	{
	case 'S':
	case 's':
	case 'W':
	case 'w': neg = true; break;
	default:  neg = false;
	}
	se = str + len - 1;
	*se = 0;

	// looking for degrees
	s = ".";
	f = strstr(str, s);
	if (f)
		*f = 0;
	deg = atoi(str);

	// looking for minutes
	if (f)
	{
		f++;
		if (f < se)
		{
			FixFloatStr(f);
			min = atof(f);
		}
		else
			min = 0;
	}

	// convert to radians
	min = (deg + min / 60) * (PI / 180);

	// check maximum (90 or 180)
	if (lat_or_long)
	{
		if (min > PI/2)
			min = PI/2;
	}
	else
		if (min > PI)
			min = PI;

	return neg ? -min : min;
}

void RadiansToCoordStr(double rad, bool lat_or_long, char *str)
{
	// get neg
	bool neg = false;
	if (rad < 0)
	{
		neg = true;
		rad = -rad;
	}

	// get degrees and convert into 'DD.' or 'DDD.'
	rad = rad / (PI / 180);
	int deg = (int)floor(rad);
	wsprintf(str, lat_or_long ? "%.2d" : "%.3d", deg);
	str += lat_or_long ? 2 : 3;
	*str++ = '.';

	// get minutes
	rad -= deg;
	rad *= 60;

	// convert minutes into 'MM.mmm'
	sprintf(str, "%06.3f", rad);

	// set N/S/E/W
	str[6] = 
	lat_or_long
	?
		neg
		?
			'S'
		:
			'N'
	:
		neg
		?
			'W'
		:
			'E'
	;

	// end of string
	str[7] = 0;
}

void TimeStrToTime(char *str, char *sep, int &day, int &month, int &year)
{
	int len = (int)strlen(str);
	char *se = str + len;

	// get day
	char *fs = strstr(str, sep);
	if (!fs)
		fs = str + len;
	*fs = 0;
	day = atoi(str);

	// get month
	char *fs2 = strstr(++fs, sep);
	if (!fs2)
		fs2 = str + len;
	if (fs2 > se)
	{
		month = 0;
		year = 0;
		return;
	}
	*fs2 = 0;
	month = atoi(fs);

	// get year
	fs = strstr(++fs2, sep);
	if (!fs)
		fs = str + len;
	if (fs > se)
	{
		year = 0;
		return;
	}
	*fs = 0;
	year = atoi(fs2);
}

void Int64ToStr(INT64U x, char *s)
{
	bool first = true;
	INT64U mod = 10000000000000000000;
	char figure;

	for (int i=0; i<20; i++)
	{
		mod /= i ? 10 : 1;
		figure = (char)(x / mod);
		x -= figure * mod;
		if ( !first || (first && figure) || (first && i == 19))
		{
			first = false;
			*s++ = figure + 0x30;
		}
	}

	*s = 0;
}