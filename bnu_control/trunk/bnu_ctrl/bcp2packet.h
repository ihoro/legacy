// $Id$

// definition of response _only_ (but you can add something else) packet's data for direct access to values (for working with FP80 you must use BCP2Engine::to64() function)
// firstly, you must have a variable 'INT8U *data_ptr', that points to begin of packet's data; and 'data_size' value (usual situation for BCP2Engine::Handler[]())
// also you need to define 'BCP_PACKET 0x??' and then include this file
// after using this macroses you must undefine all it just by using '#include "bcp2packet.h"', no defines need
//
// p.s. may be, it will be more effective in most cases by avoiding calls of BCP2Engine::ExpandPacket
// pp.s. some defines need to be local variables, isn't it?



// internal switch
#ifndef BCP_PACKET_DEFINE

	#define BCP_PACKET_DEFINE
	#define AS(offset,type)			(*(type*)(data_ptr + (offset)))
	#define PTR(offset,type)		((type*)(data_ptr + (offset)))
	#define BIT(bit_num,value)		( ((value) >> (bit_num)) & 1 )
	#define HI(offset)				(data_ptr[offset] & 0xF0)
	#define LO(offset)				(data_ptr[offset] & 0x0F)

#else

	#undef	BCP_PACKET_DEFINE
	#undef	AS
	#undef	PTR
	#undef	BIT
	#undef	HI
	#undef	LO

#endif



////////////////////////////////////////////////////////////////
#if BCP_PACKET == 0x40 || BCP_PACKET == 0x49

	#ifdef BCP_PACKET_DEFINE

		#define _rnpi			HI(0)
		#define _system			LO(0)
		#define _num			AS(1, INT8U)
		#define _info			PTR(2, INT8U)

	#else

		#undef _rnpi
		#undef _system
		#undef _num
		#undef _info

	#endif


////////////////////////////////////////////////////////////////
#elif BCP_PACKET == 0x41

	#ifdef BCP_PACKET_DEFINE

		#define _rnpi			AS(0, INT8U)
		#define _angle			AS(1, FP32)
		#define _speed			AS(5, FP32)
		#define _time			AS(9, INT32U)

	#else

		#undef _rnpi
		#undef _angle
		#undef _speed
		#undef _time

	#endif


////////////////////////////////////////////////////////////////
#elif BCP_PACKET == 0x42

	#ifdef BCP_PACKET_DEFINE

		#define _rnpi			HI(0)
		#define _channels		((INT32S)(data_size / 5))
		#define _ci				PTR(0, CHANNEL_INFO_42)
		#define _system(i)		(_ci[i].system & 0x0F)

	#else

		#undef _rnpi
		#undef _channels
		#undef _ci
		#undef _system

	#endif


////////////////////////////////////////////////////////////////
#elif BCP_PACKET == 0x43

	#ifdef BCP_PACKET_DEFINE

		#define _type			AS(0, INT8U)
		#define _devices		AS(1, INT8U)
		#define _channels		AS(2, INT32U)

	#else

		#undef _type
		#undef _devices
		#undef _channels

	#endif


////////////////////////////////////////////////////////////////
#elif BCP_PACKET == 0x46

	#ifdef BCP_PACKET_DEFINE

		#define _rnpi			AS(0, INT8U)
		#define _time			AS(1, INT32U)
		#define _day			AS(5, INT8U)
		#define _month			AS(6, INT8U)
		#define _year			AS(7, INT16U)
		#define _hour			AS(9, INT8S)
		#define _minute			AS(10, INT8S)

	#else

		#undef _rnpi
		#undef _time
		#undef _day
		#undef _month
		#undef _year
		#undef _hour
		#undef _minute

	#endif


////////////////////////////////////////////////////////////////
#elif BCP_PACKET == 0x47

	#ifdef BCP_PACKET_DEFINE

		#define _se				PTR(0, SATELLITE_ENABLED)
		#define _rnpi(i)		(_se[i].system & 0xF0)
		#define _system(i)		(_se[i].system & 0x0F)
		#define _num(i)			(_se[i].num)
		#define _enabled(i)		(_se[i].enabled)

	#else

		#undef _se
		#undef _rnpi
		#undef _system
		#undef _num
		#undef _enabled

	#endif


