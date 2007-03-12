#pragma once


class CAverageClassFactory : public IClassFactory
{
public: // for status :)
	long refs;

public:

	CAverageClassFactory() : refs(0) {};

	// IUnknown
	virtual HRESULT __stdcall QueryInterface(REFIID iid, void **ppv);
	virtual ULONG __stdcall AddRef();
	virtual ULONG __stdcall Release();

	// IClassFactory
	virtual HRESULT __stdcall CreateInstance(IUnknown *pUnkOuter, REFIID iid, void **ppv);
	virtual HRESULT __stdcall LockServer(BOOL fLock);
};
