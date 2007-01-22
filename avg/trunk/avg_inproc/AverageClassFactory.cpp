#include "StdAfx.h"


HRESULT __stdcall CAverageClassFactory::QueryInterface(REFIID iid, void **ppv)
{
	*ppv = 0;

	// IUnknown
	if (iid == IID_IUnknown)
		*ppv = (IUnknown*)this;

	// IClassFactory
	else if (iid == IID_IClassFactory)
		*ppv = (IClassFactory*)this;

	else
		return E_NOINTERFACE;

	AddRef();

    return S_OK;
}

ULONG __stdcall CAverageClassFactory::AddRef()
{
	return InterlockedIncrement(&refs);
}

ULONG __stdcall CAverageClassFactory::Release()
{
	return InterlockedDecrement(&refs);
}

HRESULT __stdcall CAverageClassFactory::CreateInstance(IUnknown *pUnkOuter, REFIID iid, void **ppv)
{
	*ppv = 0;

	if (pUnkOuter)
		return CLASS_E_NOAGGREGATION;

	// create object
	CAverage *p = new CAverage();
	if (p == 0)
		return E_OUTOFMEMORY;

	// select interface
	HRESULT hr = p->QueryInterface(iid, ppv);
	if ( FAILED(hr) )
		delete p;

	return hr;
}

HRESULT __stdcall CAverageClassFactory::LockServer(BOOL fLock)
{
	if (fLock)
		InterlockedIncrement(&svr_locks);
	else
		InterlockedDecrement(&svr_locks);

	return S_OK;
}