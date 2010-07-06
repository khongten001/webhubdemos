program whStopSpam;     {demonstrates SOAP plus using the MAILTO macro to lessen likelihood of spam when email addresses are published}
(*
Copyright (c) 2002-2010 HREF Tools Corp.

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
  utMainFm in 'h:\utMainFm.pas' {fmMainForm},
  utTrayFm in 'h:\utTrayFm.pas' {fmTrayForm},
  whdemo_Initialize in '..\..\Common\whdemo_Initialize.pas',
  whdemo_About in '..\..\Common\whdemo_About.pas' {fmAppAboutPanel},
  whdemo_Extensions in '..\..\Common\whdemo_Extensions.pas' {DemoExtensions: TDataModule},
  whdemo_ViewSource in '..\..\Common\whdemo_ViewSource.pas' {DemoViewSource: TDataModule},
  whdemo_Refresh in '..\..\Common\whdemo_Refresh.pas' {dmWhRefresh: TDataModule},
  whsample_EvtHandlers in 'h:\whsample_EvtHandlers.pas' {whdmCommonEventHandlers: TDataModule},
  whStopSpam_fmWh in 'whStopSpam_fmWh.pas' {fmUnicodePanel},
  whdemo_DMProjMgr in '..\..\Common\whdemo_DMProjMgr.pas' {DMForWHDemo: TDataModule},
  whStopSpam_dmProjMgr in 'whStopSpam_dmProjMgr.pas' {DMForWHStopSpam: TDataModule};

{$R *.RES}
{$R HTDEMOS.RES}     // main icon for WebHub demos
{$R HTICONS.RES}   // component icons for combo bar, needed if compiling without WH package
{$R HTGLYPHS.RES}  // icons for WebHub UI features, needed if compiling without WH package

(* when compiling with source, could use these units
  webSOAPPublish in 'K:\WebHub\lib\whplus\webSOAPPublish.pas',
  webSOAPInvoke in 'K:\WebHub\lib\whplus\webSOAPInvoke.pas',
  webSOAPInfo in 'K:\WebHub\lib\whplus\webSOAPInfo.pas',
  webMailV in 'K:\WebHub\lib\whplus\webMailV.pas',
  websoaphost in 'K:\WebHub\lib\whplus\websoaphost.pas',
  webSOAPDispatch in 'K:\WebHub\lib\whplus\webSOAPDispatch.pas',
*)

begin
  Application.Initialize;
  Application.CreateForm(TDMForWHStopSpam, DMForWHStopSpam);
  DMForWHStopSpam.SetDemoFacts('htun', 'More Examples', True);
  DMForWHStopSpam.ProjMgr.ManageStartup;
  Application.Run;
end.

