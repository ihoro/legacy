#include "StdAfx.h"
#include "avg_local.h"


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

#ifdef REFS_DEBUG

	_trace_sz("++ CAverageClassFactory::refs = ");
	_trace_int(refs+1);
	_trace_nl();

#endif

	INC(refs);

	return refs;
}

ULONG __stdcall CAverageClassFactory::Release()
{

#ifdef REFS_DEBUG

	_trace_sz("-- CAverageClassFactory::refs = ");
	_trace_int(refs-1);
	_trace_nl();

#endif

	DEC(refs);

	return refs;
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
		locks_inc();
	else
		locks_dec();

	return S_OK;
}