unit fmsetups;

(*
Copyright (c) 1998 HREF Tools Corp.

Permission is hereby granted, on 04-Jun-2004, free of charge, to any person
obtaining a copy of this file (the "Software"), to deal in the Software
without restriction, including without limitation the rights to use, copy,
modify, merge, publish, distribute, sublicense, and/or sell copies of the
Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*)

// There are a number of stacked panels on this form.  You need to use 'Bring to Front'
// to be able to work on them.  At run-time, only one at a time is visible.
// -Ann Lynnworth, May 9, 1998.


interface

{$I hrefdefines.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  {$I xe_actnlist.inc}
  ExtCtrls, StdCtrls, Menus, Buttons,
  UTPANFRM, UpdateOk, tpAction, IniLink, Toolbar, Restorer, 
{$IFNDEF VER130}
{$WARN UNIT_PLATFORM OFF}
{$ENDIF}
  FileCtrl,
{$IFNDEF VER130}
{$WARN UNIT_PLATFORM ON}
{$ENDIF}
  Grids,
  DirOutln, ComCtrls, TxtGrid, tpCompPanel, txtGridVCL;

type
  TfmAppsetups = class(TutParentForm)
    ToolBar: TtpToolBar;
    Panel: TPanel;
    Panel1: TPanel;
    Image1: TImage;
    PanelSetups: TPanel;
    PanelNewAppID: TPanel;
    Panel2: TPanel;
    EditAppID: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Panel3: TPanel;
    panelActive: TPanel;
    Panel4: TPanel;
    EditAppPath: TEdit;
    Panel5: TPanel;
    BtnCreateNewAppID: TBitBtn;
    btnChooseDirectory: TtpToolButton;
    BtnCancelNewAppID: TBitBtn;
    PanelOpen: TPanel;
    tpToolBar2: TtpToolBar;
    Panel6: TPanel;
    BtnSelectApp: TBitBtn;
    BtnCancelOpen: TBitBtn;
    tpFixedGrid1: TtpFixedGrid;
    Label3: TLabel;
    LabelAppServer: TLabel;
    ActionList1: TActionList;
    actNewAppID: TAction;
    actOpenAppID: TAction;
    actSaveNewAppID: TAction;
    actHelpAbout: TAction;
    procedure btnChooseDirectoryClick(Sender: TObject);
    procedure BtnCancelNewAppIDClick(Sender: TObject);
    procedure BtnCancelOpenClick(Sender: TObject);
    procedure BtnSelectAppClick(Sender: TObject);
    procedure TreeView1DblClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure actNewAppIDExecute(Sender: TObject);
    procedure actOpenAppIDExecute(Sender: TObject);
    procedure actSaveNewAppIDExecute(Sender: TObject);
    procedure actHelpAboutExecute(Sender: TObject);
  private
    { Private declarations }
    bTreeViewValid:boolean;
    TreeView1:TTreeView;
  public
    { Public declarations }
    function Init: Boolean; override;
    procedure Save(Restorer:TFormRestorer); override;
    procedure Load(Restorer:TFormRestorer); override;
    //
    procedure PanelOpenActive;
    procedure htWebAppUpdate(Sender: TObject);
    end;

var
  fmAppsetups: TfmAppsetups;

implementation

{$R *.DFM}

uses
  WebApp, WebInfou, ucDlgs, ucString, WebSplat, webcall, htWebApp,
  {dmWHPWApp, }ucPos;

//------------------------------------------------------------------------------

function TfmAppsetups.Init:Boolean;
begin
  Result:= inherited Init;
  if not result then
    exit;
  bTreeViewValid:=false;
  treeview1:=nil;
  //
  (*
  webinfou.CentralInfo.websetups.editIn(PanelSetups);  // bring the property editor into PanelSetups
  *)
  //
  if assigned(pWebApp) then
    AddAppUpdateHandler(htWebAppUpdate);  // without this, changes to AppID will not refresh the mail panel.
  htWebAppUpdate(nil); // do this once, in case the app has already been loaded - likely.
  //
end;

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

procedure TfmAppsetups.Save(Restorer:TFormRestorer);
//example OnSave Handler
begin
  inherited Save(Restorer);
  with Restorer do
  begin
    LongintEntry['Panel']:= Panel.Width;
  end;
end;

procedure TfmAppsetups.Load(Restorer:TFormRestorer);
//example OnLoad Handler
begin
  inherited Load(Restorer);
  with Restorer do
  begin
    LongintEntry['Panel']:= Panel.Width;
  end;
end;

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

procedure TfmAppsetups.PanelOpenActive;
begin
  // This is the default panel that shows when nothing else is going on.
  with PanelActive,pWebApp do begin
    visible:=true;  // start by showing the currently open AppID
    with tpFixedGrid1 do begin
      Cells[0,0]:='Application ID';
      Cells[1,0]:=AppID;
      Cells[0,1]:='Application Path';
      Cells[1,1]:=AppPath;
      Cells[0,2]:='Number of Pages';
      Cells[1,2]:=IntToStr(Pages.count);
      ScanColumnWidths;
      invalidate;
      application.processMessages;
      end;
    PanelNewAppID.visible:=false;
    PanelOpen.visible:=false;
    PanelSetups.visible:=false;
    end;
end;

//------------------------------------------------------------------------------

procedure TfmAppsetups.actOpenAppIDExecute(Sender: TObject);
var
  i:integer;
  CNode: TTreeNode;
begin
  inherited;
  inherited;
  // 'OPEN' an existing AppID
  if treeview1=nil then begin
    // Create the treeview on the fly, only when requested, to conserve RAM
    // on production servers.
    treeview1:=TTreeview.create(PanelOpen);
    with treeview1 do begin
      Parent:=PanelOpen;
      Left := 6;
      Top := 6;
      Width := 328;
      Height := 405;
      Indent := 19;
      Align := alClient;
      TabOrder := 1;
      OnDblClick := TreeView1DblClick;
      end;
    end;
  //
  treeview1.enabled:=true;
  PanelSetups.visible:=false;
  PanelNewAppID.visible:=false;
  PanelActive.visible:=false;
  PanelOpen.visible:=true;
  with BestCentralInfo, treeView1 do
  begin
    if (items.count=0) or (NOT bTreeViewValid) then
    begin
      selected:=nil;
      items.clear;
      cNode:=items.add(nil,'Local Machine');
      for i:=0 to High(CentralApps.List) do
        items.addChild(cnode, CentralApps.List[i].AppID);
      items[0].expanded:=true;
      bTreeViewValid:=true;
      end;
    end;
end;

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

procedure TfmAppsetups.actNewAppIDExecute(Sender: TObject);
begin
  inherited;
  // make a NEW AppID
  PanelSetups.visible:=false;
  PanelActive.visible:=false;
  PanelNewAppID.visible:=true;
  bTreeViewValid:=false;
  if assigned(treeview1) then
    treeView1.enabled:=false;
end;

//------------------------------------------------------------------------------

procedure TfmAppsetups.actSaveNewAppIDExecute(Sender: TObject);
var
  aAppID, aAppPath: string;
begin
  inherited;

