// $Id$

#pragma once


// windows appearance
#define TITLE_BAR_HEIGHT 20
#define PICS_COUNT 10
extern HDC dc_pic[];

// animation defaults
#define MINIMIZE_ANIMATION_SPEED 5				// 0..100% of height

// timer defaults
#define TIMER_DEF_ID		99999
#define TIMER_DEF_MSG_ID	IDS_TIMER_MESSAGE
	#ifndef _DEBUG
#define TIMER_DEF_INTERVAL	60*1000
	#else
#define TIMER_DEF_INTERVAL	3000
	#endif

// requests tuning defaults
#define REQ_DEF_PERIOD				RESPONSE_PERIOD_IN_INTERVALS
#define REQ_DEF_MIN					1
#define REQ_DEF_MAX					255
#define REQ_DEF_PERIOD_TEXTLIMIT	3

// ini-values types
#define INI_TYPE_EDIT			0			// just text of edit control
#define INI_TYPE_COMBOBOX		1			// selection index of combobox
#define INI_TYPE_CHECKBOX		2			// state of checkbox - 0/1
#define INI_TYPE_GRID_COLUMN	3			// text of each cell of defined grid's column, it needs to specify column index instead of 'id'
#define INI_TYPE_RADIOBOX		4			// IDs of elements: first = LOWORD(id), last = HIWORD(id), where id is member of INI_VALUE_INFO

// ini-value info structure
struct INI_VALUE_INFO
{
	char *key_name;							// name of key in ini-section
	char type;								// type of value (see defines above)
	int id;									// ID of control (or grid's column index)
	CGridCtrl *grid;						// if type != INI_TYPE_GRID_COLUMN it may be anything
};

// callback function type
typedef bool (*PROCCLOSE) (unsigned char);



/////////////////
// CWindow dialog
/////////////////

class CWindow : public CDialog
{
	DECLARE_DYNAMIC(CWindow)

public:

	CWindow(PROCCLOSE procClose = 0, char wndID = 0);

	bool info_mode;								// is used for CWindowInfo (if true)

	bool isMinimized;							// true while it's rolled up
	bool isBusy;								// window's waiting for message box or something else

	void RollUpDown();							// do subj

	DECLARE_MESSAGE_MAP()
	virtual BOOL OnInitDialog();
	afx_msg void OnTimer(UINT nIDEvent);
	afx_msg void OnPaint();

protected:

	virtual void OnCancel();
	virtual void OnOK() {};						// don't use <Enter> - use <Esc>
	virtual BOOL OnCommand(WPARAM wParam, LPARAM lParam);
	virtual LRESULT WindowProc(UINT message, WPARAM wParam, LPARAM lParam);

	// callback info
	PROCCLOSE cp;
	char wid;

	// animation data
	int wndWidth;
	int wndHeight;
	int speed;

	// for working with packets
	char p[PACKET_MAX_SIZE];					// packet
	int size;									// size of packet
	inline virtual void sendp();				// send packet
public:
	int device;									// selected device for this window



	// internal response waiting timer
	//////////////////////////////////

public:

	bool tmr_on(int msg_id = TIMER_DEF_MSG_ID,		// turn timer on. if msg_id=0 message box will not appear
				int interval = TIMER_DEF_INTERVAL,
				int timer_id = TIMER_DEF_ID);
	void tmr_off();									// turn timer off
	virtual void tmr_do() {};						// user defined handler for elapsed time

private:

	UINT_PTR tmr_id;								// timer ID
	int tmr_msg_id;									// timer message ID



	// internal GUI handler for tuning periodic requests
	////////////////////////////////////////////////////

public:

	void req_init(int once_id,										// ID of once button
				  int periodic_id,									// ID of periodic checkbox
				  int period_id,									// ID of period edit
				  int period_def = REQ_DEF_PERIOD,					// default period
				  int period_min = REQ_DEF_MIN,						// min period
				  int period_max = REQ_DEF_MAX,						// max period
				  int period_textlimit = REQ_DEF_PERIOD_TEXTLIMIT);	// text limit in symbols for period edit
	void req_free();												// turn it off, if need it will call req_off()

	void req_set_period(INT8U period = 0);							// just set new period number in period edit, but it checks for min/max and if number is else it will sets default period
	void req_periodic_on();											// turn periodic mode on
	inline bool req_if_once();										// if current mode is once (not periodic) it will return true

	virtual void req_periodic(INT8U period) {};						// user defined handler for tuning periodic request: send packet, etc
	virtual void req_off() {};										// user defined handler for turn request off: send packet, etc
	virtual void req_once() {};										// user defined handler for tuning once request: send packet, etc	

private:

	bool req_on;													// if this tuning is turned on
	int REQ_ONCE_ID;
	int REQ_PERIODIC_ID;
	int REQ_PERIOD_ID;
	int req_period_def;
	int req_period_min;
	int req_period_max;

	int req_check_period();											// checks period for min/max and return valid value



	// user defined configuration values (ini-file)
	///////////////////////////////////////////////

public:

	void ini_init(int ivi_count, INI_VALUE_INFO ivi[]);	// ivi_count - number of records in ivi

	void ini_load();									// load and set values from ini-file
	void ini_save();									// save values into ini-file

private:

	INI_VALUE_INFO *ini_ivi;
	int ini_ivi_count;

	CString ini_section;								// name of section in ini-file for this window



	// user defined device selector
	///////////////////////////////

public:

