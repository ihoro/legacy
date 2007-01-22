// stp_clientDlg.cpp : implementation file
//

#include "stdafx.h"
#include "stp_client.h"
#include "stp_clientDlg.h"
#include ".\stp_clientdlg.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#endif


// Cstp_clientDlg dialog



Cstp_clientDlg::Cstp_clientDlg(CWnd* pParent /*=NULL*/)
	: CDialog(Cstp_clientDlg::IDD, pParent)
{
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
}

void Cstp_clientDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
}

BEGIN_MESSAGE_MAP(Cstp_clientDlg, CDialog)
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	//}}AFX_MSG_MAP
	ON_BN_CLICKED(IDC_CONNECT, OnBnClickedConnect)
	ON_BN_CLICKED(IDC_BUTTON1, OnBnClickedButton1)
END_MESSAGE_MAP()


// Cstp_clientDlg message handlers

BOOL Cstp_clientDlg::OnInitDialog()
{
	CDialog::OnInitDialog();

	// Set the icon for this dialog.  The framework does this automatically
	//  when the application's main window is not a dialog
	SetIcon(m_hIcon, TRUE);			// Set big icon
	SetIcon(m_hIcon, FALSE);		// Set small icon

	// TODO: Add extra initialization here
	SetDlgItemText(IDC_ADDRESS, "127.0.0.1");
	
	return TRUE;  // return TRUE  unless you set the focus to a control
}

// If you add a minimize button to your dialog, you will need the code below
//  to draw the icon.  For MFC applications using the document/view model,
//  this is automatically done for you by the framework.

void Cstp_clientDlg::OnPaint() 
{
	if (IsIconic())
	{
		CPaintDC dc(this); // device context for painting

		SendMessage(WM_ICONERASEBKGND, reinterpret_cast<WPARAM>(dc.GetSafeHdc()), 0);

		// Center icon in client rectangle
		int cxIcon = GetSystemMetrics(SM_CXICON);
		int cyIcon = GetSystemMetrics(SM_CYICON);
		CRect rect;
		GetClientRect(&rect);
		int x = (rect.Width() - cxIcon + 1) / 2;
		int y = (rect.Height() - cyIcon + 1) / 2;

		// Draw the icon
		dc.DrawIcon(x, y, m_hIcon);
	}
	else
	{
		CDialog::OnPaint();
	}
}

// The system calls this function to obtain the cursor to display while the user drags
//  the minimized window.
HCURSOR Cstp_clientDlg::OnQueryDragIcon()
{
	return static_cast<HCURSOR>(m_hIcon);
}

void Cstp_clientDlg::OnBnClickedConnect()
{
	CString inf;
	GetDlgItemText(IDC_INFO, inf);

 	if ( (sock = socket(AF_INET, SOCK_STREAM, 0)) == INVALID_SOCKET )
	{
		inf += "ERR: socket\r\n";
		SetDlgItemText(IDC_INFO, inf);
		return;
	}
	if (WSAAsyncSelect(sock, m_hWnd, WM_SOCKET, FD_CONNECT|FD_CLOSE|FD_READ) == SOCKET_ERROR)
	{
		inf += "ERR: WSAAsyncSelect\r\n";
		SetDlgItemText(IDC_INFO, inf);
		return;
	}
	sockaddr_in sin;
	sin.sin_family = AF_INET;
	sin.sin_port = htons(9001);
	CString s;
	GetDlgItemText(IDC_ADDRESS, s);
	sin.sin_addr.s_addr = inet_addr(s);
	if (connect(sock, (SOCKADDR*)&sin, sizeof(sin)) == SOCKET_ERROR)
		;
	/*{
		s.Format("%d", WSAGetLastError());
		inf += "ERR: connect,  WSAGetLastError() =" + s + "\r\n";
		SetDlgItemText(IDC_INFO, inf);
		return;
	}
		   10035*/

}

LRESULT Cstp_clientDlg::WindowProc(UINT message, WPARAM wParam, LPARAM lParam)
{
	CString inf, b;
	GetDlgItemText(IDC_INFO, inf);

	b.GetBufferSetLength(1003);
	char buf[] = "HELO STPClient/0.1\x0D\x0A";

	if (message == WM_SOCKET)
		switch (LOWORD(lParam))
		{
		case FD_CONNECT: 
			inf += "connected\r\n";
			SetDlgItemText(IDC_INFO, inf);
			send(sock, buf, strlen(buf), 0);
			break;

		case FD_READ:
			int i = recv(sock, b.GetBuffer(), 1002, 0);
			b.SetAt(i, 0);
			inf += b;
			SetDlgItemText(IDC_INFO, inf);
			break;
		}

	return CDialog::WindowProc(message, wParam, lParam);
}

void Cstp_clientDlg::OnBnClickedButton1()
{
	CString s;
	GetDlgItemText(IDC_EDIT1, s);
	s += "\x0D\x0A";
	send(sock, s.GetBuffer(), s.GetLength(), 0);
}
