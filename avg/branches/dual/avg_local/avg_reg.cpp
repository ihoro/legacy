// component and its suite registration

#include "StdAfx.h"
#include "avg_local.h"


char avg_friendly_id[] = "Average Sum Calculations";
char avg_prog_id[] = "Avg.Average.1";
char avg_vi_prog_id[] = "Avg.Average";


#define CERR(exp)	if ((exp) != ERROR_SUCCESS)																			\
						{																								\
							MessageBox(0, "Some registry entry hasn't been added.", "avg.exe", MB_OK|MB_ICONERROR);		\
							return true;																				\
						}


bool avg_registration(char *cmd)
{
	bool reg = false;
	HRESULT hr;

	// check silent param
	bool silent = (strstr(cmd, "silent") != 0);

	// register
	if (strstr(cmd, "regserver"))
	{
		char fn[MAX_PATH + 1];
		GetModuleFileName(0, fn, MAX_PATH);

		HKEY key;

		// CLSID
		CERR( RegCreateKey(HKEY_CLASSES_ROOT, "CLSID\\{51D86720-C3D4-4F5B-AB3A-EA14C9BCA7A3}", &key) );
		CERR( RegSetValue(key, 0, REG_SZ, avg_friendly_id, (int)strlen(avg_friendly_id)) );
		CERR( RegSetValue(key, "LocalServer32", REG_SZ, fn, (int)strlen(fn)) );
		CERR( RegSetValue(key, "ProgID", REG_SZ, avg_prog_id, (int)strlen(avg_prog_id)) );
		CERR( RegSetValue(key, "VersionIndependentProgID", REG_SZ, avg_vi_prog_id, (int)strlen(avg_vi_prog_id)) );
		CERR( RegSetValue(key, "TypeLib", REG_SZ, "{8290EF07-5F64-4366-B76C-666B33AEFE6C}", 38) );
		RegCloseKey(key);

		// ProgID
		CERR( RegCreateKey(HKEY_CLASSES_ROOT, avg_prog_id, &key) );
		CERR( RegSetValue(key, "CLSID", REG_SZ, "{51D86720-C3D4-4F5B-AB3A-EA14C9BCA7A3}", 38) );
		RegCloseKey(key);

		// VersionIndependentProgID
		CERR( RegCreateKey(HKEY_CLASSES_ROOT, avg_vi_prog_id, &key) );
		CERR( RegSetValue(key, "CLSID", REG_SZ, "{51D86720-C3D4-4F5B-AB3A-EA14C9BCA7A3}", 38) );
		CERR( RegSetValue(key, "CurVer", REG_SZ, avg_prog_id, (int)strlen(avg_prog_id)) );
		RegCloseKey(key);

		// TypeLib
		wchar_t tl_fn[MAX_PATH + 1];
		MultiByteToWideChar(CP_UTF8, 0, fn, (int)strlen(fn) + 1, tl_fn, MAX_PATH + 1);
		ITypeLib *p;
		hr = LoadTypeLibEx(tl_fn, REGKIND_REGISTER, &p);
		p->GetTypeInfoOfGuid(IID_IAverage, &type_info);
		p->Release();
		if (FAILED(hr))
			MessageBox(0, "Can't register type library.", "avg.exe", MB_OK|MB_ICONERROR);

		reg = true;
	}

	// unregister
	else if (strstr(cmd, "unregserver"))
	{
		// TypeLib
		hr = UnRegisterTypeLib(LIBID_AverageLib, 1, 0, 0, SYS_WIN32);
		if (FAILED(hr))
			MessageBox(0, "Can't unregister type library.", "avg.exe", MB_OK|MB_ICONERROR);

		// VersionIndependentProgID
		char buf[512];
		strcpy(buf, avg_vi_prog_id);
		strcat(buf, "\\CLSID");
		RegDeleteKey(HKEY_CLASSES_ROOT, buf);
		buf[strlen(avg_vi_prog_id)] = 0;
		strcat(buf, "CurVer");
		RegDeleteKey(HKEY_CLASSES_ROOT, buf);
		buf[strlen(avg_vi_prog_id)] = 0;
		RegDeleteKey(HKEY_CLASSES_ROOT, buf);

		// ProgID
		strcpy(buf, avg_prog_id);
		strcat(buf, "\\CLSID");
		RegDeleteKey(HKEY_CLASSES_ROOT, buf);
		buf[strlen(avg_prog_id)] = 0;
		RegDeleteKey(HKEY_CLASSES_ROOT, buf);

		// CLSID
		RegDeleteKey(HKEY_CLASSES_ROOT, "CLSID\\{51D86720-C3D4-4F5B-AB3A-EA14C9BCA7A3}\\TypeLib");
		RegDeleteKey(HKEY_CLASSES_ROOT, "CLSID\\{51D86720-C3D4-4F5B-AB3A-EA14C9BCA7A3}\\VersionIndependentProgID");
		RegDeleteKey(HKEY_CLASSES_ROOT, "CLSID\\{51D86720-C3D4-4F5B-AB3A-EA14C9BCA7A3}\\ProgID");
		RegDeleteKey(HKEY_CLASSES_ROOT, "CLSID\\{51D86720-C3D4-4F5B-AB3A-EA14C9BCA7A3}\\LocalServer32");
		RegDeleteKey(HKEY_CLASSES_ROOT, "CLSID\\{51D86720-C3D4-4F5B-AB3A-EA14C9BCA7A3}");
		
		reg = true;
	}

	if (reg && !silent)
		MessageBox(0, "Succeeded.", "avg.exe", MB_OK|MB_ICONINFORMATION);

	return reg;
}