////////////////////////////////////////////////////////////////
#elif BCP_PACKET == 0x4A

	#ifdef BCP_PACKET_DEFINE

		#define _rnpi			AS(0, INT8U)
		#define _v				PTR(1, FP32)
		#define _flag			AS(33, INT8U)

	#else

		#undef _rnpi
		#undef _v
		#undef _flag

	#endif


////////////////////////////////////////////////////////////////
#elif BCP_PACKET == 0x4B

	#ifdef BCP_PACKET_DEFINE

		#define _rnpi			AS(0, INT8U)
		#define _v1				AS(1, FP64)
		#define _v2				AS(9, FP64)
		#define _v3				AS(17, INT32U)
		#define _v4				AS(21, INT16U)
		#define _v5				AS(23, INT16S)
		#define _v6				AS(25, INT16U)
		#define _v7				AS(27, INT16U)
		#define _v8				AS(29, INT16S)
		#define _v9				AS(31, INT8U)
		#define _v10			AS(32, INT16U)
		#define _v11			AS(34, FP64)
		#define _v12			AS(42, INT8U)

	#else

		#undef _rnpi
		#undef _v1
		#undef _v2
		#undef _v3
		#undef _v4
		#undef _v5
		#undef _v6
		#undef _v7
		#undef _v8
		#undef _v9
		#undef _v10
		#undef _v11
		#undef _v12

	#endif


////////////////////////////////////////////////////////////////
#elif BCP_PACKET == 0x4C

	#ifdef BCP_PACKET_DEFINE

		#define _rnpi			AS(0, INT8U)
		#define _plan			AS(1, INT8U)

	#else

		#undef _rnpi
		#undef _plan

	#endif


////////////////////////////////////////////////////////////////
#elif BCP_PACKET == 0x50

	#ifdef BCP_PACKET_DEFINE

		#define _port			AS(0, INT8U)
		#define _speed			AS(1, INT32U)
		#define _type			AS(5, INT8U)

	#else

		#undef _port
		#undef _speed
		#undef _type

	#endif


////////////////////////////////////////////////////////////////
#elif BCP_PACKET == 0x51

	#ifdef BCP_PACKET_DEFINE

		#define _rnpi			AS(0, INT8U)
		#define _system			AS(1, INT8U)
		#define _coords_system	AS(2, INT8U)
		#define _angle			AS(3, INT8U)
		#define _RMS			AS(5, INT16U)
		#define _power			AS(7, FP32)

	#else

		#undef _rnpi
		#undef _system
		#undef _coords_system
		#undef _angle
		#undef _RMS
		#undef _power

	#endif


////////////////////////////////////////////////////////////////
#elif BCP_PACKET == 0x52

	#ifdef BCP_PACKET_DEFINE

		#define _satellites		((INT32S)(data_size / 7))
		#define _si				PTR(0, SATELLITE_INFO)
		#define _rnpi			(_si[0].system & 0xF0)
		#define _system(i)		(_si[i].system & 0x0F)

	#else

		#undef _satellites
		#undef _si
		#undef _rnpi
		#undef _system

	#endif


////////////////////////////////////////////////////////////////
#elif BCP_PACKET == 0x53

	#ifdef BCP_PACKET_DEFINE

		#define _rnpi			AS(0, INT8U)
		#define _time			PTR(1, FP80)
		#define _week			AS(11, INT16S)
		#define _diff_OG		AS(13, FP32)
		#define _status			AS(17, INT8U)
		#define	_solution		BIT(0, _status)
		#define	_2D				BIT(1, _status)
		#define	_diff_use		BIT(3, _status)
		#define	_RAIM			BIT(4, _status)
		#define	_diff_mode		BIT(5, _status)

	#else

		#undef _rnpi
		#undef _time
		#undef _week
		#undef _diff_OG
		#undef _status
		#undef _solution
		#undef _2D
		#undef _diff_use
		#undef _RAIM
		#undef _diff_mode

	#endif


////////////////////////////////////////////////////////////////
#elif BCP_PACKET == 0x54


