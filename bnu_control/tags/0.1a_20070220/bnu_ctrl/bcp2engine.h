// $Id$

#pragma once


// packet
#define PACKET_MAX_SIZE 1024

// response time
#define RESPONSE_PERIOD_IN_SECONDS					1			// it's main switch - use it if you need
#define DEVICES_CALCULATION_TIME_IN_MILLISECONDS	100
#define RESPONSE_PERIOD_IN_INTERVALS				RESPONSE_PERIOD_IN_SECONDS * 1000 / DEVICES_CALCULATION_TIME_IN_MILLISECONDS

// BCP data types
#define INT8U	unsigned char
#define INT8S	signed char
#define INT16U	unsigned short
#define INT16S	signed short
#define INT32U	unsigned int
#define INT32S	signed int
#define FP32	float
#define FP64	double
#define FP80	double

#pragma pack(1)

// BCP time
struct BCP_TIME
{
	char	day;			// 1..31
	char	month;			// 1..12
	short	year;			// ..., 1999, 2000, ...
	char	hour;			// 0..23
	char	minute;			// 0..59
	char	second;			// 0..59
	short	millisecond;	// 0..999
};

// info about channel (87h)
struct CHANNEL_INFO
{
	INT8U	system;
	INT8S	num;
	INT8U	s2n_ratio;		// signal-to-noise ratio
	INT8U	status;
	INT16U	state;
	FP64	pseudorange;
	FP32	dopplers_integral;
	INT16S	pseudorange_flag;
};

// info about channel (42h)
struct CHANNEL_INFO_42
{
	INT8U	system;
	INT8S	num;
	INT8U	s2n_ratio;		// signal-to-noise ratio
	INT8U	status;
	INT8U	pseudorange_flag;
};

// info about channel measurement (E4h)
struct CHANNEL_MEASUREMENT
{
	INT8U	num_sys;
	INT8S	liter;
	INT8U	s2n_ratio;
	INT8U	state;
	FP64	pseudorange;
	FP32	increment;
};

// info about satellite (52h)
struct SATELLITE_INFO
{
	INT8U	system;
	INT8U	num;
	INT8S	letter;
	INT8U	angle;
	INT16U	azimuth;
	INT8U	s2n_ratio;
};

// info about enabled/disabled satellite (47h)
struct SATELLITE_ENABLED
{
	INT8U	system;
	INT8U	num;
	INT8U	enabled;
};

// ephemerid/almanac
#define SIZEOF_EPHEMERID_GPS	128
#define SIZEOF_EPHEMERID_GLN	91
#define SIZEOF_ALMANAC_GPS		58
#define SIZEOF_ALMANAC_GLN		40

// BCP data value
union BCP_VALUE
{
	INT8U				C;
	INT8S				c;
	INT16U				S;
	INT16S				s;
	INT32U				L;
	INT32S				l;
	FP32				f;
	FP64				d;
	FP80				D;
};

#pragma pack()

// received packet handling function type
typedef void (*BCP_HANDLER) (INT8U*, INT32U);


//////////////////////////
// engine of BCP2 protocol
//////////////////////////

class CBCP2Engine
{
public:

	CBCP2Engine(int pktBufSize = PACKET_MAX_SIZE * 10);		// more space - less problems ;)
	~CBCP2Engine();

	// reset all necessary parameters for begining new Process() from scratch
	void ResetProcess();

	// reset all handlers pointers to zero
	void ResetHandlers();

	// set new time offset instead of 22.08.1999 (default)
	void SetTimeOffset(char nowDay, char nowMonth, short nowYear);
	
	// convert BCP time format to normal one: day, month, year, hour, ...
	void DecodeBCPTime(INT16S week, FP80 time, BCP_TIME &t);

	// convert normal time format to BCP one
	void EncodeBCPTime(BCP_TIME t, INT16S &week, FP80 &time);

	// packet making function
	int MakePacket(char *pData, unsigned char id, ...);

	// packet's data fixer (change 0x10 on 0x1010) - result will be in dst[]
	int FixPacketData(char *src, int src_size, char *dst);

	// extract data from packet
	int ExpandPacket(char *pData, INT8U id, BCP_VALUE p[]);

	// FP80 to FP64 converter
	double to64(void *fp80);

	// read sequence of bytes and extract packets from it
	void Process(char *buffer, int count);

	// user defined received packet handlers
	BCP_HANDLER Handler[256];

	// packet formats
	char *Format[256];

	// D7/E7 packets data formats
	char *FormatD7E7[9];

	// 49/40 packets data format (without rnpi&system and sat_num - only info)
	char *Format4940[4];

	// bytes/packets counter
	unsigned long long rx_bytes;
	unsigned long long rx_packets;
	BCP_HANDLER CounterHandler;		// user defined rx_? counters handler

protected:

	// process data
	char *pkt;
	int pktOffset;
	bool pktFound;
	int x;
	int bufSize;

	// time routines
	BCP_TIME timeOffset;			// 22.08.1999 or next...
	int PackTime(BCP_TIME t);
	void UnpackTime(int d, BCP_TIME &c);
};
