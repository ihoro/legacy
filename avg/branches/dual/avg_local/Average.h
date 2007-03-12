#pragma once


class CAverage : public IAverage
{
private:
	long refs;

public:
	CAverage() : refs(0) { locks_inc(); obj_inc(); }
	~CAverage() { locks_dec(); obj_dec(); }

	// IUnknown
	virtual HRESULT __stdcall QueryInterface(REFIID iid, void **ppv);
	virtual ULONG __stdcall AddRef();
	virtual ULONG __stdcall Release();

	// IDispatch
	virtual HRESULT __stdcall GetTypeInfoCount(UINT *pctinfo);
	virtual HRESULT __stdcall GetTypeInfo(UINT itinfo, LCID lcid, ITypeInfo **pptinfo);
	virtual HRESULT __stdcall GetIDsOfNames(REFIID riid, LPOLESTR *rgszNames, UINT cNames, LCID lcid, DISPID *rgdispid);
	virtual HRESULT __stdcall Invoke(DISPID dispidMember, REFIID riid, LCID lcid, WORD wFlags, DISPPARAMS *pdispparams, VARIANT *pvarResult, EXCEPINFO *pexcepinfo, UINT *puArgErr);

	// IAverage
	virtual HRESULT __stdcall CalcAverage(int *array, int array_len, int *avg);
	virtual HRESULT __stdcall CalcAverageFromString(INT8U *str, INT8U sep, int *avg);
};
