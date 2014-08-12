unit CodeSiteLogging; // placeholder unit for use when CodeSite not available
                      // for example, when compiling with FreePascal

(*
  Copyright (c) 2011-2014 HREF Tools Corp.

  Permission is hereby granted, on 23-Jul-2011, free of charge, to any person
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

  Author of original version of this file: Ann Lynnworth
*)

{$I hrefdefines.inc}

{$DEFINE XFER2CodeSite}

interface

uses
  SysUtils, Classes,
  ucConvertStrings
  {$IFDEF XFER2CodeSite}, tpShareB{$ENDIF}
  ;

const
  csmGreen: Integer = 1;
  csmYellow: Integer = 1;
const
  CodeSite_Version = '5.1XFer';

function InitCodeSiteTransfer: Boolean;

type
  TCodeSiteDestination = class;

  TCodeSiteLogFile = class
  public
    FilePath: string;
    FileName: string;
    Active: Boolean;
  end;

  TCodeSiteDestination = class
  {$IFDEF UNICODE_INCL_FPC}strict{$ENDIF} private
    FLogFIle: TCodeSiteLogFile;
  public
    property LogFile: TCodeSiteLogFile read FLogFile write FLogFile;
    constructor Create( AOwner: TComponent );
    destructor Destroy; override;
  end;

type
  TDestinationRec = class
  public
    function AsString: UnicodeString;
    function ToString: string; {$IF Defined(FPC) or Defined(Delphi16UP)}override; {$IFEND}
  end;

type
  TCodeSiteFake = class // for use when CodeSite not available during beta test
  private
    FCategory: string;
    FCategoryFontColor: Integer;
    FDestination: TCodeSiteDestination;
    FUseCodeSiteManagerConnection: Boolean;
    {$IFDEF XFER2CodeSite}
    FSharedBuf: TSharedBuf;
    {$ENDIF}
    procedure ClearBuf;
    procedure SetDestination(Value: TCodeSiteDestination);
  public
    constructor Create;
    destructor Destroy; override;
    function Installed: Boolean;
    procedure EnterMethod(const S: UnicodeString); overload;
    procedure EnterMethod(c: TObject; const S: UnicodeString); overload;
    procedure ExitMethod(const S: UnicodeString); overload;
    procedure ExitMethod(c: TObject; const S: UnicodeString); overload;
    procedure SendNote(const S: UnicodeString);
    procedure SendReminder(const S: UnicodeString);
    procedure SendWarning(const S: UnicodeString);
    procedure SendError(const S: UnicodeString);
    procedure SendException(E: Exception);
    procedure Send(const a1: UnicodeString); overload;
    procedure Send(const i: Integer; const TextA: UnicodeString;
      const TextB: UnicodeString = ''); overload;
    procedure Send(const a1, a2: UnicodeString); overload;
    procedure Send(const a1: UnicodeString; const i2: Integer); overload;
    procedure Send(const a1: UnicodeString; const b2: Boolean); overload;
    procedure Send( const Fmt: UnicodeString; const Args: array of const ); overload;
    procedure Write(const a1, a2: UnicodeString);
    property Category: string read FCategory write FCategory;
    property CategoryFontColor: Integer read FCategoryFontColor
      write FCategoryFontColor;
    property Destination: TCodeSiteDestination read FDestination write
      SetDestination;
    {$IFDEF XFER2CodeSite}
    property SharedBuf: TSharedBuf read FSharedBuf;
    {$ENDIF}
    procedure UseCodeSiteManagerConnection;
  end;

type
  TCodeSiteManagerFake = class
  private
    FDefaultDestination: TDestinationRec;
    FEnabled: Boolean;
    procedure SetEnabled(Value: Boolean);
  public
    constructor Create;
    destructor Destroy; override;
    procedure ConnectUsingTcp; overload;
    procedure ConnectUsingTcp(const a: string; const i: Integer); overload;
    property DefaultDestination: TDestinationRec read FDefaultDestination;
    property Enabled: Boolean read FEnabled write SetEnabled;
  end;

var
  CodeSite: TCodeSiteFake = nil;
  CodeSiteManager: TCodeSiteManagerFake = nil;

implementation

uses
  uCode  // placeholder unit name
  {$IFDEF FPC}, lazUTF8{$ENDIF}
{$IFNDEF XFER2CodeSite}, ucLogFil{$ENDIF}
  ;

{ TCodeSiteFake }

(* destructor TCodeSiteManagerFake.Destroy;
  begin
  FreeAndNil(FDefaultDestination);
  end; *)

destructor TCodeSiteFake.Destroy;
begin
  {$IFDEF XFER2CodeSite}
  FreeAndNil(FSharedBuf);
  {$ENDIF}
end;

