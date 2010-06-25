unit cntrf;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Menus, tpPopUp, tpSysPop;

type
  TServerForm = class(TForm)
    Memo1: TMemo;
    tpSystemPopup: TtpSystemPopup;
    miViewExampleSource: TMenuItem;
    miSaveList: TMenuItem;
    miLoadList: TMenuItem;
    miEditCounts: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure miViewExampleSourceClick(Sender: TObject);
    procedure SaveList(Sender: TObject);
    procedure LoadList(Sender: TObject);
    procedure EditList(Sender: TObject);
  private
    { Private declarations }
    function ListName:String;
  public
    { Public declarations }
    vars,list: tStringlist;
    fResult: String;
    fExecCount: Integer;
    //
    //these are the procedures that need to be coded for each server
    procedure Reset;
    procedure AddParam(const Value: String);
    procedure Execute;
    function  ResultText: String;
    //
    end;

var
  ServerForm: TServerForm;

implementation

{$R *.DFM}

uses
  ucshell, //WinShellOpen
  ComObj, Cntr_TLB; // Class_htComServer = server's guid

//

procedure TServerForm.FormCreate(Sender: TObject);
begin
  //identify the server by displaying the ProgID:
  // The ClassIDToProgID function displays the ProgID, which is the server
  // name which must be passed into the COM macro to connect with the server.
  Caption:=ExtractFilename(paramstr(0))+': '+ClassIDToProgID(Class_htComServer);
  miViewExampleSource.Click;
  //setup variables:
  vars:=tStringlist.create;
  list:=tStringlist.create;
  LoadList(nil);
end;

procedure TServerForm.FormDestroy(Sender: TObject);
begin
  SaveList(nil);
  list.free;
  vars.free;
end;

function TServerForm.ListName:String;
begin
  Result:=changefileext(paramstr(0),'.txt');
end;

procedure TServerForm.SaveList(Sender: TObject);
//keep the list values between runs.
begin
  try
    list.savetofile(ListName);
  except
    end;
end;

procedure TServerForm.LoadList(Sender: TObject);
begin
  try
    list.loadfromfile(ListName);
  except
    end;
end;

procedure TServerForm.EditList(Sender: TObject);
begin
  WinShellOpen(ListName); //ucshell
end;

//

procedure TServerForm.miViewExampleSourceClick(Sender: TObject);
begin
  with miViewExampleSource do begin
    Checked:=not Checked;
    tpSystemPopup.SynchronizeMenus;
    if checked then
      ClientHeight:=293
    else
      ClientHeight:=0;
    end;
end;

//------------------------------------------------------------------------------

procedure TServerForm.Reset;
begin
  vars.clear;
end;

procedure TServerForm.AddParam(const Value: String);
begin
  vars.add(Value);
end;

procedure TServerForm.Execute;
var
  a1,a2:string;
begin
  inc(fExecCount);
  with vars do
    if count<>2 then
      fResult:=
        '['+ClassIDToProgID(Class_htComServer)
        +' requires exactly two parameters.]'
    else begin
      a1:=uppercase(strings[0]+':'+strings[1]); //APPID:PAGEID
      a2:=list.values[a1];  //look it up in the list of parameters used so far
      fResult:=IntToStr(StrToIntDef(a2,0)+1); //increment the lookup counter
      list.values[a1]:=fResult;  //and store it back - or add it to the list.
      //
      if (fExecCount mod 10)=0 then
        SaveList(nil);
      end;
end;

function TServerForm.ResultText: String;
begin
  Result:=fResult;
end;

//------------------------------------------------------------------------------
end.
