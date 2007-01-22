#include "stdafx.h"
#include "bnu_ctrl.h"


/////////////////
// CWindow dialog
/////////////////

// windows appearance
HDC dc_pic[PICS_COUNT];

IMPLEMENT_DYNAMIC(CWindow, CDialog)

CWindow::CWindow(PROCCLOSE procClose, char wndID):
	isMinimized(false),
	isBusy(false),
	tmr_id(0),
	req_on(false),
	if_moving(false),
	if_tracking(false),
	sbs(4),
	ini_ivi(0),
	ini_ivi_count(0)
{
	// check for info_mode
	if (wndID & 0x80)
		info_mode = true;
	else
		info_mode = false;

	// callback info
	cp = procClose;
	wid = wndID;

	// remember last device
	device = DEVICE;
}

void CWindow::sendp()
{
	mdlg->SendData(p, size);
}

// CWindow message handlers

void CWindow::OnCancel()
{
	cp(wid);
}

BEGIN_MESSAGE_MAP(CWindow, CDialog)
	ON_WM_TIMER()
	ON_WM_PAINT()
END_MESSAGE_MAP()

BOOL CWindow::OnInitDialog()
{
	CDialog::OnInitDialog();

	// only for window WND_1B
	if (wid == WND_1B && DEVICE > 0)
	{
		// resize grid
		CWnd *w = GetDlgItem(IDC_1B_GRID);
		RECT r;
		w->GetWindowRect(&r);
		w->SetWindowPos(0, 0,0, r.right - r.left + 1,69, SWP_NOMOVE|SWP_NOZORDER);

		// resize window
		GetWindowRect(&r);
		SetWindowPos(0, 0,0, r.right - r.left + 1,90, SWP_NOMOVE|SWP_NOZORDER);
	}

	// get width
	RECT r;
	::GetClientRect(m_hWnd, &r);
	wndWidth = r.right;
	wndHeight = r.bottom;

	// real speed of animation in pixels
	speed = (wndHeight - TITLE_BAR_HEIGHT) * MINIMIZE_ANIMATION_SPEED / 100;

	// set title bar's RECT
	title_rect.left = 1;
	title_rect.top = 1;
	title_rect.right = wndWidth-3;
	title_rect.bottom = TITLE_BAR_HEIGHT - 2;

	// set close button RECT
	close_rect.left = wndWidth-1 - 15;
	close_rect.top = 1;
	close_rect.right = wndWidth-1 - 1;
	close_rect.bottom = TITLE_BAR_HEIGHT - 2;

	// set roller button RECT
	roller_rect.left = 1;
	roller_rect.top = 1;
	roller_rect.right = 15;
	roller_rect.bottom = TITLE_BAR_HEIGHT - 2;

	// prepare DC
	HDC dc = ::GetDC(m_hWnd);
	HBITMAP bm = ::CreateCompatibleBitmap(dc, wndWidth-2, TITLE_BAR_HEIGHT - 2);
	dc_title = ::CreateCompatibleDC(dc);
	::SelectObject(dc_title, bm);
	::DeleteObject(bm);

	// create own title bar for this window
	::StretchBlt(dc_title, 0,0,wndWidth-2,18, dc_pic[0], 0,0,1,TITLE_BAR_HEIGHT-2, SRCCOPY);

	// draw title text on another DC
	bm = ::CreateCompatibleBitmap(dc, wndWidth-2-30, TITLE_BAR_HEIGHT-2);
	HDC dc_text = ::CreateCompatibleDC(dc);
	::SelectObject(dc_text, bm);
	::DeleteObject(bm);
	r.left = 0;
	r.top = 1;
	r.right = wndWidth-2-30-1;
	r.bottom = TITLE_BAR_HEIGHT - 3;
	::SelectObject(dc_text, lfVerdana7);
	::SetTextColor(dc_text, 0x00FFFFFF);
	::SetBkColor(dc_text, 0);
	CString s;
	if (info_mode)
		s.Format("%s %s #%d",
				 (wid & 0x40) ? "Альманах" : "Эфемериды",
				 ((wid & 0x3F) < 32 ) ? "GPS" : "ГЛОНАСС",
				 ((wid & 0x3F) < 32 ) ? ((wid & 0x3F) + 1) : ((wid & 0x3F) - 31) );
	else
		s.LoadString(IDS_TITLE_0 + wid);
	::DrawText(dc_text, s, s.GetLength(), &r, DT_NOCLIP|DT_SINGLELINE|DT_END_ELLIPSIS);
	
	// move title text on title bar
	::BitBlt(dc_title, 14,1,wndWidth-2-30,TITLE_BAR_HEIGHT-2, dc_text, 0,0, SRCPAINT);

	::DeleteDC(dc_text);


	// set section of ini file and load it
	ini_section.Format("0x%02X", (INT8U)wid);
	ini_load();

	return TRUE;
}