	void ds_init(INT8U *dev_list);						// INT8U dev_list[] - sequence of bytes for each device (BNU, RNPI, etc)
	inline INT8U ds_get();								// return byte assigned with current(not same to DEVICE) selected device
	INT8U ds_get_rnpi_need();							// get 'need' param for rnpi_init()

private:

	INT8U *ds_list;



	// internal checker of received packets with different rnpi flag (0x0?, 0x1?, 0x2?, 0x4?)
	/////////////////////////////////////////////////////////////////////////////////////////

public:

	void rnpi_init(INT8U need,					// what rnpi you need to catch: 0,1,2,3 (as #1,2,3,4), if need = 4 - then you need all 4 rnpi. if need = 5, then you must specify in mask argument not standard rnpi number, which you need to catch. if need = 0xff, then need will be as ds_get_rnpi_need()
				   INT8U mask);					// must be 0x0?, ? - some parameter that rnpi must have to be passed, if ? = 0, then rnpi may have any parameter (so, it doesn't matter)
	INT8U rnpi_add(INT8U rnpi);					// check & add new catched rnpi, if it's bad rnpi number it will return false
	inline bool rnpi_done();					// if rnpi_got == rnpi_need it will return true, so you have catched all that you need
	bool rnpi_done_as(INT8U rnpi);				// if rnpi_got == rnpi it will return true, so you have catched all that you need

private:

	INT8U rnpi_got;								// holds sum(OR) of all catched rnpi flags
	INT8U rnpi_need;							// flag for checking rnpi_got
	INT8U rnpi_mask;							// same as argument in rnpi_init()
	bool rnpi_user_defined;						// if rnpi_init(5, ?) was used



    // windows appearance
	/////////////////////

public:

	PAINTSTRUCT ps;			// use if you need to paint something
	HDC dc;					// use if you need to paint something

private:

	HDC dc_title;			// ready to use title bar of this window
	RECT title_rect;		// left-top & bottom-down corners 
	RECT close_rect;		// left-top & bottom-down corners
	RECT roller_rect;		// left-top & bottom-down corners
	bool if_moving;			// if user is moving window
	POINT last_pos;			// of mouse (for moving window)
	bool if_tracking;		// if it's tracking mouse events yet
	unsigned char sbs;		// system buttons state:
							//  ???? 01?? - close_free
							//  ???? 10?? - close_mouse_move
	                        //  ???? 11?? - close_mouse_down
	                        //  ???? ??00 - roll_up is active
	                        //  ???? ??11 - roll_down is active
	                        //  ??00 ???? - roll_?_free
	                        //  ??01 ???? - roll_?_mouse_move 
	                        //  ??10 ???? - roll_?_mouse_down
							//  ?1?? ???? - close was captured
							//  1??? ???? - roller was captured

	#define IF_MOUSE_ON_CLOSE			(x >= close_rect.left && x <= close_rect.right && y >= close_rect.top && y <= close_rect.bottom)
	#define IF_MOUSE_ON_ROLLER			(x >= roller_rect.left && x <= roller_rect.right &&	y >= roller_rect.top && y <= roller_rect.bottom)
	#define IF_MOUSE_ON_TITLE_BAR		(x >= title_rect.left && x <= title_rect.right && y >= title_rect.top && y <= title_rect.bottom)

	#define IF_ANY_IS_CAPTURED			(sbs & 0xC0)

	#define IF_CLOSE_IS_FREE			((sbs & 0x0C) == 0x04)
	#define IF_CLOSE_IS_MOUSE_MOVE		((sbs & 0x0C) == 0x08)
	#define IF_CLOSE_IS_MOUSE_DOWN		((sbs & 0x0C) == 0x0C)
	#define IF_CLOSE_IS_CAPTURED		((sbs & 0x40) == 0x40)
    
	#define IF_ROLLER_IS_FREE			((sbs & 0x30) == 0x00)
	#define IF_ROLLER_IS_MOUSE_MOVE		((sbs & 0x30) == 0x10)
	#define IF_ROLLER_IS_MOUSE_DOWN		((sbs & 0x30) == 0x20)
	#define IF_ROLLER_IS_CAPTURED		((sbs & 0x80) == 0x80)

	#define EQU_CLOSE_FREE				((sbs | 0x04) & 0xF7)
	#define EQU_CLOSE_MOUSE_MOVE		((sbs | 0x08) & 0xFB)
	#define EQU_CLOSE_MOUSE_DOWN		(sbs | 0x0C)
	#define EQU_CLOSE_CAPTURED			(sbs | 0x40)
	#define EQU_CLOSE_NOT_CAPTURED		(sbs & 0xBF)

	#define EQU_ROLLER_FREE				(sbs & 0xCF)
	#define EQU_ROLLER_MOUSE_MOVE		((sbs | 0x10) & 0xDF)
	#define EQU_ROLLER_MOUSE_DOWN		((sbs | 0x20) & 0xEF)
	#define EQU_ROLLER_CAPTURED			(sbs | 0x80)
	#define EQU_ROLLER_NOT_CAPTURED		(sbs & 0x7F)

	#define EQU_ROLLER_TYPE_UP			(sbs & 0xFC)
	#define EQU_ROLLER_TYPE_DOWN		(sbs | 0x03)

	#define CLOSE_PIC_ID				((sbs >> 2) & 0x03)
	#define ROLLER_PIC_ID				( ((sbs & 0x30) >> 4) + (sbs & 0x03) + 4 )
};