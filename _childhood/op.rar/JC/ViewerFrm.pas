unit ViewerFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, StdCtrls, FileCtrl, Main, GlobalVars, Coder, Gauges, ComCtrls,
  Buttons, ImgList;

type
  TViewerForm = class(TForm)
    dlbTree: TDirectoryListBox;
    DriveComboBox: TDriveComboBox;
    dgView: TDrawGrid;
    FileListBox: TFileListBox;
    btnCancel: TButton;
    btnOpen: TButton;
    btnConvert: TButton;
    Gauge: TGauge;
    edtFileName: TEdit;
    ListView: TListView;
    SpeedButton: TSpeedButton;
    ImageList: TImageList;
    sbView: TSpeedButton;
    procedure Button1Click(Sender: TObject);
    procedure dgViewDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure dlbTreeChange(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnOpenClick(Sender: TObject);
    procedure btnConvertClick(Sender: TObject);
    procedure dgViewSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure SpeedButtonClick(Sender: TObject);
    procedure dgViewDblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ListViewColumnClick(Sender: TObject; Column: TListColumn);
    procedure FormDestroy(Sender: TObject);
    procedure ListViewSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure FormShow(Sender: TObject);
    procedure ListViewDblClick(Sender: TObject);
    procedure sbViewClick(Sender: TObject);
  private
    { Private declarations }
  public
    FSort: Byte;
    FFirst: Boolean;
      {1-Name Up; 2-Name Down; 3-Size Up; 4-Size Down; 5-Date Up; 6-Date Down}
    FOpened: Boolean;
    FFileName: string;
    flb: TStringList;
    function LoadJap(FileName: string;var cX,cY: Word;var Cross: TCrossword):Boolean;
    procedure Sort1(Index,Count: Cardinal);
    procedure Sort2(Index,Count: Cardinal);
    procedure Sort3(Index,Count: Cardinal);
    procedure Sort4(Index,Count: Cardinal);
    procedure Sort5(Index,Count: Cardinal);
    procedure Sort6(Index,Count: Cardinal);
    function Execute: Boolean;
    { Public declarations }
  end;

var
  ViewerForm: TViewerForm;
  f,l: Cardinal;
  sr,sr2: TSearchRec;
  bm: TBitmap;

implementation

uses PreviewFrm;

{$R *.DFM}

{ TViewerForm }

function TViewerForm.LoadJap(FileName: string; var cX, cY: Word;
  var Cross: TCrossword): Boolean;
var
  Jap: file of Byte;
  c1,c2: Byte;
  f,l,b: Byte;
begin
AssignFile(Jap,FileName);
Reset(Jap);
read(Jap,c1,c2);
if UpperCase(Chr(c1)+Chr(c2))<>'JE' then
  begin
    Result:=false;
    FileErrors:=2;
    Exit
  end;
read(Jap,c1,c2);
cX:=c1;
cY:=c2;
l:=1;
f:=0;
  repeat
      read(Jap,c1);
      for b:=7 downto 0 do
        begin
          inc(f);
          if f>cX then
            begin
              inc(l);
              if l>cY then Break;
              f:=1
            end;
          if c1 and (00000001 shl b)<>0 then
            Cross[f,l]:=true
                                             else
            Cross[f,l]:=false
        end
  until l>cY;
CloseFile(Jap);
Result:=true
end;

procedure TViewerForm.Button1Click(Sender: TObject);
begin
  dgView.ColCount:=2
end;

procedure TViewerForm.dgViewDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
  cr: TCrossword;
  x,y,f,l,dx,dy,i: Word;
begin
  i:=ARow*4+ACol;
  if (i<0) or (i>=flb.Count) then Exit;
  with dgView.Canvas do
    if LoadJap(dlbTree.Directory+'\'+flb[i],x,y,cr) then
      begin
        dx:=(99-x) div 2;
        dy:=(99-y) div 2;
        for l:=1 to y do
          for f:=1 to x do
            if cr[f,l] then
              if (gdSelected in State) and (not dgView.Focused or
                ((ACol>=dgView.Selection.Left) and (ACol<=dgView.Selection.Right)
                and (ARow>=dgView.Selection.Top) and (ARow<=dgView.Selection.Bottom)
                and ((dgView.Selection.Right-dgView.Selection.Left<>0) or
                (dgView.Selection.Bottom-dgView.Selection.Top<>0)))) then
                Pixels[Rect.Left+f+dx-1,Rect.Top+l+dy-1]:=clWhite
                                              else
                Pixels[Rect.Left+f+dx-1,Rect.Top+l+dy-1]:=ccPoint;
        dx:=(99-TextWidth(Copy(flb[i],1,
          Length(flb[i])-4))) div 2;
        if TextWidth(Copy(flb[i],1,
          Length(flb[i])-4))>99 then dx:=0;
        TextOut(Rect.Left+dx,Rect.Top+99,Copy(flb[i],1,
          Length(flb[i])-4))
      end
end;

procedure TViewerForm.dlbTreeChange(Sender: TObject);
var
  FileTime: TDateTime;
  Hour,Min,Sec,MSec,Year,Month,Day: Word;
  s: string;
begin
  if FileListBox.Items.Count>1 then
  with FileListBox do
    case FSort of
      1:Sort1(1,FileListBox.Items.Count);
      2:Sort2(1,FileListBox.Items.Count);
      3:Sort3(1,FileListBox.Items.Count);
      4:Sort4(1,FileListBox.Items.Count);
      5:Sort5(1,FileListBox.Items.Count);
      6:Sort6(1,FileListBox.Items.Count)
    end
                               else
    begin
      flb.Clear;
      if FileListBox.Items.Count>0 then
        flb.Add(FileListBox.Items[0])
    end;
  with flb do
    begin
      if Count<=4 then
        begin
          dgView.ColCount:=Count;
          dgView.RowCount:=1
        end
                  else
        begin
          dgView.ColCount:=4;
          dgView.RowCount:=Count div 4;
          if Count mod 4<>0 then dgView.RowCount:=dgView.RowCount+1
        end
    end;
  dgView.Col:=0;
  dgView.Row:=0;
  ListView.Items.Clear;
  for f:=1 to flb.Count do
    begin
      FindFirst(dlbTree.Directory+'\'+flb[f-1],faAnyFile,sr);
      ListView.Items.Add;
      ListView.Items[f-1].Caption:=ExtractFileName(sr.Name);
      {ss:=Round(sr.Size/1024);
      if ss<1 then ss:=1;}
      ListView.Items[f-1].SubItems.Add(IntToStr(sr.Size)+' байт');
      FileTime:=FileDateToDateTime(sr.Time);
      DecodeDate(FileTime,Year,Month,Day);
      DecodeTime(FileTime,Hour,Min,Sec,MSec);
      if Day<=9 then s:='0'+IntToStr(Day)
                else s:=IntToStr(Day);
      s:=s+'.';
      if Month<=9 then s:=s+'0'+IntToStr(Month)
                  else s:=s+IntToStr(Month);
      s:=s+'.';
      Year:=StrToInt(Copy(IntToStr(Year),3,2));
      if Year<=9 then s:=s+'0'+IntToStr(Year)
                 else s:=s+IntToStr(Year);
      s:=s+' ';
      if Hour<=9 then s:=s+'0'+IntToStr(Hour)
                 else s:=s+IntToStr(Hour);
      s:=s+':';
      if Min<=9 then s:=s+'0'+IntToStr(Min)
                else s:=s+IntToStr(Min);
      ListView.Items[f-1].SubItems.Add(s)
    end;
  InvalidateRect(dgView.Handle,nil,false)
end;

procedure TViewerForm.btnCancelClick(Sender: TObject);
begin
  FOpened:=false;
  Close
end;

procedure TViewerForm.btnOpenClick(Sender: TObject);
begin
  if ListView.Items.Count=0 then Exit;
{  if ListView.Visible then
    with ListView do
      if ListView.Items.Count<>0 then
        begin
          dgView.Row:=(ItemFocused.Index+1) div 4;
          if (ItemFocused.Index+1) mod 4=0 then
            begin
              dgView.Row:=dgView.Row-1;
              dgView.Col:=3
            end
                                       else
            dgView.Col:=(ItemFocused.Index+1) mod 4-1
        end;}
  {if not ListView.Visible then
    begin}
//      if dgView.Row*4+dgView.Col+1>flb.Count then Exit;
  FOpened:=true;
//      FFileName:=flb[dgView.Row*4+dgView.Col];
  FFileName:=edtFileName.Text;
{    end
                          else
    begin
      FOpened:=true;
      FFileName:=flb[ListView.ItemFocused.Index]
    end;}
  Close
end;

function TViewerForm.Execute: Boolean;
begin
  ShowModal;
  Result:=FOpened
end;

procedure TViewerForm.btnConvertClick(Sender: TObject);
var
  f,l,t: Word;
  TempCr: TCrossFile;
begin
  if flb.Count=0 then Exit;
  btnConvert.Visible:=false;
  Gauge.Progress:=0;
  Gauge.Visible:=true;
  Enabled:=false;
  Screen.Cursor:=crHourGlass;
  TempCr:=Crossword;
  t:=0;
  if not ListView.Visible then
   with dgView do
    begin
      for l:=Selection.Top to Selection.Bottom do
        for f:=Selection.Left to Selection.Right do
          begin
            if l*4+f+1>flb.Count then
              begin
                Gauge.Progress:=100;
                Gauge.Invalidate;
                Break
              end;
            LoadJap(flb[l*4+f],
              Crossword.CrosswordX,Crossword.CrosswordY,
              Crossword.CrosswordPicture);
            ForAllE;
            BufferPic.SaveToFile(Copy(flb[l*4+f],1,
              Length(flb[l*4+f])-3)+'bmp');
            BufferPic.Free;
            inc(t);
            if (Selection.Right-Selection.Left<>0) and
              (Selection.Bottom-Selection.Top<>0) then
              Gauge.Progress:=Round((t/((Selection.Bottom-Selection.Top)*
                  (Selection.Right-Selection.Left)))*100)
                                                  else
            if (Selection.Right-Selection.Left=0) and
              (Selection.Bottom-Selection.Top<>0) then
              Gauge.Progress:=Round((t/(
                (Selection.Bottom-Selection.Top)))*100)
                                                else
              if (Selection.Bottom-Selection.Top=0) and
                (Selection.Right-Selection.Left<>0) then
                Gauge.Progress:=Round((t/(
                  (Selection.Right-Selection.Left)))*100)
                                                    else
                Gauge.Progress:=100;
            Gauge.Invalidate
          end
    end
                          else
   with ListView do
     for f:=0 to Items.Count-1 do
       if Items[f].Selected then
         begin
           LoadJap(flb[f],
             Crossword.CrosswordX,Crossword.CrosswordY,
             Crossword.CrosswordPicture);
           ForAllE;
           BufferPic.SaveToFile(Copy(flb[f],1,
             Length(flb[f])-3)+'bmp');
           BufferPic.Free;
           inc(t);
           Gauge.Progress:=Round(t/SelCount*100);
           Gauge.Invalidate;
           if t=SelCount then Break
         end;
  Crossword:=TempCr;
  Gauge.Visible:=false;
  btnConvert.Visible:=true;
  Enabled:=true;
  Screen.Cursor:=crDefault
end;

procedure TViewerForm.dgViewSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  if ARow*4+ACol+1>flb.Count then
    begin
      edtFileName.Text:='';
      Exit
    end;
  edtFileName.Text:=flb[ARow*4+ACol]
end;

procedure TViewerForm.SpeedButtonClick(Sender: TObject);
begin
  if not ListView.Visible then
    begin
      ImageList.GetBitmap(1,bm);
      SpeedButton.Glyph.Assign(bm);
      ListView.Visible:=true;
      ListView.TabStop:=true;
      ListView.Focused;
      dgView.Visible:=false;
      dgView.TabStop:=false;
      with dgView do
        if ListView.Items.Count<>0 then
          ListView.ItemFocused:=ListView.Items[Row*4+Col]
    end
                          else
    begin
      ImageList.GetBitmap(0,bm);
      SpeedButton.Glyph.Assign(bm);
      dgView.Visible:=true;
      dgView.TabStop:=true;
      dgView.Focused;
      ListView.Visible:=false;
      ListView.TabStop:=false;
      with ListView do
        if ListView.Items.Count<>0 then
        begin
          if (ItemFocused.Index+1) mod 4<>0 then
            dgView.Row:=(ItemFocused.Index+1) div 4;
          if (ItemFocused.Index+1) mod 4=0 then
            begin
              dgView.Row:=(ItemFocused.Index+1) div 4-1;
              dgView.Col:=3
            end
                                       else
            dgView.Col:=(ItemFocused.Index+1) mod 4-1
        end
    end
end;

procedure TViewerForm.dgViewDblClick(Sender: TObject);
begin
  btnOpen.OnClick(Self)
end;

procedure TViewerForm.FormCreate(Sender: TObject);
begin
  FSort:=3;
  flb:=TStringList.Create;
  FFirst:=true;
  bm:=TBitmap.Create;
  ImageList.GetBitmap(0,bm);
  SpeedButton.Glyph.Assign(bm)
end;

procedure TViewerForm.ListViewColumnClick(Sender: TObject;
  Column: TListColumn);
begin
  if Column=ListView.Columns[0] then
    case FSort of
      1: FSort:=2;
      2: FSort:=1;
      3,4,5,6: FSort:=1
    end;
  if Column=ListView.Columns[1] then
    case FSort of
      3: FSort:=4;
      4: FSort:=3;
      1,2,5,6: FSort:=3
    end;
  if Column=ListView.Columns[2] then
    case FSort of
      5: FSort:=6;
      6: FSort:=5;
      1,2,3,4: FSort:=5
    end;
  dlbTree.OnChange(Self)
end;

procedure TViewerForm.FormDestroy(Sender: TObject);
begin
  flb.Free;
  bm.Free
end;

procedure TViewerForm.Sort3(Index, Count: Cardinal);
begin
  if Count div 2<>1 then
    begin
      Sort3(Index,Count div 2);
      for f:=Index to Index+Count div 2-1 do
        FileListBox.Items[f-1]:=flb[f-Index]
    end;
  if Count div 2+Count mod 2<>1 then
    begin
      Sort3(Index+Count div 2,Count div 2+Count mod 2);
      for f:=Index+Count div 2 to Index+Count-1 do
        FileListBox.Items[f-1]:=flb[f-Index-Count div 2]
    end;
  f:=Index;
  l:=Index+Count div 2;
  flb.Clear;
  repeat
    FindFirst(dlbTree.Directory+'\'+FileListBox.Items[f-1],faAnyFile,sr);
    FindFirst(dlbTree.Directory+'\'+FileListBox.Items[l-1],faAnyFile,sr2);
    if sr.Size<sr2.Size then
      begin
        flb.Add(FileListBox.Items[f-1]);
        inc(f)
      end
                        else
      begin
        flb.Add(FileListBox.Items[l-1]);
        inc(l)
      end
  until (f=Index+Count div 2) or (l=Index+Count);
  if f=Index+Count div 2 then
    for f:=l to Index+Count-1 do
      flb.Add(FileListBox.Items[f-1]);
  if l=Index+Count then
    for l:=f to Index+Count div 2-1 do
      flb.Add(FileListBox.Items[l-1])
end;

procedure TViewerForm.Sort4(Index, Count: Cardinal);
begin
  if Count div 2<>1 then
    begin
      Sort4(Index,Count div 2);
      for f:=Index to Index+Count div 2-1 do
        FileListBox.Items[f-1]:=flb[f-Index]
    end;
  if Count div 2+Count mod 2<>1 then
    begin
      Sort4(Index+Count div 2,Count div 2+Count mod 2);
      for f:=Index+Count div 2 to Index+Count-1 do
        FileListBox.Items[f-1]:=flb[f-Index-Count div 2]
    end;
  f:=Index;
  l:=Index+Count div 2;
  flb.Clear;
  repeat
    FindFirst(dlbTree.Directory+'\'+FileListBox.Items[f-1],faAnyFile,sr);
    FindFirst(dlbTree.Directory+'\'+FileListBox.Items[l-1],faAnyFile,sr2);
    if sr.Size>sr2.Size then
      begin
        flb.Add(FileListBox.Items[f-1]);
        inc(f)
      end
                        else
      begin
        flb.Add(FileListBox.Items[l-1]);
        inc(l)
      end
  until (f=Index+Count div 2) or (l=Index+Count);
  if f=Index+Count div 2 then
    for f:=l to Index+Count-1 do
      flb.Add(FileListBox.Items[f-1]);
  if l=Index+Count then
    for l:=f to Index+Count div 2-1 do
      flb.Add(FileListBox.Items[l-1])
end;

procedure TViewerForm.Sort1(Index, Count: Cardinal);
begin
  if Count div 2<>1 then
    begin
      Sort1(Index,Count div 2);
      for f:=Index to Index+Count div 2-1 do
        FileListBox.Items[f-1]:=flb[f-Index]
    end;
  if Count div 2+Count mod 2<>1 then
    begin
      Sort1(Index+Count div 2,Count div 2+Count mod 2);
      for f:=Index+Count div 2 to Index+Count-1 do
        FileListBox.Items[f-1]:=flb[f-Index-Count div 2]
    end;
  f:=Index;
  l:=Index+Count div 2;
  flb.Clear;
  repeat
    if UpperCase(FileListBox.Items[f-1])<UpperCase(FileListBox.Items[l-1]) then
      begin
        flb.Add(FileListBox.Items[f-1]);
        inc(f)
      end
                        else
      begin
        flb.Add(FileListBox.Items[l-1]);
        inc(l)
      end
  until (f=Index+Count div 2) or (l=Index+Count);
  if f=Index+Count div 2 then
    for f:=l to Index+Count-1 do
      flb.Add(FileListBox.Items[f-1]);
  if l=Index+Count then
    for l:=f to Index+Count div 2-1 do
      flb.Add(FileListBox.Items[l-1])
end;

procedure TViewerForm.Sort2(Index, Count: Cardinal);
begin
  if Count div 2<>1 then
    begin
      Sort2(Index,Count div 2);
      for f:=Index to Index+Count div 2-1 do
        FileListBox.Items[f-1]:=flb[f-Index]
    end;
  if Count div 2+Count mod 2<>1 then
    begin
      Sort2(Index+Count div 2,Count div 2+Count mod 2);
      for f:=Index+Count div 2 to Index+Count-1 do
        FileListBox.Items[f-1]:=flb[f-Index-Count div 2]
    end;
  f:=Index;
  l:=Index+Count div 2;
  flb.Clear;
  repeat
    if UpperCase(FileListBox.Items[f-1])>UpperCase(FileListBox.Items[l-1]) then
      begin
        flb.Add(FileListBox.Items[f-1]);
        inc(f)
      end
                        else
      begin
        flb.Add(FileListBox.Items[l-1]);
        inc(l)
      end
  until (f=Index+Count div 2) or (l=Index+Count);
  if f=Index+Count div 2 then
    for f:=l to Index+Count-1 do
      flb.Add(FileListBox.Items[f-1]);
  if l=Index+Count then
    for l:=f to Index+Count div 2-1 do
      flb.Add(FileListBox.Items[l-1])
end;

procedure TViewerForm.Sort5(Index, Count: Cardinal);
begin
  if Count div 2<>1 then
    begin
      Sort5(Index,Count div 2);
      for f:=Index to Index+Count div 2-1 do
        FileListBox.Items[f-1]:=flb[f-Index]
    end;
  if Count div 2+Count mod 2<>1 then
    begin
      Sort5(Index+Count div 2,Count div 2+Count mod 2);
      for f:=Index+Count div 2 to Index+Count-1 do
        FileListBox.Items[f-1]:=flb[f-Index-Count div 2]
    end;
  f:=Index;
  l:=Index+Count div 2;
  flb.Clear;
  repeat
    if FileDateToDateTime(FileAge(dlbTree.Directory+'\'+FileListBox.Items[f-1]))<
      FileDateToDateTime(FileAge(dlbTree.Directory+'\'+FileListBox.Items[l-1])) then
      begin
        flb.Add(FileListBox.Items[f-1]);
        inc(f)
      end
                        else
      begin
        flb.Add(FileListBox.Items[l-1]);
        inc(l)
      end
  until (f=Index+Count div 2) or (l=Index+Count);
  if f=Index+Count div 2 then
    for f:=l to Index+Count-1 do
      flb.Add(FileListBox.Items[f-1]);
  if l=Index+Count then
    for l:=f to Index+Count div 2-1 do
      flb.Add(FileListBox.Items[l-1])
end;

procedure TViewerForm.Sort6(Index, Count: Cardinal);
begin
  if Count div 2<>1 then
    begin
      Sort6(Index,Count div 2);
      for f:=Index to Index+Count div 2-1 do
        FileListBox.Items[f-1]:=flb[f-Index]
    end;
  if Count div 2+Count mod 2<>1 then
    begin
      Sort6(Index+Count div 2,Count div 2+Count mod 2);
      for f:=Index+Count div 2 to Index+Count-1 do
        FileListBox.Items[f-1]:=flb[f-Index-Count div 2]
    end;
  f:=Index;
  l:=Index+Count div 2;
  flb.Clear;
  repeat
    if FileDateToDateTime(FileAge(dlbTree.Directory+'\'+FileListBox.Items[f-1]))>
      FileDateToDateTime(FileAge(dlbTree.Directory+'\'+FileListBox.Items[l-1])) then
      begin
        flb.Add(FileListBox.Items[f-1]);
        inc(f)
      end
                        else
      begin
        flb.Add(FileListBox.Items[l-1]);
        inc(l)
      end
  until (f=Index+Count div 2) or (l=Index+Count);
  if f=Index+Count div 2 then
    for f:=l to Index+Count-1 do
      flb.Add(FileListBox.Items[f-1]);
  if l=Index+Count then
    for l:=f to Index+Count div 2-1 do
      flb.Add(FileListBox.Items[l-1])
end;

procedure TViewerForm.ListViewSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  if ListView.Items.Count<>0 then
    edtFileName.Text:=Item.Caption
end;

procedure TViewerForm.FormShow(Sender: TObject);
begin
  if FFirst then
    begin
      dlbTree.Directory:=OpenJAP;
      FFirst:=false
    end
end;

procedure TViewerForm.ListViewDblClick(Sender: TObject);
begin
  btnOpen.OnClick(Self)
end;

procedure TViewerForm.sbViewClick(Sender: TObject);
var
  TempCr: TCrossFile;
begin
  if flb.Count=0 then Exit;
  TempCr:=Crossword;
  if not ListView.Visible then
    with dgView do
      LoadJap(flb[Row*4+Col],
        Crossword.CrosswordX,Crossword.CrosswordY,
        Crossword.CrosswordPicture)
                          else
    with ListView do
      LoadJap(flb[ItemFocused.Index],
        Crossword.CrosswordX,Crossword.CrosswordY,
        Crossword.CrosswordPicture);
  ForAllE;
  with Preview do
    begin
      ClientHeight:=BufferPic.Height;
      ClientWidth:=BufferPic.Width;
      Image.Picture.Bitmap:=BufferPic;
      BufferPic.Free;
      Crossword:=TempCr;
      Position:=poScreenCenter;
      ShowModal
    end
end;

end.
