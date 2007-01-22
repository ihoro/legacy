#include <iostream>
#include <tchar.h>
#include "atlimage.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#endif

char sym[] = "0123456789ABCDEF";
HANDLE f;
CString s;

struct MEM_PTR
{
	char *p;
	int size;
};

MEM_PTR mp[3];

void fileGetName(char *s, char *fileName)
{
	char *start = fileName;

	for (; *s; s++)
		if (*s == '\\')
			fileName = start;
		else
			*fileName++ = *s;

	*fileName = 0;
}

void write(int what)		// what=0 - ap. =1 - wp, =2 - hp
{		
	mp[what].p = (char*)realloc(mp[what].p, mp[what].size += s.GetLength());
	memcpy(mp[what].p + mp[what].size - s.GetLength(), s.GetBuffer(), s.GetLength());
}

int _tmain(int argc, TCHAR* argv[], TCHAR* envp[])
{
	if (argc < 2)
	{
		std::cout << "\nbmp2array Converter v0.0 by fnt0m32 'at' gmail.com\n\n"
				  << "Usage: bmp2array <bmp file(s) path without extension '.bmp'>\n\n"
				  << "It will generates output file '<input file name>.h'\n"
				  << "that contains C-array of BMP(s) in following format:\n\n"
				  << "B,G,R, B,G,R, ..., B,G,R, 0 - it's one line of bytes,\n"
				  << "which size is BMP.width * 3 bytes + 1 zero byte\n"
				  << "So, array is a sequence of lines in total count of BMP.height.\n\n";
		return 0;
	}


	CImage img;
	char ifn[1024];		// image file name
	int width;			// of image
	int height;			// of image
	
	// get value name
	char vn[256];
	fileGetName(argv[1], vn);	

	// comments
	s.Format("// bmp2array Converter v0.0 by fnt0m32 'at' gmail.com\r\n" \
		     "// Note: size of one picture in array is (bmp.width*3 + 1)*bmp.height bytes.\r\n\r\n" \
		     "// bitmaps count: %d\r\n\r\n", argc-1);
	write(1);

	// beginnig for array itself
	s.Format("unsigned char %s[] =\r\n{\r\n    // bitmap #0\r\n    ", vn);
	write(0);
	// beginnig for width array
	s.Format("int %s_width[] = {", vn);
	write(1);
	// beginnig for height array
	s.Format("int %s_height[] = {", vn);
	write(2);


	// forming output data in memory
	for (int n=1; n < argc; n++)
	{
		// load image
		strcpy(ifn, argv[n]);
		strcat(ifn, ".bmp");
		img.Load(ifn);
		width = img.GetWidth();
		height = img.GetHeight();

		// write width/height
		if (n == argc-1)
		{
			s.Format("%lu};\r\n", width);
			write(1);
			s.Format("%lu};\r\n", height);
			write(2);
		}
		else
		{
			s.Format("%lu,", width);
			write(1);
			s.Format("%lu,", height);
			write(2);
		}

		// write image itself
		for (int i=0; i<height; i++)
			for (int j=0; j<width; j++)
			{
				int bgr = img.GetPixel(j,i);
				for (int k=0; k<3; k++)
				{
					bgr <<= 8;
					unsigned char c = (unsigned char)((bgr & 0xFF000000) >> 24);
					char H = sym[(c & 0xF0) >> 4];
					char L = sym[c & 0x0F];
					if (j == width-1 && k == 2)
						if (i == height-1)
							if (n == argc-1)
								s.Format("0x%c%c,0x00\r\n};", H, L);
							else
								s.Format("0x%c%c,0x00,\r\n\r\n    // bitmap #%d\r\n    ", H, L, n);
						else
							s.Format("0x%c%c,0x00,\r\n    ", H, L);
					else
						s.Format("0x%c%c,", H, L);
					
					write(0);
				}
			}
	}

	// create output file
	char fn[1024];
	strcpy(fn, argv[1]);
	strcat(fn, ".h");
	f = CreateFile(fn, GENERIC_WRITE, 0, 0, CREATE_ALWAYS, 0, 0);

	// write data to file
	int cSet;
	WriteFile(f, mp[1].p, mp[1].size, (LPDWORD)&cSet, 0);
	WriteFile(f, mp[2].p, mp[2].size, (LPDWORD)&cSet, 0);
	WriteFile(f, mp[0].p, mp[0].size, (LPDWORD)&cSet, 0);

	// close file
	CloseHandle(f);

	return 0;
}
