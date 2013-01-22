unit appcgi;  //to use form inheritance, see notes in AppForm.pas
////////////////////////////////////////////////////////////////////////
//  Copyright (c) 1995-97 HREF Tools Corp.  All Rights Reserved.      //
//  This source is a part of the WebHub(tm) Component Package.        //
//  You may not redistribute this file unless you redistribute the    //
//  entire WebHub(tm) Trial Package. The full license is on the web.  //
//  http://www.href.com/webhub/  http://www.href.com/techsupport.html //
////////////////////////////////////////////////////////////////////////


(*
The purpose of this demo is to show how you can do basic CGI operations
with the fewest WebHub components. No app object, no save state, no web
actions -- but -- simplicity.

Optional: Analyze the Request.QueryString to determine what you want
your program to do...

Author: Michael Ax @HREF Tools Corp.
        June 1, 1998

*)




interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  {$I xe_actnlist.inc}
  StdActns, OleCtrls,
  GridRest, tpSysPop, tpTrayIc, tpAction, webinfou, UpdateOk,
  UTTRAYFM, HtmlBase, HtmlCore, tpApplic{non-gui}, WebBrows, CGiVarS, APiStat,
  ApiBuilt, ApiCall, WebCall, CGiServ, WebServ, WebLink,
  Menus, tpPopUp, Restorer, RestEdit, WebTypes, IniLink, ComCtrls,
  tpStatus, Toolbar, ExtCtrls, Combobar, SHDocVw;

type
  TfmWebAppCGI = class(TForm)
    Request: TwhRequest;
    CentralInfo: TwhCentralInfo;
    WebCommandLine: TwhConnection;
    WebBrowser: TWebBrowser;
    tpApplication1: TtpApplication;
    Response: TwhResponseSimple;
    tpStatusBar: TtpStatusBar;
    MainMenu1: TMainMenu;
    ActionList1: TActionList;
    FileExit1: TFileExit;
    File1: TMenuItem;
    Exit1: TMenuItem;
    procedure tpApplication1Idle(Sender: TObject; var Done: Boolean);
    procedure WebCommandLineExecute(Sender: TObject);
    end;

var
  fmWebAppCGI: TfmWebAppCGI;

implementation

uses
  WebSplat,
  whconst,
  ucString;

{$R *.DFM}

// -----------------------------------------------------------------------------

procedure TfmWebAppCGI.tpApplication1Idle(Sender:TObject;var Done:Boolean);
begin
  inherited;
  if assigned(WebCommandLine) then
    WebCommandLine.DoIdle(Sender,Done);
end;

procedure TfmWebAppCGI.WebCommandLineExecute(Sender: TObject);

  procedure SendList(Strings:TStrings);
  begin
    with TwhResponseSimple(Response) do
      if strings.count=0 then
        send('(none)<br>')
      else
        SendStringListBr(Strings);
  end;

begin
  inherited;
  // this test is here in case you use this form in a project that *does* have a webapp!
  with WebCommandline do begin
    if assigned(WebApp)
    or not assigned(Response)
    or not assigned(Request)
    then
      exit;
  // Ok. As intended - this project has no webapp or Session objects.
  // Therefore no webactions are supported.
  //(v1.494 bug: Request creates twebbrowserinfo even though it should not!)
  //Must use Response as a TwhResponseSimple instead of TwhResponse
  //
  with Request,Response do begin  //webcall
      Send('<html><body>');
      SendHDR('1','Demonstration of a webhub application without a TwhAppBase component');
      Send('<b>QueryString: '+WebCommandline.QueryString+'</b><p>');
      Send(paramstr(0)+'<br>');
      Send('procedure TfmWebAppCGI.WebCommandLineExecute(Sender: TObject);');
      Send('<hr>Request.FormLiterals:<br>');   SendList(FormLiterals);
      Send('<hr>Request.ServerVariables:<br>');      SendList(ServerVariables);
      Send('<hr>Request.Cookies:<br>');        SendList(Cookies);
      Send('<hr>Request.dbFields:<br>');       SendList(dbFields);
      //Send('<hr>Request.dbMemos<br>');        SendList(Cookies);
      Send('<hr>Request.ExtraHeaders:<br>');   SendList(ExtraHeaders);
      Send('<hr>Request.FormFiles:<br>');      SendList(FormFiles);
      Send('<hr>Request.SystemValues:<br>');   SendList(SystemValues);
      //Send('<hr>Request.TxtVars<br>');      SendList(Cookies);
      Send('<hr></body></html>');
      end;
    end;
end;

end.

