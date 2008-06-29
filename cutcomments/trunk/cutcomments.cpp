// $Id$

#include "stdafx.h"


// for C++ comments it handles files only with <CR><LF> line end markers.

bool write(HANDLE handle, const char* buffer, const unsigned int count)
{
  DWORD nWritten;
  WriteFile(handle, buffer, count, &nWritten, 0);
  return count == nWritten;
}

bool clean(const char* fileName)
{
  // open file
  HANDLE fileHandle = CreateFile(fileName, GENERIC_READ, FILE_SHARE_READ, 0,
    OPEN_EXISTING, 0, 0);
  if (INVALID_HANDLE_VALUE == fileHandle)
    return false;

  // get file size
  unsigned int fileSize = GetFileSize(fileHandle, 0);

  // read and close file
  char* file = new char [fileSize];
  DWORD nRead;
  ReadFile(fileHandle, file, fileSize, &nRead, 0);
  CloseHandle(fileHandle);
  if (nRead != fileSize)
    return false;

  // open file to write
  fileHandle = CreateFile(fileName, GENERIC_WRITE,
    FILE_SHARE_READ, 0, CREATE_ALWAYS, 0, 0);
  if (INVALID_HANDLE_VALUE == fileHandle)
  {
    delete [] file;
    return false;
  }

  // cutting...

  bool isQuoted = false;
  bool isBackslash = false;

  int nWhiteSpaces = 0;
  int nLastWhiteSpaces = 0;
  int nChars = 0;

  bool isCrByte = false;

  bool isCComment = false;
  bool isCCommentPart1 = false;

  bool isCppComment = false;
  bool isCppCommentPart1 = false;

  bool shouldSkip = false;

  for (unsigned int i = 0; i < fileSize; i++)
  {
    // check for quote
    if (!isBackslash && '"' == file[i])
      isQuoted = !isQuoted;

    // check for backslash
    isBackslash = '\\' == file[i] && !isBackslash;

    if (!isBackslash)
    {
      if (!isQuoted)
      {
        if (!isCComment && !isCppComment)
        // look for comment's begin...
        {
          
          if (!isCCommentPart1 && !isCppCommentPart1 && '/' == file[i])
          {
            isCCommentPart1 = true;
            isCppCommentPart1 = true;
          }
          else if (isCCommentPart1 && '*' == file[i])
          {
            isCCommentPart1 = false;
            isCComment = true;
            SetFilePointer(fileHandle, -1, 0, FILE_CURRENT);
            SetEndOfFile(fileHandle);
            nChars--;
          }
          else if (isCppCommentPart1 && '/' == file[i])
          {
            isCppCommentPart1 = false;
            isCppComment = true;
            SetFilePointer(fileHandle, -1, 0, FILE_CURRENT);
            SetEndOfFile(fileHandle);
            nChars--;
          }
          else
          {
            isCCommentPart1 = false;
            isCppCommentPart1 = false;
          }
        }
        else
        // look for comment's end
        {
          if (isCComment && !isCCommentPart1 && '*' == file[i])
            isCCommentPart1 = true;
          else if (isCppComment && !isCppCommentPart1 && '\r' == file[i])
            isCppCommentPart1 = true;
          else if (isCCommentPart1 && '/' == file[i])
          {
            isCCommentPart1 = false;
            isCComment = false;
            shouldSkip = true;
          }
          else if (isCppCommentPart1 && '\n' == file[i])
          {
            isCppCommentPart1 = false;
            isCppComment = false;
            if (nWhiteSpaces != nChars)
            {
              if (!write(fileHandle, "\r\n", 2))
              {
                CloseHandle(fileHandle);
                delete [] file;
                return false;
              }
            }
            else
            {
              SetFilePointer(fileHandle, -nChars, 0, FILE_CURRENT);
              SetEndOfFile(fileHandle);
              isCrByte = false;
              nChars = 0;
              nWhiteSpaces = 0;
            }
            shouldSkip = true;
          }
          else
          {
            isCCommentPart1 = false;
            isCppCommentPart1 = false;
          }
        }
      }
    }

    if (!isCComment && !isCppComment && !shouldSkip)
    {
      nChars++;
      if (' ' == file[i] || '\t' == file[i] || '\r' == file[i] || '\n' == file[i])
        nWhiteSpaces++;
    }

    // skip the last byte of a comment
    if (shouldSkip)
    {
      shouldSkip = false;
      continue;
    }

    if (!isCComment)
    {
      if (!isCrByte && '\r' == file[i])
        isCrByte = true;

      if (isCrByte && '\n' == file[i])
      {
        isCrByte = false;
        nWhiteSpaces = 0;
        nChars = 0;
      }
    }

    if (!isCComment && !isCppComment)
    {
      if (!write(fileHandle, file + i, 1))
      {
        CloseHandle(fileHandle);
        delete [] file;
        return false;
      }
    }
  }

  // close file
  CloseHandle(fileHandle);

  // free memory
  delete [] file;

  return true;
}


int main(int argc, char* argv[])
{
  if (1 == argc)
  {
    printf("Usage: cutcomments filename\r\n");
    return 1;
  }
  unsigned int nErrors = 0;
  for (int a = 1; a < argc; a++)
  {
    printf("cutting '");
    printf(argv[a]);
    printf("'... ");

    bool isOk = clean(argv[a]);
    if (isOk)
      printf("OK");
    else
    {
      nErrors++;
      printf("ERROR");
    }
    printf("\r\n");
  }
  printf("Errors: %d\r\n", nErrors);
	return 0;
}
