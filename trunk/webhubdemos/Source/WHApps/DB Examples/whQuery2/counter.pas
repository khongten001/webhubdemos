unit counter;
////////////////////////////////////////////////////////////////////////////////
//  Copyright (c) 1995-2003 HREF Tools Corp.  All Rights Reserved Worldwide.  //
////////////////////////////////////////////////////////////////////////////////

// The key to the counter is the OnNewSession event which is on the
// application object.  See the .dpr file.

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
    procedure htWebAppNewSession(Sender: TObject;
      Session: Cardinal; const Command: String);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function Init: Boolean; override;
  end;

var
  fmCounterPanel: TfmCounterPanel = nil;

implementation

{$R *.DFM}

uses
  Math,
  webApp,
  whQuery2_whdmData; // non-gui

var
  aCounter:string;

//------------------------------------------------------------------------------

function TfmCounterPanel.Init:Boolean;
begin
  Result:= inherited Init;
  if not result then
    exit;
  // This code initializes the counter when the EXE starts up.
  if assigned(pWebApp) then begin
    with pWebApp do begin   // pWebApp is a pointer to the current WebApp.
      aCounter:='Count'+AppID;
      editCounter.text:=AppSetting[ aCounter ];  // the counter is kept in App Settings
      if editCounter.text='' then
      begin
        editCounter.text:='0';
        AppSettings.Values[aCounter]:='0';
      end;
  //
  // add the OnNewSession Handler
     OnNewSession:=htWebAppNewSession;    // This disables the code in DWSecurity, which is ok for this demo.
     end;
   end;
end;

procedure TfmCounterPanel.htWebAppNewSession(Sender: TObject;
  Session: Cardinal; const Command: String);
var
  i:integer;
begin
  inherited;
  // This code increments the counter.
  with pWebApp do
  begin
    if SessionNumber = 0 then Exit;

    i := StrToIntDef(AppSetting[ aCounter ],0);
    i := Math.Max(i, StrToIntDef(editCounter.text,0)) + 1;  
    AppSettings.Values[aCounter] := IntToStr(i);
    //!!!AppSettings.SaveList; does not save XML according to XSD
    editCounter.text:=IntToStr(i);
  end;

  // About the edit box.  It was used so that you could
  // see the counter value on the panel, without looking into any component
  // properties.  The HTML calls editCounter.text to display the count.

  if Assigned(DMQuery2) then
    DMQuery2.WebAppNewSession(Sender, Session, Command);

end;

procedure TfmCounterPanel.FormDestroy(Sender: TObject);
begin
  inherited;
  fmCounterPanel := nil;
end;

end.