////////////////////////////////////////////////////////////////
#elif BCP_PACKET == 0x56

	#ifdef BCP_PACKET_DEFINE

		#define _num			AS(0, INT8U)
		#define _BT				AS(1, INT32U)
		#define _rnpi			(												\
									(_num <= 33)								\
									?											\
										(INT8U)0x00								\
									:											\
										(_num <= 83)							\
										?										\
											(INT8U)0x10							\
										:										\
											(_num <= 133)						\
											?									\
												(INT8U)0x20						\
											:									\
												(_num <= 183)					\
												?								\
													(INT8U)0x40					\
												:								\
													(INT8U)0xFF					\
								)
		#define _rnpi_full		(												\
									(_num <= 33)								\
									?											\
										(_num == 33)							\
										?										\
											(INT8U)0x01							\
										:										\
											(INT8U)0x00							\
									:											\
										(_num <= 83)							\
										?										\
											(_num == 83)						\
											?									\
												(INT8U)0x11						\
											:									\
												(INT8U)0x10						\
										:										\
											(_num <= 133)						\
											?									\
												(_num == 133)					\
												?								\
													(INT8U)0x21					\
												:								\
													(INT8U)0x20					\
											:									\
												(_num <= 183)					\
												?								\
													(_num == 183)				\
													?							\
														(INT8U)0x41				\
													:							\
														(INT8U)0x40				\
												:								\
													(INT8U)0xFF					\
								)

	#else

		#undef _num
		#undef _BT
		#undef _rnpi

	#endif


////////////////////////////////////////////////////////////////
#elif BCP_PACKET == 0x60

	#ifdef BCP_PACKET_DEFINE

		#define _rnpi			AS(0, INT8U)
		#define _gps			AS(1, INT8U)
		#define _gln			AS(2, INT8U)
		#define _hdop			AS(3, FP32)
		#define _vdop			AS(7, FP32)

	#else

		#undef _rnpi
		#undef _gps
		#undef _gln
		#undef _hdop
		#undef _vdop

	#endif


////////////////////////////////////////////////////////////////
#elif BCP_PACKET == 0x70

	#ifdef BCP_PACKET_DEFINE

		#define _channels		AS(0, INT8U)
		#define _id_str(i)		PTR(i*25 + 1, INT8U)
		#define _cypher(i)		AS(i*25 + 1 + 21, INT32U)
		#define _rnpi			(												\
									(_channels <= 49)							\
									?											\
										(INT8U)0x00								\
									:											\
										(_channels <= 99)						\
										?										\
											(INT8U)0x10							\
										:										\
											(_channels <= 149)					\
											?									\
												(INT8U)0x20						\
											:									\
												(_channels <= 199)				\
												?								\
													(INT8U)0x40					\
												:								\
													(_channels == 255)			\
													?							\
														(INT8U)0x80				\
													:							\
														(INT8U)0xF0				\
								)

	#else

		#undef _channels
		#undef _id_str
		#undef _cypher
		#undef _rnpi

	#endif


////////////////////////////////////////////////////////////////
#elif BCP_PACKET == 0x74

	#ifdef BCP_PACKET_DEFINE

		#define _rnpi			AS(0, INT8U)
		#define _v				PTR(1, INT8U)
		#define _flag			AS(51, INT8U)

	#else

		#undef _rnpi
		#undef _v
		#undef _flag

	#endif


////////////////////////////////////////////////////////////////
#elif BCP_PACKET == 0x87

	#ifdef BCP_PACKET_DEFINE

		#define _rnpi			AS(0, INT8U)
		#define _channels		((INT32S)(data_size / 20))
		#define _ci				PTR(1, CHANNEL_INFO)

	#else

		#undef _rnpi
		#undef _channels
		#undef _ci

	#endif


////////////////////////////////////////////////////////////////
#elif BCP_PACKET == 0x88

	#ifdef BCP_PACKET_DEFINE

		#define _rnpi				AS(0, INT8U)
		#define _latitude			AS(1, FP64)
		#define _longitude			AS(9, FP64)
		#define _height				AS(17, FP64)
		#define _RMS				AS(25, FP32)
		#define _time				PTR(29, INT8U)
		#define _week				AS(39, INT16S)
		#define _latitude_speed		AS(41, FP64)
		#define _longitude_speed	AS(49, FP64)
		#define _height_speed		AS(57, FP64)
		#define _deflection			AS(65, FP32)
		#define _status				AS(69, INT8U)

	#else

		#undef _rnpi
		#undef _latitude
		#undef _longitude
		#undef _height
		#undef _RMS
		#undef _time
		#undef _week
		#undef _latitude_speed
		#undef _longitude_speed
		#undef _height_speed
		#undef _deflection
		#undef _status

	#endif


