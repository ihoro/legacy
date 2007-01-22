// mkupd.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include "resource.h"

struct FILEMAP
{
	HANDLE file;
	HANDLE map;
	LPVOID mem;
	char *p;					// base pointer to file data
	char *p_end;				// pointer to last byte of file
	int size;					// size of file
	char CRC;					// CRC of file
};

struct RCDATA
{
	HMODULE hExe;
	HRSRC hRes;
	HGLOBAL hResLoad;
	char *lpResLock;			// pointer to data
	LPCSTR ID;					// res id
	int size;					// size of res in bytes
};


#define IDR_UFILE_RCDATA 1		// res. ID in update file

FILEMAP of, nf, uf;				// old file, new file, update file
char *bp;						// base memory pointer
char uf_name[2048];				// update file path name


bool fileCreate(char *filePathName, FILEMAP &f)
{
	f.file = CreateFile(filePathName, GENERIC_READ|GENERIC_WRITE, 0, 0, CREATE_ALWAYS, 0, 0);
	if (f.file == INVALID_HANDLE_VALUE)
		return false;

	return true;
}

void fileFill(FILEMAP &f, char c, int count)
{
	char buf[] = {c};
	int cSet;

	for (int i=0; i<count; i++)
		WriteFile(f.file, buf, 1, (LPDWORD)&cSet, 0);
}

bool fileOpen(char *fileName, FILEMAP &f)
{
	f.file = CreateFile(fileName, GENERIC_READ|GENERIC_WRITE, 0, 0, OPEN_EXISTING, 0, 0);
	if (f.file == INVALID_HANDLE_VALUE)
		return false;

	f.map = CreateFileMapping(f.file, 0, PAGE_READWRITE, 0, 0, 0);
	if (f.map == NULL)
		return false;

	f.mem = MapViewOfFile(f.map, FILE_MAP_WRITE, 0, 0, 0);
	if (f.mem == NULL)
		return false;

	f.p = (char*)f.mem;
	f.size = GetFileSize(f.file, NULL);
	f.p_end = f.p + f.size - 1;
	f.CRC = 0;

	return true;
}

void fileClose(FILEMAP &f)
{
	UnmapViewOfFile(f.mem);
	CloseHandle(f.map);
	f.map = 0;
	CloseHandle(f.file);
}

void fileGetName(char *s, char *fileName, int &len)
{
	char *start = fileName;

	for (len = 0; *s; s++)
		if (*s == '\\')
		{
			fileName = start;
			len = 0;
		}
		else
		{
			*fileName++ = *s;
			len++;
		}

	*fileName = 0;
}

/*char* fileGetExt(char *s, int &len)
{
	char *ext = 0;

	for (len = 0; *s; s++)
	{
		if (*s == '.')
		{
			ext = s;
			len = 1;
		}
		else if (*s == '\\')
			ext = 0;
		else if (ext)
			len++;
	}

	return ext;
}*/

void fileGetTimeFmt(FILEMAP &f, char *s, char *fmt = 0)
{
	FILETIME ft;
	SYSTEMTIME st;
	TIME_ZONE_INFORMATION tzi;

	GetTimeZoneInformation(&tzi);
	GetFileTime(f.file, 0, 0, &ft);
	FileTimeToSystemTime(&ft, &st);

	if (!fmt)
		wsprintf(s, "%.2d.%.2d.%.4d %.2d:%.2d:%.2d %c%.2d%.2d",
			st.wDay, st.wMonth, st.wYear, st.wHour, st.wMinute, st.wSecond,
			(tzi.Bias > 0) ? '-' : '+',
			(int)(abs(tzi.Bias + tzi.DaylightBias) / 60),
			abs(tzi.Bias + tzi.DaylightBias) % 60);
	else
		wsprintf(s, fmt,
			st.wYear, st.wMonth, st.wDay, st.wHour, st.wMinute, st.wSecond,
			(tzi.Bias > 0) ? '-' : '+',
			(int)(abs(tzi.Bias + tzi.DaylightBias) / 60),
			abs(tzi.Bias + tzi.DaylightBias) % 60);
}

bool resOpen(RCDATA &r)
{
	if
	(
		(r.hRes = FindResource(r.hExe, r.ID, RT_RCDATA)) &&
		(r.hResLoad = LoadResource(r.hExe, r.hRes)) &&
		(r.lpResLock = (char*)LockResource(r.hResLoad))
	)
	{
		r.size = SizeofResource(r.hExe, r.hRes);
		return true;
	}
	else
		return false;
}

void Save24Bits(char *p, int value)
{
	p[0] = (char)( value & 0x000000FF );
	p[1] = (char)( (value & 0x0000FF00) >> 8 );
	p[2] = (char)( (value & 0x00FF0000) >> 16 );
}

int ea(int err)		// exit actions
{
	switch (err)
	{
	case 1:
		std::cout
			<< "\nUpdater24x v0.0 Maker by fnt0m32 'at' gmail.com\n\n"
			<< "Usage: mkupd.exe <old file> <new file>\n\n"
			<< "- old file - previous file version\n"
			<< "- new file - new file version\n\n"
			<< "output: exe-file with name of following format:\n"
			<< "        <old file name>_update_yyyymmddhhmmssSHHMM.exe\n\n"
			<< "Note: maximum size of old/new files is 16,777,215 bytes.\n";
		return err;
	case 2:
		std::cout << "ERROR: could not open/create file(s).";
		break;
	case 3:
		std::cout << "ERROR: could not open own RCDATA.";
		break;
	case 4:
		std::cout << "ERROR: some file(s) has null size.";
		break;
	case 5:
		std::cout << "ERROR: could not insert update information into update file.";
		break;
	case 6:
		std::cout << "ERROR: could not write update information to update file.";
		break;
	}

	fileClose(of);
	fileClose(nf);
	fileClose(uf);

	free(bp);

	return err;
}



