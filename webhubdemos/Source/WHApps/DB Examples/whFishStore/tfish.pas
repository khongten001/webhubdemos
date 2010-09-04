unit tfish;
(*
Copyright (c) 1995 HREF Tools Corp.
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
  SysUtils, Windows, Classes,
  updateOK,
  webTypes, webVars, webBase, webCore, webApp, htWebApp, //htbdeWApp,
  uTranslations;

type
  TFishSessionVars = class(TWHSessionVars)
  private
    fCurrentFish : Double;
    FFishList: TStringList;
    FMyLingvo: TStoreLingvo;
  protected
    function GetMyLingvo: TStoreLingvo;
    procedure SetFishList(Value: TStringList );
  public
    Constructor Create(aWHSession:TWHSession); override;
    Destructor Destroy; override;
    property MyLingvo: TStoreLingvo read GetMyLingvo write FMyLingvo;
  published
    property CurrentFish : Double read FCurrentFish write FCurrentFish;
    property FishList : TStringList read fFishList write SetFishList;
  end;

  TFishSession = class(TWHSession)
  protected
    function VarsClass: TWHSessionVarsClass; override;
  end;

  TFishApp = class(TwhApplication) // TwhbdeApplication)  Feb 2010
  private
    function ActiveSessionVarsPointer: TFishSessionVars;
  protected
    function GetStoreMessage: string;
    procedure DoExecute; override;
  public
    constructor Create(AOwner: TComponent); override;
    function SessionClass: TWHSessionClass; override;
    property FishVars: TFishSessionVars read ActiveSessionVarsPointer;
  published
    // you could add custom properties here.
    property StoreMessage: string read GetStoreMessage write SetNoString
      stored False;
  end;

implementation

uses
  htmConst;

function TFishSession.VarsClass: TWHSessionVarsClass;
begin
  Result := TFishSessionVars;
end;

Constructor TFishSessionVars.Create(aWHSession:TWHSession);
begin
  inherited Create(aWHSession);
  FFishList := TStringList.create;
end;

Destructor TFishSessionVars.Destroy;
begin
  FreeAndNil(FFishList);
  inherited Destroy;
end;

function TFishSessionVars.GetMyLingvo: TStoreLingvo;
begin
  if Assigned(pWebApp) then
  begin
    if FMyLingvo = lingvoUnknown then
    begin
      if pWebApp.StringVar[cGuestLingvo] = 'eng' then
        FMyLingvo := lingvoEng
      else if pWebApp.StringVar[cGuestLingvo] = 'deu' then
        FMyLingvo := lingvoDeu
      else if pWebApp.StringVar[cGuestLingvo] = 'fra' then
        FMyLingvo := lingvoFra
      else
        FMyLingvo := lingvoUnknown;   // skip Chinese and Russian while in Delphi 7
    end;
    Result := FMyLingvo;
  end
  else
    Result := lingvoUnknown;
end;

procedure TFishSessionVars.SetFishList(Value: TStringList);
begin
  if assigned(fFishList) then
    fFishList.assign(value);
end;

function TFishApp.SessionClass: TWHSessionClass;
begin
  Result := TFishSession;
end;

constructor TFishApp.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

procedure TFishApp.DoExecute;
begin
  inherited;
  if SessionNumber = 0 then Exit;
  if Assigned(FishVars) then
    FishVars.MyLingvo := lingvoUnknown; // reset once per page, in case surfer changes lingvo
end;

function TFishApp.GetStoreMessage: string;
begin
  Result := FishTraduko(lgvFishesUnlimited);
end;


function TFishApp.ActiveSessionVarsPointer: TFishSessionVars;
begin
  if Assigned(pWebApp) and Assigned(pWebApp.Session) then
    Result := TFishSessionVars(TFishApp(pWebApp).Session.Vars)
  else
    Result := nil;
end;

end.

