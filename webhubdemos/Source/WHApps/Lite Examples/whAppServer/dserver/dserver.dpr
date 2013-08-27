program dserver;  { WebHub App EXE for use with Dreamweaver }

// Usage: dserver.exe /ID:AppID

(* See "How to Work with WebHub Demos.rtf" in the webhubdemos\source\docs folder
   for information about "drives" H: and K:. *)

(*
  preserve this line for when the Delphi IDE and/or EurekaLog wizard erases it
  {$I dserver_uses.inc}
*)

uses
  {$I dserver-dpr.inc}
  dserver_whdmGeneral in 'dserver_whdmGeneral.pas' {dmwhGeneral: TDataModule},
  dserver_dmProjMgr in 'dserver_dmProjMgr.pas' {DMForDServer: TDataModule};

{$R dserver_version.RES}
{$R WHDICON.RES}   // dserver tray icon
{$R HTICONS.RES}   // component icons for combo bar (not essential)
{$R HTGLYPHS.RES}  // icons for WebHub UI features

var
  DemoAppID: string;

begin
  Application.Initialize;
  Application.CreateForm(TDMForDServer, DMForDServer);

  {$IFDEF PREVENTSVCMGR}
  if HaveParam('/id') then
    ParamValue('id', DemoAppID)
  else
    DemoAppID := 'adv';
  {$ELSE}
  DemoAppID := 'adv';
  {$ENDIF}

  DMForDServer.SetDemoFacts(DemoAppID, 'Lite Examples\whAppServer',
    True);
  DMForDServer.ProjMgr.ManageStartup;
  Application.Run;
end.