void CWindow::RollUpDown()
{
	isMinimized = !isMinimized;

	RECT w;
	GetWindowRect(&w);

	if (isMinimized)
	{
		for (int i=speed; i <= wndHeight - TITLE_BAR_HEIGHT; i += speed)
			MoveWindow(w.left, w.top, wndWidth + 2, wndHeight + 2 - i);
		MoveWindow(w.left, w.top, wndWidth + 2, TITLE_BAR_HEIGHT + 2);	// minimize completely

		sbs = EQU_ROLLER_TYPE_DOWN;
	}
	else
	{
		for (int i=speed; i <= wndHeight - TITLE_BAR_HEIGHT; i += speed)
			MoveWindow(w.left, w.top, wndWidth + 2, TITLE_BAR_HEIGHT + 2 + i);
		MoveWindow(w.left, w.top, wndWidth + 2, wndHeight + 2);			// maximize completely

		sbs = EQU_ROLLER_TYPE_UP;
	}
}

bool CWindow::tmr_on(int msg_id, int interval, int timer_id)
{
	tmr_msg_id = msg_id;

	tmr_id = SetTimer(timer_id, interval, 0);

	if (tmr_id)
		return true;
	else
	{
#ifdef _DEBUG
		CString s,s2;
		s.LoadString(IDS_SET_TIMER_ERR);
		s2.LoadString(IDS_ERROR);
		isBusy = true;
		MessageBox(s, s2, MB_OK|MB_ICONERROR);
		isBusy = false;
#endif
		return false;
	}
}

void CWindow::tmr_off()
{
	KillTimer(tmr_id);
	tmr_id = 0;

	if (req_on)
	{
		ENABLE_ITEM(REQ_ONCE_ID, true);
		ENABLE_ITEM(REQ_PERIODIC_ID, true);
	}
}

void CWindow::OnTimer(UINT nIDEvent)
{
	if (tmr_id && tmr_id == nIDEvent)
	{
		// turn timer off
		tmr_off();

		// do user defined handler
		tmr_do();

		// show timer message
		if (tmr_msg_id && !mdlg->m_isDemo)
		{
			CString s,s2;
			s.LoadString(tmr_msg_id);
			s2.LoadString(IDS_ERROR);
			isBusy = true;
			MessageBox(s, s2, MB_OK|MB_ICONERROR);
			isBusy = false;
		}
	}

	CDialog::OnTimer(nIDEvent);
}

void CWindow::req_init(int once_id, int periodic_id, int period_id,
					   int period_def, int period_min, int period_max,
					   int period_textlimit)
{
	// turn handler on
	req_on = true;

	// set parameters
	REQ_ONCE_ID = once_id;
	REQ_PERIODIC_ID = periodic_id;
	REQ_PERIOD_ID = period_id;
	req_period_def = period_def;
	req_period_min = period_min;
	req_period_max = period_max;

	// set period text limit
	SendDlgItemMessage(REQ_PERIOD_ID, EM_LIMITTEXT, period_textlimit, 0);

	// if it needs to set periodic mode on
	if (IsDlgButtonChecked(REQ_PERIODIC_ID))
		req_periodic_on();
}

void CWindow::req_free()
{
	if (req_on && !req_if_once())
		req_off();
}

int CWindow::req_check_period()
{
	int i = GetDlgItemInt(REQ_PERIOD_ID, 0, false);
	return ( i >= req_period_min && i <= req_period_max ) ? i : req_period_def;
}

void CWindow::req_set_period(INT8U period)
{
	SetDlgItemInt(REQ_PERIOD_ID, period, false);
	SetDlgItemInt(REQ_PERIOD_ID, req_check_period(), false);
}

void CWindow::req_periodic_on()
{	 
	CheckDlgButton(REQ_PERIODIC_ID, 1);
	SendMessage(WM_COMMAND, (BN_CLICKED << 16) | REQ_PERIODIC_ID, (LPARAM)::GetDlgItem(m_hWnd, REQ_PERIODIC_ID));
}