function ABC(const a: Integer; const b, c: UnicodeString): UTF8String;
var
  combo: UnicodeString;
  a8: UTF8String;
begin
  combo := {$IFDEF FPC}ConvAto16{$ENDIF}(IntToStr(a)) + '^^' + b + '^^' + c;

  a8 := Conv16to8(combo);

  Result := a8;
  if Length(Result) > 2048 then
    Result := Copy(Result, 1, 2032);
end;

procedure TCodeSiteFake.EnterMethod(c: TObject; const S: UnicodeString);
begin
  if Assigned(c) and (c is TComponent) then
  begin
    {$IFDEF XFER2CodeSite}
    ClearBuf;
    FSharedBuf.GlobalUTF8String := ABC(6, TComponent(c).ClassName + '.' +
      TComponent(c).Name, S);
    {$ELSE}
    HREFTestLog('>>', TComponent(c).ClassName + ' ' + TComponent(c).Name, S)
    {$ENDIF}
  end
  else
  begin
    {$IFDEF XFER2CodeSite}
    ClearBuf;
    FSharedBuf.GlobalUTF8String := ABC(6, S, '');
    {$ELSE}
    HREFTestLog('>>', '', S);
    {$ENDIF}
  end;
end;

procedure TCodeSiteFake.EnterMethod(const S: UnicodeString);
begin
  {$IFDEF XFER2CodeSite}
  ClearBuf;
  FSharedBuf.GlobalUTF8String := ABC(6, S, '');
  {$ELSE}
  HREFTestLog('>>', '', S);
  {$ENDIF}
end;

procedure TCodeSiteFake.ExitMethod(c: TObject; const S: UnicodeString);
begin
  if Assigned(c) and (c is TComponent) then
  begin
    {$IFDEF XFER2CodeSite}
    ClearBuf;
    FSharedBuf.GlobalUTF8String := ABC(7, TComponent(c).ClassName + '.' +
      TComponent(c).Name, S);
    {$ELSE}
    HREFTestLog('<<', TComponent(c).ClassName + ' ' + TComponent(c).Name, S)
    {$ENDIF}
  end
  else
  begin
    {$IFDEF XFER2CodeSite}
    ClearBuf;
    FSharedBuf.GlobalUTF8String := ABC(7, S, '');
    {$ELSE}
    HREFTestLog('<<', '', S);
    {$ENDIF}
  end;
end;

procedure TCodeSiteFake.ClearBuf;
begin
  {$IFDEF XFER2CodeSite}
  Sleep(10);  // slow the stream to the TSharedBuf
  {$ENDIF}
end;

constructor TCodeSiteFake.Create;
begin
  {$IFDEF XFER2CodeSite}
  FSharedBuf := TSharedBuf.CreateNamed(nil, 'CodeSiteIPC',
    1024 * SizeOf(Char), cReadWriteSharedMem, cLocalSharedMem); // NOT readonly; LOCAL not global
  FSharedBuf.Name := 'FSharedBuf';
  {$ENDIF}
end;

function TCodeSiteFake.Installed: Boolean;
begin
  Result := False;
end;

function TDestinationRec.AsString: UnicodeString;
begin
  Result := ToString;
end;

function TDestinationRec.ToString: string;
begin
  Result := 'n/a';
end;

procedure TCodeSiteFake.ExitMethod(const S: UnicodeString);
begin
  {$IFDEF XFER2CodeSite}
  ClearBuf;
  FSharedBuf.GlobalUTF8String := ABC(7, S, '');
  {$ELSE}
  HREFTestLog('<<', '', S);
  {$ENDIF}
end;

procedure TCodeSiteFake.Send(const a1: UnicodeString);
begin
  {$IFDEF XFER2CodeSite}
  ClearBuf;
  FSharedBuf.GlobalUTF8String := ABC(1, a1, '');
  {$ELSE}
  HREFTestLog(1, a1, '');
  {$ENDIF}
end;

procedure TCodeSiteFake.Send(const a1: UnicodeString; const i2: Integer);
begin
  {$IFDEF XFER2CodeSite}
  ClearBuf;
  FSharedBuf.GlobalUTF8String := ABC(1, a1, IntToStr(i2));
  {$ELSE}
  HREFTestLog('info', a1, IntToStr(i2));
  {$ENDIF}
end;

procedure TCodeSiteFake.Send(const i: Integer; const TextA: UnicodeString;
  const TextB: UnicodeString = '');
begin
  // color integer is lost in this fake transfer
  Send(TextA, TextB);
end;

procedure TCodeSiteFake.Send(const a1, a2: UnicodeString);
begin
  {$IFDEF XFER2CodeSite}
  ClearBuf;
  FSharedBuf.GlobalUTF8String := ABC(1, a1, a2);
  {$ELSE}
  HREFTestLog('info', a1, a2);
  {$ENDIF}
