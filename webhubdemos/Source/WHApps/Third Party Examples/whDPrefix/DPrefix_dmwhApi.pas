unit DPrefix_dmwhApi;

{ ---------------------------------------------------------------------------- }
{ * Copyright (c) 2014 HREF Tools Corp.  All Rights Reserved Worldwide.      * }
{ *                                                                          * }
{ * This source code file is part of the Delphi Prefix Registry.             * }
{ *                                                                          * }
{ * This file is licensed under a Creative Commons Attribution 2.5 License.  * }
{ * http://creativecommons.org/licenses/by/2.5/                              * }
{ * If you use this file, please keep this notice intact.                    * }
{ *                                                                          * }
{ * Author: Ann Lynnworth                                                    * }
{ *                                                                          * }
{ * Refer friends and colleagues to www.href.com/whvcl. Thanks!              * }
{ ---------------------------------------------------------------------------- }

interface

uses
  SysUtils, Classes,
  webLink, updateOK, tpAction, webTypes;

type
  TDMWHAPI = class(TDataModule)
    waJsonApiRequest: TwhWebAction;
    procedure DataModuleCreate(Sender: TObject);

/// <summary> WebHub Action component, called from pageid="jsonapirequest".
/// </summary>
/// <param name="Sender">Sender will be the TwhWebAction named waJsonApiRequest
/// </param>
    procedure waJsonApiRequestExecute(Sender: TObject);
  private
    { Private declarations }
    FlagInitDone: Boolean;
    procedure WebAppUpdate(Sender: TObject);
  public
    { Public declarations }
    function Init(out ErrorText: string): Boolean;
  end;

var
  DMWHAPI: TDMWHAPI;

implementation

{$R *.dfm}

uses
  {$IFDEF CodeSite}CodeSiteLogging,{$ENDIF}
  webApp, htWebApp, ucCodeSiteInterface;

{ TDM001 }

procedure TDMWHAPI.DataModuleCreate(Sender: TObject);
begin
  FlagInitDone := False;
end;

function TDMWHAPI.Init(out ErrorText: string): Boolean;
const cFn = 'Init';
begin
  CSEnterMethod(Self, cFn);
  ErrorText := '';
  // reserved for code that should run once, after AppID set
  if NOT FlagInitDone then
  begin

    if Assigned(pWebApp) and pWebApp.IsUpdated then
    begin
      // Call RefreshWebActions here only if it is not called within a TtpProject event
      // RefreshWebActions(Self);

      // helpful to know that WebAppUpdate will be called whenever the
      // WebHub app is refreshed.
      AddAppUpdateHandler(WebAppUpdate);
      FlagInitDone := True;
    end;
  end;
  Result := FlagInitDone;
  CSSend('Result', S(Result));
  CSExitMethod(Self, cFn);
end;

procedure TDMWHAPI.waJsonApiRequestExecute(Sender: TObject);
var
  URL_Command: string;
  AJSONResponseStr: string;
  FlagReadonlySession: Boolean;
begin
  AJSONResponseStr := '';
  FlagReadonlySession := pWebApp.IsReadOnlySessionNumber(pWebApp.SessionNumber);

  URL_Command := pWebApp.Command;
  if Pos('Version=1.0;', URL_Command) > 0 then
  begin
    if Pos('RequestType=APIInfo;', URL_Command) > 0 then
    begin
      if Pos('RequestTypeVersion=1.0', URL_Command) > 0 then
      begin
        if Pos('DetailLevel=Versions;', URL_Command) > 0 then
        begin
          if FlagReadonlySession then
            AJSONResponseStr := pWebApp.Tekero['drJsonDetailLevel_Versions_1_0'];
        end
        else
        if Pos('DetailLevel=ImageList;', URL_Command) > 0 then
        begin
          if FlagReadonlySession then
          begin
            AJSONResponseStr := pWebApp.Tekero['drJsonDetailLevel_ImageList_1_0'];
            AJSONResponseStr := pWebApp.Expand(AJSONResponseStr);
          end;
        end
        else
        if Pos('DetailLevel=LingvoList;', URL_Command) > 0 then
        begin
          if FlagReadonlySession then
            AJSONResponseStr := pWebApp.Tekero['drJsonDetailLevel_LingvoList_1_0'];
        end
        else
        if Pos('DetailLevel=TradukoList;', URL_Command) > 0 then
        begin
          if FlagReadonlySession then
            AJSONResponseStr := pWebApp.Tekero['drJsonDetailLevel_TradukoList_1_0'];
        end
        else
        if Pos('DetailLevel=WebAppAPISpec;', URL_Command) > 0 then
        begin
          AJSONResponseStr := pWebApp.Tekero['drJsonDetailLevel_WebAppAPISpec_1_0'];
          AJSONResponseStr := pWebApp.Expand(AJSONResponseStr);
        end;
      end;
    end;
  end;

  if AJSONResponseStr = '' then
    AJSONResponseStr := pWebApp.Tekero['drJsonDetailLevel_Invalid'];

  pWebApp.SendStringImm(AJSONResponseStr);
end;

procedure TDMWHAPI.WebAppUpdate(Sender: TObject);
const cFn = 'WebAppUpdate';
begin
  CSEnterMethod(Self, cFn);
  // placeholder
  CSExitMethod(Self, cFn);
end;

end.