bool CWindow::req_if_once()
{
	if ( IsDlgButtonChecked(REQ_PERIODIC_ID) )
		return false;
	else
		return true;
}

BOOL CWindow::OnCommand(WPARAM wParam, LPARAM lParam)
{
	HWND h1, h2;

	if (req_on)

		switch (HIWORD(wParam))
		{
		case BN_CLICKED:

			h1 = ::GetDlgItem(m_hWnd, REQ_ONCE_ID);
			h2 = ::GetDlgItem(m_hWnd, REQ_PERIOD_ID);

			// if periodic checkbox was clicked
			if (LOWORD(wParam) == REQ_PERIODIC_ID)
			{
				if (IsDlgButtonChecked(REQ_PERIODIC_ID))
				{
					::EnableWindow(h1, false);
					::EnableWindow(h2, true);
					SetDlgItemInt(REQ_PERIOD_ID, req_check_period(), false);
					//req_periodic( (INT8U)req_check_period() );	[bUg] - it will be done by EN_CHANGE !
				}
				else
				{
					::EnableWindow(h1, true);
					::EnableWindow(h2, false);
					req_off();
				}
			}

			// if once button was clicked
			else if (LOWORD(wParam) == REQ_ONCE_ID)
			{
				::EnableWindow(h1, false);
				::EnableWindow(::GetDlgItem(m_hWnd, REQ_PERIODIC_ID), false);
				tmr_on();
				req_once();
			}

			break;

		case EN_KILLFOCUS:

			// if period edit lost focus
			if (LOWORD(wParam) == REQ_PERIOD_ID)
			{
				req_on = false;
				SetDlgItemInt(REQ_PERIOD_ID, req_check_period(), false);
				req_on = true;
			}
			break;

		case EN_CHANGE:

			// if period in edit field was changed
			if (LOWORD(wParam) == REQ_PERIOD_ID && !req_if_once())
				req_periodic( (INT8U)req_check_period() );
			break;
		}

	return CDialog::OnCommand(wParam, lParam);
}

void CWindow::OnPaint()
{
	dc = ::BeginPaint(m_hWnd, &ps);

	// draw close button
	::BitBlt(dc_title, close_rect.left+2, 4, 9, 9, dc_pic[CLOSE_PIC_ID], 0, 0, SRCCOPY);

	// draw roller button
	::BitBlt(dc_title, 3, 5, 9, 7, dc_pic[ROLLER_PIC_ID], 0, 0, SRCCOPY);

	// draw on window client area
	::BitBlt(dc, 1,1,wndWidth-2,TITLE_BAR_HEIGHT-2, dc_title, 0,0, SRCCOPY);
	
	if (!info_mode && wid == WND_D6)
		;
	else
		::EndPaint(m_hWnd, &ps);
}

