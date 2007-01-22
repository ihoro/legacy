// $Id$

#include "stdafx.h"
#include "bnu_ctrl.h"


// FP80<->FP64 converters. Note: it's system dependent code by 'fp80.asm'! If you want another implementation you should link your code.
extern "C" void fp80to64(void *, void *);
extern "C" void fp64to80(void *, void *);


// engine implementation

CBCP2Engine::CBCP2Engine(int pktBufSize)
{
	// reset state
	ResetProcess();
	ResetHandlers();

	// prepare buffer
	pkt = (char*)malloc(pktBufSize);
	bufSize = pktBufSize;

	// set default time offset
	timeOffset.day = 22;
	timeOffset.month = 8;
	timeOffset.year = 1999;


	// control packets formats
	//////////////////////////

	Format[0x01] = "CCCCCC";
	Format[0x0B] = "CLC";
	Format[0x0D] = "CC";				// for request only. packet has several different formats!
	Format[0x0E] = "C";
	Format[0x11] = "C";
	Format[0x12] = "CCC";
	Format[0x13] = "CC";
	Format[0x16] = "CL";
	Format[0x17] = "CCCcCf";			// packet has two different formats
	Format[0x19] = "CC";
	Format[0x1B] = "C";
	Format[0x1E] = "C";
	Format[0x20] = "CC";
	Format[0x21] = "CC";
	Format[0x22] = "CC";
	Format[0x23] = "Ccc";
	Format[0x24] = "CC";
	Format[0x25] = "C";
	Format[0x26] = "C";
	Format[0x27] = "CC";
	Format[0x2A] = "CC";
	Format[0x2B] = "CC";
	Format[0x32] = "CdddfDsddd";
	Format[0x39] = "CC";
	Format[0xA2] = "CCfffffffffCCCCCC";
	Format[0xA4] = "C";
	Format[0xA6] = "C";
	Format[0xA8] = "Cfff";
	Format[0xAA] = "CC";
	Format[0xAC] = "Cfff";
	Format[0xAE] = "C";
	Format[0xB1] = "SCCCfdddCC";
	Format[0xB2] = "S";
	Format[0xB5] = "C";
	Format[0xB6] = "Cffffffffffffffffff";
	Format[0xB8] = "SC";
	Format[0xD4] = "CC";
	Format[0xD6] = "C";
	Format[0xD7] = "CC";				// for request only. packet has several different formats!
	Format[0xFC] = "";
	Format[0xFD] = "C";

	// D7/E7 packets data formats
	FormatD7E7[0] = "f";
	FormatD7E7[1] = "C";
	FormatD7E7[2] = "S";
	FormatD7E7[3] = "CC";
	FormatD7E7[4] = "CCL";
	FormatD7E7[5] = "d";
	FormatD7E7[6] = "S";
	FormatD7E7[7] = "S";
	FormatD7E7[8] = "CCC";
	// --


	// response packets formats			// it used to be used some time ago :) uncomment if you need 
	///////////////////////////
	/*
	Format[0x40] = "CC";				// only header
	Format[0x41] = "CffL";
	Format[0x42] = "CcCCC";				// only for one channel !
	Format[0x43] = "CCL";
	Format[0x46] = "CLCCScc";
	//Format[0x47] = "CCC";				// only for one satellite ! this packet don't use ExpandPacket()
	Format[0x49] = "CC";				// only header
	Format[0x4A] = "CffffffffC";
	Format[0x4B] = "CddLSsSSsCSdC";
	Format[0x4C] = "CC";
	Format[0x50] = "CLC";
	Format[0x51] = "CCCCCSf";
	Format[0x52] = "CCcCSC";			// only for one satellite !
	Format[0x53] = "CDsfC";
	Format[0x54] = "";
	Format[0x56] = "CL";
	Format[0x60] = "CCCff";
	//Format[0x70]						// this packet don't use ExpandPacket()
	Format[0x74] = "CDDDDDC";
	Format[0x87] = "CcCCSdfs";			// only for one channel !
	Format[0x88] = "CdddfDsdddfC";
	Format[0x89] = "CdddfDsddd";
	Format[0xA3] = "CCfffffffffCCCCCC";
	Format[0xA5] = "dsffffffC";
	Format[0xA7] = "C";
	Format[0xA9] = "Cfff";
	Format[0xAB] = "CdddfdsdddC";
	Format[0xAD] = "Cfff";
	Format[0xAF] = "Cfffffffffffffffffffff";
	Format[0xB7] = "C";
	Format[0xC1] = "fLL";				// only for one interval !
	Format[0xC2] = "S";
	Format[0xE4] = "CcCCdf";			// only for one channel !
	Format[0xE6] = "C";
	//Format[0xE7]						// packet has several different formats!
	Format[0xFF] = "Sllls";
	*/

	// 49/40 packets data format (without rnpi&system and sat_num - only info)
	Format4940[0] = "ffdfdfddfdfdfdddfdfffSS";		// eph-gps
	Format4940[1] = "cddddddddddffS";				// eph-gln
	Format4940[2] = "CCfffdffffffDs";				// alm-gps
	Format4940[3] = "CCffffffdfs";					// alm-gln
}

