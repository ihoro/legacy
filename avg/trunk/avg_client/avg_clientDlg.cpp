// avg_clientDlg.cpp : implementation file
//

#include "stdafx.h"
#include "avg_client.h"
#include "avg_clientDlg.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#endif


// Cavg_clientDlg dialog



Cavg_clientDlg::Cavg_clientDlg(CWnd* pParent /*=NULL*/)
	: CDialog(Cavg_clientDlg::IDD, pParent),
	pcf(0),
	pobj(0),
	obj_count(0)
{
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
}

Cavg_clientDlg::~Cavg_clientDlg()
{
	free(pobj);
}

void Cavg_clientDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
}

BEGIN_MESSAGE_MAP(Cavg_clientDlg, CDialog)
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	//}}AFX_MSG_MAP
	ON_BN_CLICKED(IDC_CALC, OnBnClickedCalc)
	ON_BN_CLICKED(IDC_CREATE_OBJECT, OnBnClickedCreateObject)
	ON_BN_CLICKED(IDC_FREE_OBJECT, OnBnClickedFreeObject)
	ON_BN_CLICKED(IDC_GET_CLASS_OBJECT, OnBnClickedGetClassObject)
	ON_BN_CLICKED(IDC_CO_RELEASE, OnBnClickedCoRelease)
	ON_BN_CLICKED(IDC_BUTTON2, OnBnClickedButton2)
END_MESSAGE_MAP()


// Cavg_clientDlg message handlers

BOOL Cavg_clientDlg::OnInitDialog()
{
	CDialog::OnInitDialog();

	// Set the icon for this dialog.  The framework does this automatically
	//  when the application's main window is not a dialog
	SetIcon(m_hIcon, TRUE);			// Set big icon
	SetIcon(m_hIcon, FALSE);		// Set small icon

	// TODO: Add extra initialization here
	CheckRadioButton(IDC_INPROC, IDC_LOCAL, IDC_INPROC);
	SetDlgItemText(IDC_SEQ, "2,1,-1,10,0,-10,-2");
	
	return TRUE;  // return TRUE  unless you set the focus to a control
}

// If you add a minimize button to your dialog, you will need the code below
//  to draw the icon.  For MFC applications using the document/view model,
//  this is automatically done for you by the framework.

void Cavg_clientDlg::OnPaint() 
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
HCURSOR Cavg_clientDlg::OnQueryDragIcon()
{
	return static_cast<HCURSOR>(m_hIcon);
}

void Cavg_clientDlg::OnBnClickedGetClassObject()
{
	// recognize context
	DWORD ctx = CLSCTX_INPROC_SERVER;
	if (GetCheckedRadioButton(IDC_INPROC, IDC_LOCAL) == IDC_LOCAL)
		ctx = CLSCTX_LOCAL_SERVER;

	// get class object
	HRESULT hr = CoGetClassObject(CLSID_Average, ctx, 0, IID_IClassFactory, (void**)&pcf);
	if (FAILED(hr))
		MessageBox("Failed!", "Error", MB_OK|MB_ICONERROR);
	else
	{
		ENABLE_ITEM(IDC_INPROC, false);
		ENABLE_ITEM(IDC_LOCAL, false);
		ENABLE_ITEM(IDC_GET_CLASS_OBJECT, false);
		ENABLE_ITEM(IDC_CO_RELEASE, true);
		ENABLE_ITEM(IDC_CREATE_OBJECT, true);
	}
}

void Cavg_clientDlg::OnBnClickedCoRelease()
{
	pcf->Release();

	ENABLE_ITEM(IDC_INPROC, true);
	ENABLE_ITEM(IDC_LOCAL, true);
	ENABLE_ITEM(IDC_GET_CLASS_OBJECT, true);
	ENABLE_ITEM(IDC_CO_RELEASE, false);
	ENABLE_ITEM(IDC_CREATE_OBJECT, false);
}

void Cavg_clientDlg::OnBnClickedCreateObject()
{
	// create object and get its interface
	IAverage *p;
	HRESULT hr = pcf->CreateInstance(0, IID_IAverage, (void**)&p);

	// if no link
	if (FAILED(hr))
	{
		MessageBox("Failed!", "Error", MB_OK|MB_ICONERROR);
		return;
	}
	else
	{
		obj_count++;
		pobj = (IUnknown**)realloc(pobj, sizeof(IUnknown*) * obj_count);
		pobj[obj_count-1] = p;	

		CString s;
		s.Format(" Objects count: %lu", obj_count);
		SetDlgItemText(IDC_OBJECTS, s);

		ENABLE_ITEM(IDC_FREE_OBJECT, true);
		ENABLE_ITEM(IDC_CALC, true);
	}
}

void Cavg_clientDlg::OnBnClickedFreeObject()
{
	pobj[--obj_count] -> Release();

	CString s;
	s.Format(" Objects count: %lu", obj_count);
	SetDlgItemText(IDC_OBJECTS, s);

	ENABLE_ITEM(IDC_FREE_OBJECT, obj_count != 0);
	ENABLE_ITEM(IDC_CALC, obj_count != 0);
}

void Cavg_clientDlg::OnBnClickedCalc()
{
	// get input string
	CString s;
	GetDlgItemText(IDC_SEQ, s);

	// calc avg sum
	int avg;
	( (IAverage*) (pobj[obj_count-1]) ) -> CalcAverageFromString((unsigned char*)s.GetBuffer(), ',', &avg);

	// show result
	SetDlgItemInt(IDC_RESULT, avg);
}

void Cavg_clientDlg::OnBnClickedButton2()
{
	EndDialog(0);
}
