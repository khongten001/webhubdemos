unit counter;
////////////////////////////////////////////////////////////////////////////////
//  Copyright (c) 1995-2013 HREF Tools Corp.  All Rights Reserved Worldwide.  //
////////////////////////////////////////////////////////////////////////////////

// The key to the counter is the OnNewSession event which is on the
// application object.

// The code to implement the counter is isolated here in this separate
// unit, instead of in the main form, so that this panel can be added
// to any WebHub project.  All you have to do is make sure that the
// OnNewSession event is linked.

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UTPANFRM, ExtCtrls, StdCtrls, Toolbar, ComCtrls, tpStatus,
  UpdateOk, tpAction, WebTypes,   WebLink, tpCompPanel;

type
  TfmCounterPanel = class(TutParentForm)
    Panel1: TPanel;
    ToolBar: TtpToolBar;
    Panel2: TPanel;
    EditCounter: TEdit;
    tpStatusBar1: TtpStatusBar;
    Label1: TLabel;
    waShowCounter: TwhWebAction;
    procedure htWebAppNewSession(Sender: TObject;
      Session: Cardinal; const Command: String);
    procedure FormDestroy(Sender: TObject);
    procedure waShowCounterExecute(Sender: TObject);
  private
    { Private declarations }
    function CounterFilespec: string;
    function RestorerActiveHere: Boolean; override;
  public
    { Public declarations }
    function Init: Boolean; override;
  end;

var
  fmCounterPanel: TfmCounterPanel = nil;

implementation

{$R *.DFM}

uses
  ucString, ucLogFil,
  webApp,
  whQuery2_whdmData; // non-gui

var
  SavedCount: Integer = 0;

//------------------------------------------------------------------------------

function TfmCounterPanel.Init: boolean;
begin
  Result:= inherited Init;
  if Result then
  begin
    // This code initializes the counter when the EXE starts up.
    if FileExists(CounterFilespec) then
      SavedCount := StrToIntDef(StringLoadFromFile(CounterFilespec), 0)
    else
      SavedCount := 0;
    editCounter.text := IntToStr(SavedCount);
    if Assigned(pWebApp) then
    begin
     // add the OnNewSession Handler
     pWebApp.OnNewSession:=htWebAppNewSession;    // This disables the code in DWSecurity, which is ok for this demo.
   end;
  end;
end;

function TfmCounterPanel.RestorerActiveHere: Boolean;
begin
  Result := False;  // required; otherwise the restorer remembers the Edit .Text
end;

procedure TfmCounterPanel.waShowCounterExecute(Sender: TObject);
begin
  inherited;
  pWebApp.SendStringImm(EditCounter.Text);
end;

procedure TfmCounterPanel.htWebAppNewSession(Sender: TObject;
  Session: Cardinal; const Command: String);
var
  i:integer;
begin
  inherited;
  with pWebApp do
  begin
    if SessionNumber <> 0 then
    begin
      // This code increments the counter.
      Inc(SavedCount);
      editCounter.text := IntToStr(SavedCount);
    end;
  end;

  // About the edit box.  It was used so that you could
  // see the counter value on the panel, without looking into any component
  // properties.
  if Assigned(DMQuery2) then
    DMQuery2.WebAppNewSession(Sender, Session, Command);
end;

function TfmCounterPanel.CounterFilespec: string;
begin
  Result := ChangeFileExt(ModuleFileName, '.hitcount.txt');
end;

procedure TfmCounterPanel.FormDestroy(Sender: TObject);
begin
  inherited;
  fmCounterPanel := nil;
  // save latest count to disk before exiting.
  StringWriteToFile(CounterFilespec, IntToStr(SavedCount));
end;

end.
