#pragma once


class CAverage : public IAverage
{
private:
	long refs;

public:
	CAverage() : refs(0) { InterlockedIncrement(&svr_locks); }
	~CAverage() { InterlockedDecrement(&svr_locks); }

	// IUnknown
	virtual HRESULT __stdcall QueryInterface(REFIID iid, void **ppv);
	virtual ULONG __stdcall AddRef();
	virtual ULONG __stdcall Release();

	// IAverage
	virtual HRESULT __stdcall CalcAverage(int *array, int array_len, int *avg);
	virtual HRESULT __stdcall CalcAverageFromString(INT8U *str, INT8U sep, int *avg);
};