CBCP2Engine::~CBCP2Engine()
{
	free(pkt);
}

void CBCP2Engine::ResetProcess()
{
	x = 0;
	pktOffset = 0;
	pktFound = false;
	rx_bytes = 0;
	rx_packets = 0;
}

void CBCP2Engine::ResetHandlers()
{
	for (int i=0; i<256; i++)
		Handler[i] = 0;
	CounterHandler = 0;
}

void CBCP2Engine::Process(char *buffer, int count)
{
	// bytes counter
	rx_bytes += count;
	if (CounterHandler)
		CounterHandler(0, 0);

	// read data
	for (int i=0; i < count; i++)
	{
		// push next byte
		x = (x << 8) | (buffer[i] & 0x000000FF);

		// check packet's begin
		if ( !pktFound &&
			 (x & 0x0000FF00) == 0x00001000 &&
			 (x & 0x00FF0000) != 0x00100000 &&
			 (x & 0x000000FF) != 0x00000003	)
			pktFound = true;

		// extract packet's data
		if (pktFound)

			// if no overflow
			if (pktOffset < bufSize)	
				if ( !((x & 0x000000FF) == 0x00000010  &&  (x & 0x0000FF00) == 0x00001000) )
					pkt[pktOffset++] = buffer[i];
				else
					x = 0x00000000;		// preparation for next 0x1010

			// it's fucking overflow! so, we throw this current packet away...
			else
			{
				pktFound = false;
				pktOffset = 0;
				TRACE("Fucking overflow by CBCP2Engine::pktOffset index.\n");
			}

		// check packet's end
		if ( pktFound &&
			 (x & 0x0000FF00) == 0x00001000 &&
			 (x & 0x00FF0000) != 0x00100000 &&
			 (x & 0x000000FF) == 0x00000003 )
		{
			pktFound = false;

			// packets counter
			rx_packets++;
			if (CounterHandler)
				CounterHandler(0, 0);

			// call user defined packet handler
			if ( Handler[ (INT8U)*pkt ] )
				Handler [ (INT8U)*pkt ] ((INT8U*)(pkt + 1), pktOffset - 3);
            
			pktOffset = 0;
		}
	}
}

int CBCP2Engine::MakePacket(char *pData, unsigned char id, ...)
{
 	char *fmt;
	char pTemp[10];
	va_list va;
	char *pDataBegin = pData;
	BCP_VALUE p;

	// fill header
	*pData++ = 0x10;
	*pData++ = id;

	// choose format
	fmt = Format[id];
	
	// fill body
	va_start(va, id);
	for (; *fmt; fmt++)
	{
		int len;

		switch (*fmt)
		{
			case 'c':
			case 'C': len = 1; p.c = va_arg(va, char); break;
			case 's':
			case 'S': len = 2; p.s = va_arg(va, short); break;
			case 'l':
			case 'L': 
			case 'f': len = 4; p.l = va_arg(va, int); break;
			case 'd': len = 8; p.d = va_arg(va, double); break;
			case 'D': len = 10; p.d = va_arg(va, double); break;
			default: len = 0;
		}

		if (len)
		{
			if (len == 10)
				fp64to80(&p, pTemp);
			else
				memcpy(pTemp, &p, len);

			for (int i=0; i<len; i++)
			{	
				*pData++ = pTemp[i];

				if (pTemp[i] == 0x10)
					*pData++ = 0x10;
			}
		}
	}
	va_end(va);

	// fill footer
	*pData++ = 0x10;
	*pData++ = 0x03;

	return (int)(pData - pDataBegin);		// size of full packet
}

int CBCP2Engine::FixPacketData(char *src, int src_size, char *dst)
{
	int j = 0;

	for (int i=0; i<src_size; i++)
	{
		// get byte
		dst[j++] = src[i];

		// check for 0x10
		if ( src[i] == 0x10 )
			dst[j++] = 0x10;
	}

	return j;			// size of dst[]
}

