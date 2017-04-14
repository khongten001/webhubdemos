unit whDynamicJPEG_dmProjMgr;

(*
Copyright (c) 2013-2017 HREF Tools Corp.

Permission is hereby granted, on 29-Jan-2013, free of charge, to any person
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
  Dialogs, whdemo_DMProjMgr, tpProj;

type
  TDMForWHDynamicJPEG = class(TDMForWHDemo)
    procedure ProjMgrGUICreate(Sender: TtpProject;
      const ShouldEnableGUI: Boolean; var ErrorText: String;
      var Continue: Boolean);
    procedure ProjMgrGUIInit(Sender: TtpProject;
      const ShouldEnableGUI: Boolean; var ErrorText: String;
      var Continue: Boolean);
    procedure ProjMgrDataModulesCreate3(Sender: TtpProject;
      var ErrorText: string; var Continue: Boolean);
    procedure ProjMgrDataModulesInit(Sender: TtpProject; var ErrorText: string;
      var Continue: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DMForWHDynamicJPEG: TDMForWHDynamicJPEG;

implementation

{$R *.dfm}

uses
  MidasLib,  // avoid MIDAS.DLL uppercase issue
  MultiTypeApp, whDynamicJPEG_fmWh, whDynamicJPEG_dmwhData;

procedure TDMForWHDynamicJPEG.ProjMgrDataModulesCreate3(Sender: TtpProject;
  var ErrorText: string; var Continue: Boolean);
begin
  inherited;
  Application.CreateForm(TDMBIOLIFE, DMBIOLIFE);
end;

procedure TDMForWHDynamicJPEG.ProjMgrDataModulesInit(Sender: TtpProject;
  var ErrorText: string; var Continue: Boolean);
begin
  inherited;
  Continue := DMBIOLIFE.Init(ErrorText);
end;

procedure TDMForWHDynamicJPEG.ProjMgrGUICreate(Sender: TtpProject;
  const ShouldEnableGUI: Boolean; var ErrorText: String;
  var Continue: Boolean);
begin
  inherited;
  {M}Application.CreateForm(TfmWhAnimals, fmWhAnimals);

end;

procedure TDMForWHDynamicJPEG.ProjMgrGUIInit(Sender: TtpProject;
  const ShouldEnableGUI: Boolean; var ErrorText: String;
  var Continue: Boolean);
begin
  inherited;
  fmWhAnimals.Init;
end;

end.