////////////////////////////////////////////////////////////////
#elif BCP_PACKET == 0x89

	#ifdef BCP_PACKET_DEFINE

		#define _rnpi				AS(0, INT8U)
		#define _latitude			AS(1, FP64)
		#define _longitude			AS(9, FP64)
		#define _height				AS(17, FP64)
		#define _RMS				AS(25, FP32)
		#define _time				PTR(29, INT8U)
		#define _week				AS(39, INT16S)
		#define _latitude_speed		AS(41, FP64)
		#define _longitude_speed	AS(49, FP64)
		#define _height_speed		AS(57, FP64)

	#else

		#undef _rnpi
		#undef _latitude
		#undef _longitude
		#undef _height
		#undef _RMS
		#undef _time
		#undef _week
		#undef _latitude_speed
		#undef _longitude_speed
		#undef _height_speed

	#endif


////////////////////////////////////////////////////////////////
#elif BCP_PACKET == 0xA3

	#ifdef BCP_PACKET_DEFINE

		#define _rnpi			AS(0, INT8U)
		#define _index			AS(1, INT8U)
		#define _v				PTR(2, FP32)
		#define _name			PTR(38, INT8U)

	#else

		#undef _rnpi
		#undef _index
		#undef _v
		#undef _name

	#endif


////////////////////////////////////////////////////////////////
#elif BCP_PACKET == 0xA5

	#ifdef BCP_PACKET_DEFINE

		#define _time			AS(0, FP64)
		#define _week			AS(8, INT16S)
		#define _course			AS(10, FP32)
		#define _roll			AS(14, FP32)
		#define _different		AS(18, FP32)
		#define _course_RMS		AS(22, FP32)
		#define _roll_RMS		AS(26, FP32)
		#define _different_RMS	AS(30, FP32)
		#define _status			AS(34, INT8U)

	#else

		#undef _time
		#undef _week
		#undef _course
		#undef _roll
		#undef _different
		#undef _course_RMS
		#undef _roll_RMS
		#undef _different_RMS
		#undef _status

	#endif


////////////////////////////////////////////////////////////////
#elif BCP_PACKET == 0xA7

	#ifdef BCP_PACKET_DEFINE

		#define _rnpi			AS(0, INT8U)

	#else

		#undef _rnpi

	#endif


////////////////////////////////////////////////////////////////
#elif BCP_PACKET == 0xA9

	#ifdef BCP_PACKET_DEFINE

		#define _point			AS(0, INT8U)
		#define _v				PTR(1, FP32)

	#else

		#undef _point
		#undef _v

	#endif


////////////////////////////////////////////////////////////////
#elif BCP_PACKET == 0xAB

	#ifdef BCP_PACKET_DEFINE

		#define _point_num			AS(0, INT8U)
		#define _latitude			AS(1, FP64)
		#define _longitude			AS(9, FP64)
		#define _height				AS(17, FP64)
		#define	_RMS				AS(25, FP32)
		#define _time				AS(29, FP64)
		#define _week				AS(37, INT16S)
		#define _speed				PTR(39, FP64)
		#define _latitude_speed		AS(39, FP64)
		#define _longitude_speed	AS(47, FP64)
		#define _height_speed		AS(55, FP64)
		#define _status				AS(63, INT8U)
		#define _decision			BIT(0, _status)
		#define _2D					BIT(1, _status)
		#define _diff				BIT(3, _status)
		#define _RAIM				BIT(4, _status)
		#define _diff_mode			BIT(5, _status)

	#else

		#undef _point_num
		#undef _latitude
		#undef _longitude
		#undef _height
		#undef _RMS
		#undef _time
		#undef _week
		#undef _speed
		#undef _latitude_speed
		#undef _longitude_speed
		#undef _height_speed
		#undef _status
		#undef _decision
		#undef _2D
		#undef _diff
		#undef _RAIM
		#undef _diff_mode

	#endif


