program whQuery3; {Query example, surfer enters SQL statement.}
(*
Copyright (c) 1999 HREF Tools Corp.

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

(* See "How to Work with WebHub Demos.rtf" in the webhubdemos\source\docs folder 
   for information about "drives" H: and K:. *)

uses
  MultiTypeApp in 'h:\MultiTypeApp.pas',
  tpProj in 'h:\tpProj.pas',
  utpanfrm in 'h:\utpanfrm.pas' {utParentForm},
  utmainfm in 'h:\utMainFm.pas' {fmMainForm},
  uttrayfm in 'h:\utTrayFm.pas' {fmTrayForm},
  whdemo_Initialize in '..\..\Common\whdemo_Initialize.pas',
  whdemo_About in '..\..\Common\whdemo_About.pas' {fmAppAboutPanel},
  whdemo_Extensions in '..\..\Common\whdemo_Extensions.pas' {DemoExtensions: TDataModule},
  whdemo_ViewSource in '..\..\Common\whdemo_ViewSource.pas' {DemoViewSource: TDataModule},
  whdemo_CodeSite in '..\..\Common\whdemo_CodeSite.pas',
  whdemo_UIHelpers in '..\..\Common\whdemo_UIHelpers.pas',
  whpanel_RemotePages in 'h:\whpanel_RemotePages.pas' {fmWhDreamweaver: TfmWhDreamweaver},
  whsample_EvtHandlers in 'H:\whsample_EvtHandlers.pas' {whdmCommonEventHandlers: TDataModule},
  dmwhBDEApp in 'h:\dmwhBDEApp.pas' {dmWebHubBDEApp: TdmWebHubDBApp},
  whMain in 'h:\whMain.pas' {fmWebHubMainForm},
  htqry3DM in 'htqry3DM.PAS' {DataModuleQ3: TDataModule},
  whdemo_DMDBProjMgr in '..\..\Common\whdemo_DMDBProjMgr.pas' {DMForWHDBDemo: TDataModule},
  whQuery3_dmdbProjMgr in 'whQuery3_dmdbProjMgr.pas' {DMForWHQuery3: TDataModule};

{$R *.RES}
{$R HTDEMOS.RES}     // main icon for WebHub demos
{..$R HTICONS.RES}   // component icons for combo bar, needed if compiling without WH package
{..$R HTGLYPHS.RES}  // icons for WebHub UI features, needed if compiling without WH package

begin
  {M}Application.Initialize;
  {M}Application.CreateForm(TDMForWHQuery3, DMForWHQuery3);
  DMForWHQuery3.SetDemoFacts('htq3', 'DB Examples',True);
  DMForWHQuery3.ProjMgr.ManageStartup;
  {M}Application.Run;
end.
