unit scanfm;
(*
Copyright (c) 1997-2013 HREF Tools Corp.
Author: Ann Lynnworth

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

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, ExtCtrls, StdCtrls, DB, DBClient, Buttons, Grids,
  DBGrids, DBCtrls, MidasLib, Provider, SimpleDS,
  Toolbar, {}tpCompPanel, ucstring, UTPANFRM, updateOk,
  tpAction, tpStatus;

type
  TfmDBPanel = class(TutParentForm)
    tpStatusBar1: TtpStatusBar;
    Panel1: TPanel;
    DBGrid2: TDBGrid;
    DBNavigator2: TDBNavigator;
    tpToolBar: TtpToolBar;
    tpToolButton1: TtpToolButton;
    tpComponentPanel2: TtpComponentPanel;
    procedure tpToolButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function Init: Boolean; override;
  end;

var
  fmDBPanel: TfmDBPanel;

implementation

{$R *.DFM}

uses
  {$IFDEF CodeSite}CodeSiteLogging,{$ENDIF}
  {Reference http://www.codenewsfast.com/cnf/article/0/waArticleBookmark.7311195
   Exception "unknown driver Firebird" exception is raised if DBXFirebird unit
   omitted from uses clause. }
  DBXFirebird,
  MultiTypeApp,
  ucCodeSiteInterface,
  whScanTable_whdmData,
  ucDlgs;  // ucDlgs is part of TPack. msgErrorOk is in this unit.

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

function TfmDBPanel.Init: Boolean;
begin
  Result := inherited Init;
  if Result then
  begin
  end;
end;

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

procedure TfmDBPanel.tpToolButton1Click(Sender: TObject);
begin
  inherited;
  // This procedure makes the grid display within the running app, so you
  // can see the data.  It does not impact the web pages at all.
  // You can run this app without ever activating the visible
  // controls.
  if NOT Assigned(dbNavigator2.DataSource) then
  begin
    dbNavigator2.DataSource:=DMData.DataSource1;
    dbGrid2.DataSource:=DMData.DataSource1;
    if Assigned(DMData.DataSource1.DataSet) then
    begin
      if DMData.DataSource1.DataSet is TSimpleDataSet then
      begin
        MsgInfoOk(Format('Connection Params: %s',
          [TSimpleDataSet(dbGrid2.DataSource.DataSet).Connection.Params.Text
          ]));
      end
      else
        MsgWarningOk(Format('DataSet.ClassName is %s',
          [DMData.DataSource1.DataSet.ClassName]));
      DMData.DataSource1.DataSet.Active := True;
    end
    else
      MsgWarningOk('dbGrid2.DataSource.DataSet is nil');
  end
  else
  begin
    dbNavigator2.DataSource:=nil;
    dbGrid2.DataSource:=nil;
  end;
end;

end.
