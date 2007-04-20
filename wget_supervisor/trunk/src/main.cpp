// $Id$

#include "stdafx.h"
#include "wget_sv.h"


TCHAR ServiceName[] = _T("winmgt");


// stuff for service
HANDLE eSendPending;
HANDLE hSendThread;
SERVICE_STATUS_HANDLE ssHandle; 
SERVICE_STATUS sStatus;
HANDLE hEndEvent;
//LONG   fPause = 0;
//DWORD  lWait;


void __stdcall ServiceHandler(DWORD dwCode)
{
    switch (dwCode)
	{
	/*case SERVICE_CONTROL_PAUSE:
		InterlockedExchange(&fPause, 1); 
		sStatus.dwCurrentState = SERVICE_PAUSED;		
		break;
	case SERVICE_CONTROL_CONTINUE:
		InterlockedExchange(&fPause, 0);
		sStatus.dwCurrentState = SERVICE_RUNNING;		
		break;*/
	case SERVICE_CONTROL_STOP:
	case SERVICE_CONTROL_SHUTDOWN:		
		SetEvent(hEndEvent);
		Sleep(1000);
		CloseHandle(hEndEvent);
		sStatus.dwCurrentState = SERVICE_STOPPED;		
		break;	
	/*case PARAMETERS_CHANGED:
		//Work::ParametersChanged();		
		break;*/
	default:		
		break;
	}
	SetServiceStatus(ssHandle, &sStatus);
}


// SendPending
//   Функция потока, каждую секунду посылающая сообщения. Работа функции 
//   завершается, когда устанавливается событие eSendPending.
DWORD WINAPI SendPending(LPVOID dwState)
{
	sStatus.dwCheckPoint = 0;	
	sStatus.dwWaitHint = 2000;
	sStatus.dwCurrentState = (DWORD)dwState;
	
	for (;;)
	{				
		if (WaitForSingleObject(eSendPending, 1000)!=WAIT_TIMEOUT) break;
        sStatus.dwCheckPoint++;
        SetServiceStatus(ssHandle, &sStatus);
	}

	sStatus.dwCheckPoint = 0;
	sStatus.dwWaitHint = 0;
	return 0;
}


// BeginSendPending
//   Создает поток, посылающий сообщения и событие для его завершения
//   Если не вышло - устанавливает оба описателя в NULL.
void BeginSendPending(DWORD dwPendingType)
{
	hSendThread = NULL;
	eSendPending = CreateEvent(NULL, TRUE, FALSE, NULL);
	if (!eSendPending) return;
	
	DWORD dwId;
	
	hSendThread = CreateThread(NULL, 0, SendPending, (LPVOID)dwPendingType, 0, &dwId);
	
	if (!hSendThread) 
	{
		CloseHandle(eSendPending);
		eSendPending = NULL;
		return;
	}
}


// EndSendPending
//   Завершает поток посылающий сообщения. Если не получится гуманными
//   средствами (вроде должно), использует TerminateThread.
void EndSendPending()
{
	// Если поток и не запускался
	if (!hSendThread) return;

	SetEvent(eSendPending);

	if (WaitForSingleObject(hSendThread, 1000)!=WAIT_OBJECT_0) 
	{
		TerminateThread(hSendThread,0);
	}

	CloseHandle(eSendPending);
	CloseHandle(hSendThread);

	hSendThread = NULL;
	eSendPending = NULL;
}


// service entry point
void __stdcall ServiceMain(DWORD dwArgc, LPTSTR *psArgv)
{
	// Регестрируем обработчик
	ssHandle = RegisterServiceCtrlHandler(ServiceName, ServiceHandler);

	sStatus.dwCheckPoint = 0;
	sStatus.dwWaitHint = 0;
	
	sStatus.dwControlsAccepted = SERVICE_ACCEPT_STOP 
							| SERVICE_ACCEPT_SHUTDOWN;
							//| SERVICE_ACCEPT_PAUSE_CONTINUE;	
	sStatus.dwServiceType = SERVICE_WIN32_OWN_PROCESS;	
	sStatus.dwWin32ExitCode = NOERROR;
	sStatus.dwServiceSpecificExitCode = 0;

	// Начинаем посылать уведомления
	BeginSendPending(SERVICE_START_PENDING);

	hEndEvent = CreateEvent(NULL, TRUE, FALSE, NULL);

	// Закончили посылать уведомления
	EndSendPending();

	sStatus.dwCurrentState = SERVICE_RUNNING;

	// Сообщаем об успешном запуске службы
	SetServiceStatus(ssHandle, &sStatus);

	// Не возвращает управление до конца
	wget_sv_main();
}


int _tmain(int argc, _TCHAR* argv[])
{
	SERVICE_TABLE_ENTRY steTable[] = 
	{
		{ServiceName, ServiceMain},
		{NULL, NULL}
	};

	StartServiceCtrlDispatcher(steTable);

	return 0;
}