////////////////////////////////////////////////////////////////
#elif BCP_PACKET == 0xAD

	#ifdef BCP_PACKET_DEFINE

		#define _type			AS(0, INT8U)
		#define _course			AS(1, FP32)
		#define _different		AS(5, FP32)
		#define _roll			AS(9, FP32)

	#else

		#undef _type
		#undef _course
		#undef _different
		#undef _roll

	#endif


////////////////////////////////////////////////////////////////
#elif BCP_PACKET == 0xAF

	#ifdef BCP_PACKET_DEFINE

		#define _type			AS(0, INT8U)
		#define _v				PTR(1, FP32)

	#else

		#undef _type
		#undef _v

	#endif


////////////////////////////////////////////////////////////////
#elif BCP_PACKET == 0xB7

	#ifdef BCP_PACKET_DEFINE

		#define _response		AS(0, INT8U)

	#else

		#undef _response

	#endif


////////////////////////////////////////////////////////////////
#elif BCP_PACKET == 0xBD

	#ifdef BCP_PACKET_DEFINE

		#define	_base_line			AS(0, INT8U)
		#define	_base_num			(											\
										(_base_line <= 2)						\
										?										\
											_base_line							\
										:										\
											(_base_line == 0x04)				\
											?									\
												(INT8U)3						\
											:									\
												(_base_line == 0x08)			\
												?								\
													(INT8U)4					\
												:								\
													0							\
									)
		#define _v					PTR(1, FP64)
		#define _gps_time			AS(1, FP64)
		#define _projection_x		AS(9, FP64)
		#define _projection_y		AS(17, FP64)
		#define _projection_z		AS(25, FP64)
		#define _gps_num			AS(33, INT8U)
		#define _gln_num			AS(34, INT8U)
		#define _flag				AS(35, INT8U)

	#else

		#undef _base_line
		#undef _base_num
		#undef _v
		#undef _gps_time
		#undef _projection_x
		#undef _projection_y
		#undef _projection_z
		#undef _gps_num
		#undef _gln_num
		#undef _flag

	#endif


////////////////////////////////////////////////////////////////
#elif BCP_PACKET == 0xC1

	#ifdef BCP_PACKET_DEFINE

		#define _intervals		AS(0, INT8U)
		#define _gdop(i)		AS(i*12 + 1, FP32)
		#define _start(i)		AS(i*12 + 1 + 4, INT32U)
		#define _stop(i)		AS(i*12 + 1 + 8, INT32U)

	#else

		#undef _intervals
		#undef _gdop
		#undef _start
		#undef _stop

	#endif


////////////////////////////////////////////////////////////////
#elif BCP_PACKET == 0xC2

	#ifdef BCP_PACKET_DEFINE

		#define _state			AS(0, INT16U)
		#define _fki			BIT(1, _state)
		#define _height			BIT(2, _state)
		#define _coords			BIT(3, _state)

	#else

		#undef _state
		#undef _fki
		#undef _height
		#undef _coords

	#endif


////////////////////////////////////////////////////////////////
#elif BCP_PACKET == 0xCA

	#ifdef BCP_PACKET_DEFINE

		#define	_base_line			AS(0, INT8U)
		#define	_base_num			(											\
										(_base_line <= 2)						\
										?										\
											_base_line							\
										:										\
											(_base_line == 0x04)				\
											?									\
												(INT8U)3						\
											:									\
												(_base_line == 0x08)			\
												?								\
													(INT8U)4					\
												:								\
													0							\
									)
		#define _v					PTR(1, FP64)
		#define _gps_time			AS(1, FP64)
		#define _projection_x		AS(9, FP64)
		#define _projection_y		AS(17, FP64)
		#define _projection_z		AS(25, FP64)
		#define _speed_x			AS(33, FP64)
		#define _speed_y			AS(41, FP64)
		#define _speed_z			AS(49, FP64)
		#define _gps_num			AS(57, INT8U)
		#define _gln_num			AS(58, INT8U)
		#define _fisher_stat		AS(59, FP64)
		#define _fisher_threshold	AS(67, FP64)

	#else

		#undef _base_line
		#undef _base_num
		#undef _v
		#undef _gps_time
		#undef _projection_x
		#undef _projection_y
		#undef _projection_z
		#undef _speed_x
		#undef _speed_y
		#undef _speed_z
		#undef _gps_num
		#undef _gln_num
		#undef _fisher_stat
		#undef _fisher_threshold

	#endif