int CBCP2Engine::ExpandPacket(char *pData, INT8U id, BCP_VALUE p[])
{
	char *fmt;
	int len;

	// choose format
	fmt = Format[id];
				
	// get data
	for (int i=0; *fmt; fmt++, i++)
	{
		switch (*fmt)
		{
			case 'c':
			case 'C': len = 1; break;
			case 's':
			case 'S': len = 2; break;
			case 'l':
			case 'L':
			case 'f': len = 4; break;
			case 'd': len = 8; break;
			case 'D': len = 10; break;
			default: len = 0;
		}

		if (len)
		{
			if (len == 10)   
				fp80to64(pData, &p[i]);
			else
				memcpy(&p[i], pData, len);

			pData += len;
		}
	}

	return 0;
}

double CBCP2Engine::to64(void *fp80)
{
	double d;
	fp80to64(fp80, &d);

	return d;
}

void CBCP2Engine::SetTimeOffset(char nowDay, char nowMonth, short nowYear)
{
	BCP_TIME c = {nowDay, nowMonth, nowYear};

	// calc time offset
	int days = PackTime(c);
	days -= (days / 7 % 1024) * 7 + days % 7;
	UnpackTime(days, c);

	// set new time offset
	timeOffset.day = c.day;
	timeOffset.month = c.month;
	timeOffset.year = c.year;
}

int CBCP2Engine::PackTime(BCP_TIME t)
{
	char mSize[12] = {31,28,31,30,31,30,31,31,30,31,30,31};
	BCP_TIME c = {22,8,1999};
	int d;

	// set first offset
	if (t.year == c.year)
	{
		d = -(c.day - 1);
		c.day = 1;
	}
	else
	{
		d = 132;
		c.day = 1; c.month = 1; c.year = 2000;
	}

	// move by year
	while (c.year < t.year)
		d += (c.year++ % 4) ? 365 : 366;
	
	// check bissextile
	if (c.year % 4 == 0)
		mSize[1]++;

	// move by month
	while (c.month < t.month)
		d += mSize[c.month++ - 1];

	// move by day
	d += t.day - 1;

	return d;
}

void CBCP2Engine::UnpackTime(int d, BCP_TIME &c)
{
	char mSize[12] = {31,28,31,30,31,30,31,31,30,31,30,31};
	c.day = 22;
	c.month = 8;
	c.year = 1999;

	// set first offset
	if (d < 132)
	{
		d += c.day - 1;
		c.day = 1;
	}
	else
	{
		d -= 132;
		c.day = 1; c.month = 1; c.year = 2000;
	}

	// move by year
	while (d / ((c.year % 4) ? 365 : 366)  >=  1)
		d -= (c.year++ % 4) ? 365 : 366;
	
	// check bissextile
	if (c.year % 4 == 0)
		mSize[1]++;

	// move by month
	while (d / mSize[c.month - 1]  >=  1)
		d -= mSize[c.month++ - 1];

	// move by day
	c.day += d;
}

void CBCP2Engine::DecodeBCPTime(INT16S week, FP80 time, BCP_TIME &t)
{
	char mSize[12] = {31,28,31,30,31,30,31,31,30,31,30,31};
	int ms = (int)time;

	// move by week
	UnpackTime(PackTime(timeOffset) + week*7, t);

	t.hour = 0;
	t.minute = 0;
	t.second = 0;
	t.millisecond = 0;

	if (t.year % 4 == 0)
		mSize[1]++;

	// move by day
	while (ms/1000/60/60/24 >= 1)
	{
		t.day++;
		ms -= 1000*60*60*24;

		if (t.day > mSize[t.month-1])
		{
			t.day = 1;
			t.month++;

			if (t.month > 12)
			{
				t.month = 1;
				t.year++;
			}
		}
	}

	// move by hour
	t.hour += ms/1000/60/60;
	ms -= t.hour * 1000*60*60;

	// move by minute
	t.minute += ms/1000/60;
	ms -= t.minute * 1000*60;

	// move by second
	t.second += ms/1000;
	ms -= t.second * 1000;

	// move by millisecond
	t.millisecond = ms;
}

void CBCP2Engine::EncodeBCPTime(BCP_TIME t, INT16S &week, FP80 &time)
{	
	// get week
	int days = PackTime(t) - PackTime(timeOffset);
	if (days < 0)
	{
		week = 0;
		time = 0;
		return;
	}
	week = (short)floor( (double)(days / 7) );

	// get time
	time = 0;

	// move by days
	days = days % 7;
	while (days-- > 0)
		time += 24*60*60*1000;

	// move by hour
	time += t.hour*60*60*1000
	// move by minute
		+ t.minute*60*1000
	// move by second
		+ t.second*1000
	// move by millisecond
		+ t.millisecond;
}