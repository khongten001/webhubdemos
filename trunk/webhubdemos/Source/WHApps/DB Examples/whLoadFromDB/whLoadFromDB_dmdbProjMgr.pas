unit whLoadFromDB_dmdbProjMgr;

(*
Copyright (c) 2004-2014 HREF Tools Corp.

Permission is hereby granted, on 2-Feb-2013, free of charge, to any person
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
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, whdemo_DMDBProjMgr, tpProj;

type
  TDMForWHLoadFromDB = class(TDMForWHDBDemo)
    procedure ProjMgrGUICreate(Sender: TtpProject;
      const ShouldEnableGUI: Boolean; var ErrorText: String;
      var Continue: Boolean);
    procedure ProjMgrDataModulesCreate3(Sender: TtpProject;
      var ErrorText: String; var Continue: Boolean);
    procedure ProjMgrDataModulesInit(Sender: TtpProject;
      var ErrorText: String; var Continue: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DMForWHLoadFromDB: TDMForWHLoadFromDB;

implementation

{$R *.dfm}

uses
  MultiTypeApp,
  {$IFNDEF PREVENTGUI}
  whLoadFromDB_fmWhAppDBHTML,
  {$ENDIF}
  whLoadFromDB_dmwhData;

procedure TDMForWHLoadFromDB.ProjMgrDataModulesCreate3(Sender: TtpProject;
  var ErrorText: String; var Continue: Boolean);
begin
  inherited;
  {M}Application.CreateForm(TDMContent, DMContent);
end;

procedure TDMForWHLoadFromDB.ProjMgrDataModulesInit(Sender: TtpProject;
  var ErrorText: String; var Continue: Boolean);
begin
  inherited;
  Continue := DMContent.Init(ErrorText);
end;

procedure TDMForWHLoadFromDB.ProjMgrGUICreate(Sender: TtpProject;
  const ShouldEnableGUI: Boolean; var ErrorText: String;
  var Continue: Boolean);
begin
  inherited;
  {$IFNDEF PREVENTGUI}
  if ShouldEnableGUI then
  begin
    {M}Application.CreateForm(TfmAppDBHTML, fmAppDBHTML);
  end;
  {$ENDIF}
end;

end.