////////////////////////////////////////////////////////////////
#elif BCP_PACKET == 0xE4

	#ifdef BCP_PACKET_DEFINE

		#define _interval		AS(0, INT16U)
		#define _rnpi			HI(2)
		#define _type			LO(2)
		#define _time			AS(3, FP64)
		#define _week			AS(11, INT16S)
		#define _time_diff		AS(13, FP32)
		#define _channels		AS(17, INT8U)
		#define _cm				PTR(18, CHANNEL_MEASUREMENT)
		#define _num(i)			(_cm[i].num_sys & 0x1F)
		#define _system(i)		(_cm[i].num_sys >> 5)
        
	#else

		#undef _interval
		#undef _rnpi
		#undef _type
		#undef _time
		#undef _week
		#undef _time_diff
		#undef _channels
		#undef _cm
		#undef _num
		#undef _system

	#endif


////////////////////////////////////////////////////////////////
#elif BCP_PACKET == 0xE6

	#ifdef BCP_PACKET_DEFINE

		#define _status			AS(0, INT8U)
        
	#else

		#undef _status

	#endif


////////////////////////////////////////////////////////////////
#elif BCP_PACKET == 0xE7

	#ifdef BCP_PACKET_DEFINE

		#define	_rnpi			AS(0, INT8U)
		#define	_type			LO(0)
		#define	_accel			AS(1, FP32)
		#define	_rate			AS(1, INT8U)
		#define	_interval		AS(1, INT16U)
		#define	_category1		AS(1, INT8U)
		#define	_category2		AS(2, INT8U)
		#define _time			AS(1, INT8U)
		#define	_time1			BIT(0, _time)
		#define	_time2			BIT(1, _time)
		#define	_time3			BIT(3, _time)
		#define	_time4			(_time >> 4)
		#define	_time5			AS(2, INT8U)
		#define	_time6			AS(3, INT32U)
		#define	_latency		AS(1, FP64)
		#define _mode			AS(1, INT16U)
		#define	_RAIM			BIT(0, _mode)
		#define	_RAIM_type		BIT(1, _mode)
		#define	_2D				BIT(2, _mode)
		#define	_one			BIT(3, _mode)
		#define	_RTCM			BIT(0, _mode)
		#define	_SBAS			BIT(1, _mode)
		#define	_GBAS			BIT(2, _mode)
		#define	_count1			AS(1, INT8U)
		#define	_count2			AS(2, INT8U)
		#define	_count3			AS(3, INT8U)
        
	#else

		#undef _rnpi
		#undef _type
		#undef _accel
		#undef _rate
		#undef _interval
		#undef _category1
		#undef _category2
		#undef _time
		#undef _time1
		#undef _time2
		#undef _time3
		#undef _time4
		#undef _time5
		#undef _time6
		#undef _latency
		#undef _mode
		#undef _RAIM
		#undef _RAIM_type
		#undef _2D
		#undef _one
		#undef _RTCM
		#undef _SBAS
		#undef _GBAS
		#undef _count1
		#undef _count2
		#undef _count3

	#endif


////////////////////////////////////////////////////////////////
#elif BCP_PACKET == 0xFE

	#ifdef BCP_PACKET_DEFINE

		#define _count			AS(0, INT8U)
		#define _v(i,j)			AS(i*14 + 1 + j*2, INT16U)
        
	#else

		#undef _count
		#undef _v

	#endif


////////////////////////////////////////////////////////////////
#elif BCP_PACKET == 0xFF

	#ifdef BCP_PACKET_DEFINE

		#define _count			AS(0, INT16U)
		#define _sum1			AS(2, INT32U)
		#define _sum2			AS(6, INT32U)
		#define _sum3			AS(10, INT32U)
		#define _state			AS(14, INT16S)
        
	#else

		#undef _count
		#undef _sum1
		#undef _sum2
		#undef _sum3
		#undef _state

	#endif


#endif



	
// cleaning
#ifndef BCP_PACKET_DEFINE

	#undef BCP_PACKET

#endif
