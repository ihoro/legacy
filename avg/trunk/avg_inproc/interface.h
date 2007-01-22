#pragma once


// guids

static const GUID CLSID_Average = { /* 51D86720-C3D4-4F5B-AB3A-EA14C9BCA7A3 */
    0x51D86720,
    0xC3D4,
    0x4F5B,
    {0xAB, 0x3A, 0xEA, 0x14, 0xC9, 0xBC, 0xA7, 0xA3}
  };

static const GUID IID_IAverage = { /* 7DCD78B0-4B19-4FA1-8953-EEA55D8844C6 */
    0x7DCD78B0,
    0x4B19,
    0x4FA1,
    {0x89, 0x53, 0xEE, 0xA5, 0x5D, 0x88, 0x44, 0xC6}
  };


// interfaces

class IAverage : public IUnknown
{
public:
	virtual HRESULT __stdcall CalcAverage(int *array, int array_len, int *avg) = 0;
	virtual HRESULT __stdcall CalcAverageFromString(INT8U *str, INT8U sep, int *avg) = 0;
};