int _tmain(int argc, _TCHAR* argv[])
{
	// check arguments
	if (argc < 3)
		return ea(1);

	// open own RCDATA for read
	RCDATA r;
	r.hExe = GetModuleHandle(NULL);
	r.ID = (LPCSTR)IDR_UPDATER;
	if ( !resOpen(r) )
		return ea(3);
	
	// open old/new files
	if ( !(fileOpen(argv[1], of) && fileOpen(argv[2], nf)) )
		return ea(2);

	// create update file
	memcpy(uf_name, argv[1], strlen(argv[1]));
	fileGetTimeFmt(nf, uf_name + strlen(argv[1]),
		"_update_%.4d%.2d%.2d%.2d%.2d%.2d%c%.2d%.2d.exe");
	if ( !fileCreate(uf_name, uf) )
		return ea(2);

	// check for null size
	if ( of.size == 0 || nf.size == 0)
		return ea(4);

	// prepare update file
	fileFill(uf, 0, r.size);
	fileClose(uf);
	if ( !fileOpen(uf_name, uf) )
		return ea(2);

	// write own RCDATA to update file
	memcpy(uf.p, r.lpResLock, r.size);
	fileClose(uf);

	
	////////////////////////////
	// create update information
	////////////////////////////

	int co;								// current memory offset against bp
	int ms;								// used memory size
	int of_CRC_offset;					// offset to CRC of old file, against bp
	int nf_CRC_offset;					// offset to CRC of new file, against bp
	int cc;								// corrections count
	int cc_offset;						// offset to corrections count, against bp

	// old file name
	char fn[256];						// temporary buffer
	int len;
	fileGetName(argv[1], fn, len);
	bp = (char*)malloc(ms = len + 1 + 72); // +dword(size) +byte(CRC) +25bytes(time) +dword(size) +byte(CRC) +25bytes(time) +8bytes(FILETIME) +dword(corr. count)
	memcpy(bp, fn, len + 1);
	
	// old file size
	co = len + 1;						// offset to dword
	*(int*)(bp + co) = of.size;

	// old file CRC
	of_CRC_offset = co + 4;				// save offset to of_CRC
	co += 5;							// offset to old file time

	// old file time
	fileGetTimeFmt(of, fn);
	memcpy(bp + co, fn, 25);
	co += 25;							// offset to new file size

	// new file size
	*(int*)(bp + co) = nf.size;

	// new file CRC
	nf_CRC_offset = co + 4;				// save offset to nf_CRC
	co += 5;							// offset to new file time

	// new file time
	fileGetTimeFmt(nf, fn);
	memcpy(bp + co, fn, 25);
	co += 25;							// offset to new file time as FILETIME structure
	
	// new file time as FILETIME
	FILETIME ft;
	GetFileTime(nf.file, 0, 0, &ft);
	*(int*)(bp + co) = ft.dwLowDateTime;
	*(int*)(bp + co + 4) = ft.dwHighDateTime;
	co += 8;							// offset to corrections count

	// corrections count
	cc_offset = co;
	cc = 0;								// no corrections
	co += 4;							// offset to first correction


	// search differences and create corrections
	////////////////////////////////////////////

	int bc;								// bytes count
	int bc_offset;						// offset to bytes count, against bp
	bool first = true;					// if it's first occurrence of difference
	int i = 0;

	for (; i < nf.size; i++)
	{
		char OldByte;

		// calc CRC and check if old file is smaller then new file
		nf.CRC ^= nf.p[i];
		if ( of.p + i > of.p_end )
			OldByte = nf.p[i] + 1;
		else
		{
			of.CRC ^= of.p[i];
			OldByte = of.p[i];
		}

		// check differences
		if ( nf.p[i] != OldByte )
		{
			// create new correction
			if (first)
			{
				first = false;
				cc++;
				bp = (char*)realloc(bp, ms += 6);
				Save24Bits(bp + co, i);					// save correction's offset
				bc = 0;
				bc_offset = co + 3;
				co += 6;								// offset to first byte of correction
			}

			// add byte to current correction
			if (!first)
			{
				bp = (char*)realloc(bp, ++ms);
				bp[co++] = nf.p[i];
				Save24Bits(bp + bc_offset, ++bc);		// save new bytes count
			}
		}
		else
			first = true;								// waiting for next correction
	}

	// if old file is greater then new file - CRC must be completed!
	for (; i < of.size; i++)
		of.CRC ^= of.p[i];

	// save CRCs & corrections total count
	bp[of_CRC_offset] = of.CRC;
	bp[nf_CRC_offset] = nf.CRC;
	*(int*)(bp + cc_offset) = cc;


	/////////////////////////////////////////
	// save update information to update file
	/////////////////////////////////////////

	HANDLE hUpdateRes = BeginUpdateResource(uf_name, FALSE);
	if (hUpdateRes == NULL)
		return ea(5);

	if
	(
		UpdateResource(hUpdateRes, RT_RCDATA, (LPCSTR)IDR_UFILE_RCDATA,
			MAKELANGID(LANG_ENGLISH, SUBLANG_ENGLISH_US), bp, ms) == FALSE
	)
		return ea(5);

	if ( !EndUpdateResource(hUpdateRes, FALSE) )
		return ea(6);

	return ea(0);
}