#include "StdAfx.h"
#include "avg_local.h"


HRESULT __stdcall CAverage::QueryInterface(REFIID iid, void **ppv)
{
	*ppv = 0;

	// IUnknown
	if (iid == IID_IUnknown)
		*ppv = (IUnknown*)this;

	// IDispatch
	else if (iid == IID_IDispatch)
		*ppv = (IDispatch*)this;

	// IAverage
	else if (iid == IID_IAverage)
		*ppv = (IAverage*)this;

	else
		return E_NOINTERFACE;

	AddRef();

	return S_OK;
}

ULONG __stdcall CAverage::AddRef()
{

#ifdef REFS_DEBUG

	_trace_sz("++ [");
	_trace_int((int)this);
	_trace_sz("] CAverage::refs = ");
	_trace_int(refs+1);
	_trace_nl();

#endif

	return InterlockedIncrement(&refs);
}

ULONG __stdcall CAverage::Release()
{

#ifdef REFS_DEBUG

	_trace_sz("-- [");
	_trace_int((int)this);
	_trace_sz("] CAverage::refs = ");
	_trace_int(refs-1);
	_trace_nl();

#endif

	if (InterlockedDecrement(&refs) == 0)
	{
		delete this;
		return 0;
	}

	return refs;
}

HRESULT __stdcall CAverage::GetTypeInfoCount(UINT *pctinfo)
{
	*pctinfo = 1;
	return NO_ERROR;
}

HRESULT __stdcall CAverage::GetTypeInfo(UINT itinfo, LCID lcid, ITypeInfo **pptinfo)
{
	*pptinfo = 0;

	if (itinfo)
		return DISP_E_BADINDEX;
	
	type_info->AddRef();
	*pptinfo = type_info;
	return NOERROR;
}

HRESULT __stdcall CAverage::GetIDsOfNames(REFIID riid, LPOLESTR *rgszNames, UINT cNames, LCID lcid, DISPID *rgdispid)
{
	return DispGetIDsOfNames(type_info, rgszNames, cNames, rgdispid);
}

HRESULT __stdcall CAverage::Invoke(DISPID dispidMember, REFIID riid, LCID lcid, WORD wFlags, DISPPARAMS *pdispparams, VARIANT *pvarResult, EXCEPINFO *pexcepinfo, UINT *puArgErr)
{
	return DispInvoke(this, type_info, dispidMember, wFlags, pdispparams, pvarResult, pexcepinfo, puArgErr);
}

HRESULT __stdcall CAverage::CalcAverage(int *array, int array_len, int *avg)
{
	*avg = 0;
	for (int i=0; i < array_len; i++)
		*avg += array[i];
	*avg /= array_len;

	return S_OK;
}

HRESULT __stdcall CAverage::CalcAverageFromString(INT8U *str, INT8U sep, int *avg)
{
	char *our = (char*)malloc(strlen((char*)str) + 1);
	memcpy(our, str, strlen((char*)str) + 1);

	int *array = 0;
	unsigned len = 0;
	char *base = our, *cur = 0;

	while ( (cur = strchr(base, sep)) || strlen(base) > 0)
	{
		if (cur)
			*cur = 0;
		len++;
		array = (int*)realloc(array, len*sizeof(int));
		array[len-1] = atoi(base);
		if (cur)
			base = cur + 1;
		else
			*base = 0;
	}

	HRESULT hr = CalcAverage(array, len, avg);

	free(array);
	free(our);

	return hr;
}