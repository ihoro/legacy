// $Id$

#include "stdafx.h"
#include "bnu_ctrl.h"


// CWindowB8 dialog

INI_VALUE_INFO ivi_B8[] =
{
	{"address",		INI_TYPE_EDIT,	IDC_B8_ADDRESS, 0},
	{"bytes_count",	INI_TYPE_EDIT,	IDC_B8_BYTES_COUNT, 0}
};

IMPLEMENT_DYNAMIC(CWindowB8, CWindow)
CWindowB8::CWindowB8(CWnd* pParent, PROCCLOSE procClose, char wndID)
	: CWindow(procClose, wndID)
{
	Create(IDD, pParent);
}

CWindowB8::~CWindowB8()
{
}

void CWindowB8::DoDataExchange(CDataExchange* pDX)
{
	CWindow::DoDataExchange(pDX);
}


BEGIN_MESSAGE_MAP(CWindowB8, CWindow)
	ON_BN_CLICKED(IDC_B8_RESET, OnBnClickedB8Reset)
END_MESSAGE_MAP()


// CWindowB8 message handlers

BOOL CWindowB8::OnInitDialog()
{
	// specify settings
	ini_init(2, ivi_B8);

	// init edits
	SendDlgItemMessage(IDC_B8_ADDRESS, EM_LIMITTEXT, 4, 0);
	SendDlgItemMessage(IDC_B8_BYTES_COUNT, EM_LIMITTEXT, 3, 0);

	CWindow::OnInitDialog();

	return TRUE;
}

void CWindowB8::OnBnClickedB8Reset()
{
	// get address
	CString s;
	GetDlgItemText(IDC_B8_ADDRESS, s);
	FixHEXStr(s.GetBuffer());
	SetDlgItemText(IDC_B8_ADDRESS, s);
	int address = (INT16U)HEXStrToInt(s.GetBuffer());

	// get bytes count
	int count = GetDlgItemInt(IDC_B8_BYTES_COUNT, 0, false);
	if (count > 255)
		count = 255;
	SetDlgItemInt(IDC_B8_BYTES_COUNT, count, false);

	// send
	size = bcp->MakePacket(p, 0xB8, (INT16U)address, (INT8U)count);
	sendp();
}