  // user clicked on the button to confirm making a new AppID
  aAppID := editAppID.text;
  aAppPath := editAppPath.text;
  if aAppID = '' then
  begin
    msgWarningOk('AppID is blank!');
    Exit;
  end;
  if aAppPath='' then
  begin
    msgWarningOk('Directory value is blank!');
    Exit;
  end;

  MsgWarningOk(pWebApp.Version + ' does not yet link to the wizard for '+
    'making a new AppID definition.  Please use Delphi.  See the ' +
    'Projects > WebHub menu!');
  Exit;


  with pWebApp do
  begin
    AppID := aAppID;
    Refresh;
  end;
end;

//------------------------------------------------------------------------------

procedure TfmAppsetups.btnChooseDirectoryClick(Sender: TObject);
var
  a1:string;
begin
  inherited;
  // user clicked on the elipsis to indicate browsing to choose a directory.
  a1:=editAppPath.text;
  if SelectDirectory( a1, [sdAllowCreate, sdPerformCreate, sdPrompt], 0 ) then begin
    editAppPath.text:=a1;
    end;
end;

//------------------------------------------------------------------------------

procedure TfmAppsetups.BtnCancelNewAppIDClick(Sender: TObject);
begin
  inherited;
  // user clicked on 'CANCEL'
  PanelOpenActive;  // update the stats.
end;

//------------------------------------------------------------------------------

procedure TfmAppsetups.BtnCancelOpenClick(Sender: TObject);
begin
  inherited;
  // user clicked on 'CANCEL'
  panelOpenActive;
end;

//------------------------------------------------------------------------------

procedure TfmAppsetups.BtnSelectAppClick(Sender: TObject);
begin
  inherited;
  // user clicked on SELECT to choose an existing AppID.
  with pWebapp do begin
    AppID:=TreeView1.selected.text;
    //WebMessage('Loading '+AppID);
    refresh;
    //WebMessage('');
    //PanelOpenActive;  // update the stats.
    end;
end;

procedure TfmAppsetups.TreeView1DblClick(Sender: TObject);
var
  tn:TTreeNode;
begin
  inherited;
  application.processMessages;
  tn:=TTreeView(Sender).selected;
  if assigned(tn) then
    BtnSelectAppClick(Sender);
end;

procedure TfmAppsetups.htWebAppUpdate(Sender: TObject);
begin
  inherited;
  panelOpenActive;
end;

//------------------------------------------------------------------------------

procedure TfmAppsetups.actHelpAboutExecute(Sender: TObject);
var
  a1,a2:string;
  b:boolean;
begin
  inherited;
  SplitString(pWebApp.Version,'v',a1,a2);
  b:=posci('trial',a1)>0;
  a1:='You are running "'+ExtractFileName(paramstr(0))+
    '", an application server '
    +'that was built with ';
  if b then
    a1:=a1+'the trial ';
  a1:=a1+'WebHub VCL components v'+a2+', supporting Syntax Stage ' +
    pWebApp.ProjectSyntax + '.'
    +#10#13#10#13+'Copyright 1995-2005 HREF Tools Corp.  All Rights Reserved.';
  msgInfoOk(a1);
end;

//------------------------------------------------------------------------------


procedure TfmAppsetups.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  treeview1.free;
end;

end.