LRESULT CWindow::WindowProc(UINT message, WPARAM wParam, LPARAM lParam)
{
	RECT w;
	POINT new_pos;
	int x = LOWORD(lParam);
	int	y = HIWORD(lParam);
	unsigned char old = sbs;

	switch (message)
	{
	case WM_MOUSEMOVE:

		// if need then move window
		if (if_moving)
		{
			GetWindowRect(&w);
			GetCursorPos(&new_pos);
			::SetWindowPos(m_hWnd, 0,
				w.left + (new_pos.x - last_pos.x),
				w.top + (new_pos.y - last_pos.y),
				0, 0,
				SWP_NOZORDER|SWP_NOSIZE);
			last_pos = new_pos;
			return 0;
		}

		// tracking events
		if (!if_tracking)
		{
			if_tracking = true;
			TRACKMOUSEEVENT tme;
			tme.cbSize = sizeof(TRACKMOUSEEVENT);
			tme.dwFlags = TME_LEAVE;
			tme.dwHoverTime = HOVER_DEFAULT;
			tme.hwndTrack = m_hWnd;
			TrackMouseEvent(&tme);
		}

		sbs =
		IF_MOUSE_ON_CLOSE
		?
			IF_ANY_IS_CAPTURED
			?
				IF_CLOSE_IS_CAPTURED
				?
					EQU_CLOSE_MOUSE_DOWN
				:
					EQU_CLOSE_FREE
			:
				EQU_CLOSE_MOUSE_MOVE
		:
			EQU_CLOSE_FREE
		;

		sbs =
		IF_MOUSE_ON_ROLLER
		?
			IF_ANY_IS_CAPTURED
			?
				IF_ROLLER_IS_CAPTURED
				?
					EQU_ROLLER_MOUSE_DOWN
				:
					EQU_ROLLER_FREE
			:
				EQU_ROLLER_MOUSE_MOVE
		:
			EQU_ROLLER_FREE
		;

		if (old != sbs)
			InvalidateRect(&title_rect, 0);

		return 0;

	case WM_MOUSELEAVE:

		sbs = EQU_CLOSE_FREE;
		sbs = EQU_ROLLER_FREE;

		if (old != sbs)
			InvalidateRect(&title_rect, 0);

		if_tracking = false;

		return 0;

	case WM_LBUTTONDOWN:

		if (IF_MOUSE_ON_CLOSE)
		{
			sbs = EQU_CLOSE_MOUSE_DOWN;
			sbs = EQU_CLOSE_CAPTURED;
		}
		else if (IF_MOUSE_ON_ROLLER)
		{
			sbs = EQU_ROLLER_MOUSE_DOWN;
			sbs = EQU_ROLLER_CAPTURED;
		}
		else if (IF_MOUSE_ON_TITLE_BAR && !if_moving)
		{
			if_moving = true;
			last_pos.x = x;
			last_pos.y = y;
			ClientToScreen(&last_pos);
			SetCapture();
			return 0;
		}

		if (old != sbs)
		{
			SetCapture();
			InvalidateRect(&title_rect, 0);
		}

		return 0;

	case WM_LBUTTONDBLCLK:

		if (IF_MOUSE_ON_TITLE_BAR)
			RollUpDown();
		InvalidateRect(&title_rect, 0);
		
		return 0;

	case WM_LBUTTONUP:

		if (if_moving)
		{
			if_moving = false;
			ReleaseCapture();
		}

		if (IF_ANY_IS_CAPTURED)
		{
			ReleaseCapture();

			if ( IF_MOUSE_ON_CLOSE && IF_CLOSE_IS_CAPTURED )
			{
				sbs = EQU_CLOSE_MOUSE_MOVE;
				OnCancel();
				return 0;
			}
			else if ( IF_MOUSE_ON_ROLLER && IF_ROLLER_IS_CAPTURED )
			{	
				sbs = EQU_ROLLER_MOUSE_MOVE;
				RollUpDown();
			}
			
			sbs = EQU_CLOSE_NOT_CAPTURED;
			sbs = EQU_ROLLER_NOT_CAPTURED;
		}

		if (old != sbs)
			InvalidateRect(&title_rect, 0);

		return 0;
	}

	return CDialog::WindowProc(message, wParam, lParam);
}

void CWindow::ini_init(int ivi_count, INI_VALUE_INFO ivi[])
{
	ini_ivi_count = ivi_count;
	ini_ivi = ivi;
}

void CWindow::ini_load()
{
	// window's position
	////////////////////

	int x,y;

	x = theApp.GetProfileInt(ini_section, "x", DEF_XY);
	y = theApp.GetProfileInt(ini_section, "y", DEF_XY);

	if (x == DEF_XY || y == DEF_XY)
		CenterWindow();
	else
		SetWindowPos(0, x,y, 0,0, SWP_NOSIZE|SWP_NOZORDER);


	// user defined values
	//////////////////////

	CString s;

	for (int i=0; i < ini_ivi_count; i++)
		switch (ini_ivi[i].type)
		{
		case INI_TYPE_EDIT:
			SetDlgItemText(ini_ivi[i].id, theApp.GetProfileString(ini_section, ini_ivi[i].key_name));
			break;

		case INI_TYPE_COMBOBOX:
			SendDlgItemMessage(ini_ivi[i].id, CB_SETCURSEL, theApp.GetProfileInt(ini_section, ini_ivi[i].key_name, 0), 0);
			if (SendDlgItemMessage(ini_ivi[i].id, CB_GETCURSEL, 0, 0) < 0)
				SendDlgItemMessage(ini_ivi[i].id, CB_SETCURSEL, 0, 0);
			break;

		case INI_TYPE_CHECKBOX:
			CheckDlgButton(ini_ivi[i].id, theApp.GetProfileInt(ini_section, ini_ivi[i].key_name, 0));
			break;

		case INI_TYPE_GRID_COLUMN:			
			for (int j=0; j < ini_ivi[i].grid->GetRowCount(); j++)
			{
				s.Format(ini_ivi[i].key_name, j);
				ini_ivi[i].grid->SetItemText(j, ini_ivi[i].id, theApp.GetProfileString(ini_section, s));
			}
			
			break;

		case INI_TYPE_RADIOBOX:
			CheckRadioButton(
				LOWORD(ini_ivi[i].id),
				HIWORD(ini_ivi[i].id),
				theApp.GetProfileInt(ini_section, ini_ivi[i].key_name, LOWORD(ini_ivi[i].id))
			);
			break;
		}
	
}