end;

procedure TCodeSiteFake.SendError(const S: UnicodeString);
begin
  {$IFDEF XFER2CodeSite}
  ClearBuf;
  FSharedBuf.GlobalUTF8String := ABC(3, S, '');
  {$ELSE}
  HREFTestLog('error', S, '');
  {$ENDIF}
end;

procedure TCodeSiteFake.SendException(E: Exception);
begin
  {$IFDEF XFER2CodeSite}
  ClearBuf;
  FSharedBuf.GlobalUTF8String := ABC(5, E.Message, '');
  {$ELSE}
  HREFTestLog('exception', E.Message, '');
  {$ENDIF}
end;

procedure TCodeSiteFake.SendNote(const S: UnicodeString);
begin
  {$IFDEF XFER2CodeSite}
  ClearBuf;
  FSharedBuf.GlobalUTF8String := ABC(4, S, '');
  {$ELSE}
  HREFTestLog('note', S, '');
  {$ENDIF}
end;

procedure TCodeSiteFake.SendReminder(const S: UnicodeString);
begin
  {$IFDEF XFER2CodeSite}
  ClearBuf;
  FSharedBuf.GlobalUTF8String := ABC(10, S, '');
  {$ELSE}
  HREFTestLog('reminder', S, '');
  {$ENDIF}
end;

procedure TCodeSiteFake.SendWarning(const S: UnicodeString);
begin
  {$IFDEF XFER2CodeSite}
  ClearBuf;
  FSharedBuf.GlobalUTF8String := ABC(2, S, '');
  {$ELSE}
  HREFTestLog('warning', S, '');
  {$ENDIF}
end;

procedure TCodeSiteFake.SetDestination(Value: TCodeSiteDestination);
begin
  if Self <> nil then
  begin
    FDestination := Value;
    {$IFDEF XFER2CodeSite}
    ClearBuf;
    if (Value <> nil) and (Value.LogFile <> nil) then
    begin
      with Value do
      begin
        if (LogFile.FilePath <> '') and (LogFile.FileName <> '') then
          FSharedBuf.GlobalUTF8String := ABC(8, LogFile.FilePath,
            LogFile.FileName);
      end;
    end;
    {$ENDIF}
  end;
end;

procedure TCodeSiteFake.UseCodeSiteManagerConnection;
begin
  FUseCodeSiteManagerConnection := True;
end;

procedure TCodeSiteFake.Write(const a1, a2: UnicodeString);
begin
  Send(a1, a2);
end;

{ TCodeSiteManagerFake }

procedure TCodeSiteManagerFake.ConnectUsingTcp(const a: string;
  const i: Integer);
begin
  // do nothing
end;

procedure TCodeSiteManagerFake.ConnectUsingTcp;
begin
  // do nothing
end;

constructor TCodeSiteManagerFake.Create;
begin
  inherited;
  FDefaultDestination := TDestinationRec.Create;
end;

destructor TCodeSiteManagerFake.Destroy;
begin
  FreeAndNil(FDefaultDestination);
  inherited;
end;

procedure TCodeSiteManagerFake.SetEnabled(Value: Boolean);
begin
  if Self <> nil then
  begin
    {$IFDEF XFER2CodeSite}
    if Assigned(CodeSite) and Assigned(CodeSite.SharedBuf) then
      CodeSite.ClearBuf;
      CodeSite.SharedBuf.GlobalUTF8String := ABC(9, BoolToStr(Value, True), '');
    {$ENDIF}
    FEnabled := Value;
  end;
end;

procedure TCodeSiteFake.Send(const a1: UnicodeString; const b2: Boolean);
begin
  Send(a1, BoolToStr(b2, True));
end;

procedure TCodeSiteFake.Send(const Fmt: UnicodeString; const Args: array of const);
begin
  try
    Send(XFormat( Fmt, Args ), '' );
  except
    on E: EConvertError do
      SendError( 'Send Error: Invalid Format Arguments' );
  end;
end;

{ TCodeSiteDestination }

constructor TCodeSiteDestination.Create(AOwner: TComponent);
begin
  FLogFile := TCodeSiteLogFile.Create;
end;

destructor TCodeSiteDestination.Destroy;
begin
  FreeAndNil(FLogFile);
  inherited;
end;


function InitCodeSiteTransfer: Boolean;
begin
  if CodeSite = nil then
  begin
    CodeSite := TCodeSiteFake.Create;
    CodeSiteManager := TCodeSiteManagerFake.Create;
  end;
  Result := True;
end;

initialization
  InitCodeSiteTransfer;

finalization
  FreeAndNil(CodeSite);
  FreeAndNil(CodeSiteManager);

end.
