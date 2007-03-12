#include "stdafx.h"


HANDLE module;
long svr_locks;
CAverageClassFactory acf;


BOOL __stdcall DllMain(HANDLE hModule, DWORD ul_reason_for_call, LPVOID lpReserved)
{
	if (ul_reason_for_call == DLL_PROCESS_ATTACH)
		module = hModule;
	
    return TRUE;
}

STDAPI DllRegisterServer()
{
	#define CHECK_ERR(c) if(c != ERROR_SUCCESS) return SELFREG_E_CLASS;

	char module_filename[MAX_PATH + 1];
	GetModuleFileName((HMODULE)module, module_filename, MAX_PATH);

	HKEY key;

	CHECK_ERR( RegCreateKey(HKEY_CLASSES_ROOT, "CLSID\\{51D86720-C3D4-4F5B-AB3A-EA14C9BCA7A3}", &key) );
	CHECK_ERR( RegSetValue(key, "InprocServer32", REG_SZ, module_filename, (signed)strlen(module_filename)) );
	RegCloseKey(key);

	return S_OK;
	
	#undef CHECK_ERR
}

STDAPI DllUnregisterServer()
{
	RegDeleteKey(HKEY_CLASSES_ROOT, "CLSID\\{51D86720-C3D4-4F5B-AB3A-EA14C9BCA7A3}\\InprocServer32");
	RegDeleteKey(HKEY_CLASSES_ROOT, "CLSID\\{51D86720-C3D4-4F5B-AB3A-EA14C9BCA7A3}");

	return S_OK;
}

STDAPI DllCanUnloadNow()
{
	return svr_locks ? S_FALSE : S_OK;
}

STDAPI DllGetClassObject(REFCLSID clsid, REFIID iid, void **ppv)
{
	*ppv = 0;

	if (clsid == CLSID_Average)
		return acf.QueryInterface(iid, ppv);

	return CLASS_E_CLASSNOTAVAILABLE;
}