void CWindow::ini_save()
{
	// window's position
	////////////////////

	RECT r;
	GetWindowRect(&r);

	theApp.WriteProfileInt(ini_section, "x", r.left);
	theApp.WriteProfileInt(ini_section, "y", r.top);


	// user defined values
	//////////////////////

	CString s;

	for (int i=0; i < ini_ivi_count; i++)
		switch (ini_ivi[i].type)
		{
		case INI_TYPE_EDIT:
			GetDlgItemText(ini_ivi[i].id, s);
			theApp.WriteProfileString(ini_section, ini_ivi[i].key_name, s);
			break;

		case INI_TYPE_COMBOBOX:
			theApp.WriteProfileInt(ini_section, ini_ivi[i].key_name, (int)SendDlgItemMessage(ini_ivi[i].id, CB_GETCURSEL, 0, 0));
			break;

		case INI_TYPE_CHECKBOX:
			theApp.WriteProfileInt(ini_section, ini_ivi[i].key_name, IsDlgButtonChecked(ini_ivi[i].id));
			break;

		case INI_TYPE_GRID_COLUMN:
			for (int j=0; j < ini_ivi[i].grid->GetRowCount(); j++)
			{
				s.Format(ini_ivi[i].key_name, j);
				theApp.WriteProfileString(ini_section, s, ini_ivi[i].grid->GetItemText(j, ini_ivi[i].id));
			}
			break;

		case INI_TYPE_RADIOBOX:
			theApp.WriteProfileInt(
				ini_section,
				ini_ivi[i].key_name,
				GetCheckedRadioButton(LOWORD(ini_ivi[i].id), HIWORD(ini_ivi[i].id))
			);
			break;
		}
}

void CWindow::rnpi_init(INT8U need, INT8U mask)
{
	// reset state
	rnpi_got = 0;
	rnpi_user_defined = false;

	// save params
	rnpi_mask = mask;

	// if default
	if (need == 0xff)
		need = ds_get_rnpi_need();

	// 0,1,2,3
	if (need < 4)
		rnpi_need = 1 << need;
	// 4
	else if (need == 4)
		rnpi_need = 0x0F;
	// 5
	else
	{
		rnpi_need = mask;
		rnpi_user_defined = true;
	}
}

INT8U CWindow::rnpi_add(INT8U rnpi)
{
	// if it's user defined rnpi (some byte)
	if (rnpi_user_defined)
	{
		rnpi_got = rnpi;
		return rnpi_done();
	}

	// check parameter
	if (rnpi_mask)
		if ((rnpi & 0x0F) != rnpi_mask)
			return 0;

	// check rnpi and keep it
	INT8U r;
	switch (rnpi & 0xF0)
	{
	case 0x00: r = 1; break;
	case 0x10: r = 2; break;
	case 0x20: r = 4; break;
	case 0x40: r = 8; break;
	default: return 0;
	}

	if (rnpi_need == 0x0F)
		rnpi_got |= r;
	else
		if (r != rnpi_need)
			return 0;
		else
			rnpi_got = r;

	return r;
}

bool CWindow::rnpi_done()
{
	return rnpi_got == rnpi_need;
}

bool CWindow::rnpi_done_as(INT8U rnpi)
{
	return rnpi_got == rnpi;
}

void CWindow::ds_init(INT8U *dev_list)
{
	ds_list = dev_list;
}

INT8U CWindow::ds_get()
{
	return ds_list[device];
}

INT8U CWindow::ds_get_rnpi_need()
{
	return
		(ds_get() > 0x40)
		?
			4
		:
			(ds_get() < 0x40)
			?
				ds_get() >> 4
			:
				3
		;
}