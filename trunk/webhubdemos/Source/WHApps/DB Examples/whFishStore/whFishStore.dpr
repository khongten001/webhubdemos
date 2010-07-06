program whFishStore;    {The First WebHub Demo. Shows drill-down, graphics manipulation and data entry.}
(*
Copyright (c) 1995 HREF Tools Corp.

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

(*
This demo uses TFishApp and TFishSession, both of which are custom
components which are instantiated at runtime so that you do NOT need
to have them on your palette.

dmFishAp.pas is a copy of the standard dmWhApp.pas data module, with these
changes:
1. The app object was replaced with TFish app and named FishApp1.
2. The session object was replaced with TFishSession.
3. The datamodule was renamed to dmWebHubFishApp.
*)

(* See "How to Work with WebHub Demos.rtf" in the webhubdemos\source\docs folder 
   for information about "drives" H: and K:. *)

uses
  MultiTypeApp in 'h:\MultiTypeApp.pas',
  tpProj in 'h:\tpProj.pas',
  tfish in 'tfish.pas',
  uTranslations in 'uTranslations.pas',
  whFishStore_dmdbProjMgr in 'whFishStore_dmdbProjMgr.pas' {DMForWHFishStore: TDataModule},
  whFishStore_fmWhPanel in 'whFishStore_fmWhPanel.pas' {fmHTFSPanel},
  AdminDM in 'AdminDM.pas' {DataModuleAdmin: TDataModule},
  dmFishAp in 'dmFishAp.pas' {dmWebHubFishApp: TDataModule},
  utpanfrm in 'h:\utPanFrm.pas' {utParentForm},
  utmainfm in 'h:\utMainFm.pas' {fmMainForm},
  uttrayfm in 'h:\utTrayFm.pas' {fmTrayForm},
  whMain in 'h:\whMain.pas' {fmWebHubMainForm},
  webLGrid in 'h:\webLGrid.pas',
  webLink in 'h:\webLink.pas',
  whdemo_About in '..\..\Common\whdemo_About.pas' {fmAppAboutPanel},
  whdemo_Extensions in '..\..\Common\whdemo_Extensions.pas' {DemoExtensions: TDataModule},
  whdemo_Refresh in '..\..\Common\whdemo_Refresh.pas' {dmWhRefresh: TDataModule},
  whdemo_ViewSource in '..\..\Common\whdemo_ViewSource.pas' {DemoViewSource: TDataModule},
  whdemo_Initialize in '..\..\Common\whdemo_Initialize.pas';

{$R *.RES}
{$R HTDEMOS.RES}     // main icon for WebHub demos

begin
  Application.Initialize;
  Application.CreateForm(TDMForWHFishStore, DMForWHFishStore);
  Application.CreateForm(TfmAppAboutPanel, fmAppAboutPanel);
  Application.CreateForm(TDemoExtensions, DemoExtensions);
  Application.CreateForm(TdmWhRefresh, dmWhRefresh);
  Application.CreateForm(TDemoViewSource, DemoViewSource);
  DMForWHFishStore.SetDemoFacts('htfs', 'DB Examples', True);
  DMForWHFishStore.ProjMgr.ManageStartup;
  Application.Run;
end.


