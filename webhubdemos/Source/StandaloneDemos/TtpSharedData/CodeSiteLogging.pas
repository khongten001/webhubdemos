unit CodeSiteLogging; // placeholder unit for use when CodeSite not available
                      // for example, when compiling with FreePascal

(*
  Copyright (c) 2011 HREF Tools Corp.

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
  SysUtils, Classes
  {$IFDEF XFER2CodeSite}, tpShareB{$ENDIF}
  ;

const
  csmGreen: Integer = 1;
  csmYellow: Integer = 1;

type
  TDestinationRec = class
  public
    function AsString: string;
    function ToString: string; {$IFDEF Delphi16UP}override; {$ENDIF}
  end;

type
  TCodeSiteFake = class // for use when CodeSite not available during beta test
  private
    FCategory: string;
    FCategoryFontColor: Integer;
    FUseCodeSiteManagerConnection: Boolean;
    {$IFDEF XFER2CodeSite}
    FSharedBuf: TtpSharedBuf;
    {$ENDIF}
  public
    constructor Create;
    destructor Destroy; override;
    function Installed: Boolean;
    procedure EnterMethod(const S: string); overload;
    procedure EnterMethod(c: TObject; const S: string); overload;
    procedure ExitMethod(const S: string); overload;
    procedure ExitMethod(c: TObject; const S: string); overload;
    procedure SendNote(const S: string);
    procedure SendWarning(const S: string);
    procedure SendError(const S: string);
    procedure SendException(E: Exception);
    procedure Send(const a1: string); overload;
    procedure Send(const i: Integer; const a1, a2: string); overload;
    procedure Send(const a1, a2: string); overload;
    procedure Send(const a1: string; const i2: Integer); overload;
    procedure Send(const a1: string; const b2: Boolean); overload;
    procedure Send( const Fmt: string; const Args: array of const ); overload;
    procedure Write(const a1, a2: string);
    property Category: string read FCategory write FCategory;
    property CategoryFontColor: Integer read FCategoryFontColor
      write FCategoryFontColor;
    procedure UseCodeSiteManagerConnection;
  end;

type
  TCodeSiteManagerFake = class
  private
    FDefaultDestination: TDestinationRec;
  public
    constructor Create;
    destructor Destroy; override;
    procedure ConnectUsingTcp; overload;
    procedure ConnectUsingTcp(const a: string; const i: Integer); overload;
    property DefaultDestination: TDestinationRec read FDefaultDestination;
  end;

var
  CodeSite: TCodeSiteFake = nil;
  CodeSiteManager: TCodeSiteManagerFake = nil;

implementation

{$IFNDEF XFER2CodeSite}uses ucLogFil;{$ENDIF}

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

function ABC(const a: Integer; const b, c: string): AnsiString;
begin
  Result := AnsiString(UTF8Encode(IntToStr(a) + '^^' + b + '^^' + c));
end;

procedure TCodeSiteFake.EnterMethod(c: TObject; const S: string);
begin
  if Assigned(c) and (c is TComponent) then
  begin
    {$IFDEF XFER2CodeSite}
    FSharedBuf.GlobalAnsiString := ABC(6, TComponent(c).ClassName + '.' +
      TComponent(c).Name, S);
    {$ELSE}
    HREFTestLog('>>', TComponent(c).ClassName + ' ' + TComponent(c).Name, S)
    {$ENDIF}
  end
  else
  begin
    {$IFDEF XFER2CodeSite}
    FSharedBuf.GlobalAnsiString := ABC(6, S, '');
    {$ELSE}
    HREFTestLog('>>', '', S);
    {$ENDIF}
  end;
end;

procedure TCodeSiteFake.EnterMethod(const S: string);
begin
  {$IFDEF XFER2CodeSite}
  FSharedBuf.GlobalAnsiString := ABC(6, S, '');
  {$ELSE}
  HREFTestLog('>>', '', S);
  {$ENDIF}
end;

procedure TCodeSiteFake.ExitMethod(c: TObject; const S: string);
begin
  if Assigned(c) and (c is TComponent) then
  begin
    {$IFDEF XFER2CodeSite}
    FSharedBuf.GlobalAnsiString := ABC(7, TComponent(c).ClassName + '.' +
      TComponent(c).Name, S);
    {$ELSE}
    HREFTestLog('<<', TComponent(c).ClassName + ' ' + TComponent(c).Name, S)
    {$ENDIF}
  end
  else
  begin
    {$IFDEF XFER2CodeSite}
    FSharedBuf.GlobalAnsiString := ABC(7, S, '');
    {$ELSE}
    HREFTestLog('<<', '', S);
    {$ENDIF}
  end;
end;

constructor TCodeSiteFake.Create;
begin
  {$IFDEF XFER2CodeSite}
  FSharedBuf := TtpSharedBuf.CreateNamed(nil, 'CodeSiteFPC', 2048);
  FSharedBuf.Name := 'FSharedBuf';
  {$ENDIF}
end;

function TCodeSiteFake.Installed: Boolean;
begin
  Result := False;
end;

function TDestinationRec.AsString: string;
begin
  Result := ToString;
end;

function TDestinationRec.ToString: string;
begin
  Result := 'n/a';
end;

procedure TCodeSiteFake.ExitMethod(const S: string);
begin
  {$IFDEF XFER2CodeSite}
  FSharedBuf.GlobalAnsiString := ABC(7, S, '');
  {$ELSE}
  HREFTestLog('<<', '', S);
  {$ENDIF}
end;

procedure TCodeSiteFake.Send(const a1: string);
begin
  {$IFDEF XFER2CodeSite}
  FSharedBuf.GlobalAnsiString := ABC(7, a1, '');
  {$ELSE}
  HREFTestLog(1, a1, '');
  {$ENDIF}
end;

procedure TCodeSiteFake.Send(const a1: string; const i2: Integer);
begin
  {$IFDEF XFER2CodeSite}
  FSharedBuf.GlobalAnsiString := ABC(7, a1, IntToStr(i2));
  {$ELSE}
  HREFTestLog('info', a1, IntToStr(i2));
  {$ENDIF}
end;

procedure TCodeSiteFake.Send(const i: Integer; const a1, a2: string);
begin
  Send(a1, a2);
end;

procedure TCodeSiteFake.Send(const a1, a2: string);
begin
  {$IFDEF XFER2CodeSite}
  FSharedBuf.GlobalAnsiString := ABC(7, a1, a2);
  {$ELSE}
  HREFTestLog('info', a1, a2);
  {$ENDIF}
end;

procedure TCodeSiteFake.SendError(const S: string);
begin
  {$IFDEF XFER2CodeSite}
  FSharedBuf.GlobalAnsiString := ABC(3, S, '');
  {$ELSE}
  HREFTestLog('error', S, '');
  {$ENDIF}
end;

procedure TCodeSiteFake.SendException(E: Exception);
begin
  {$IFDEF XFER2CodeSite}
  FSharedBuf.GlobalAnsiString := ABC(5, E.Message, '');
  {$ELSE}
  HREFTestLog('exception', E.Message, '');
  {$ENDIF}
end;

procedure TCodeSiteFake.SendNote(const S: string);
begin
  {$IFDEF XFER2CodeSite}
  FSharedBuf.GlobalAnsiString := ABC(4, S, '');
  {$ELSE}
  HREFTestLog('note', S, '');
  {$ENDIF}
end;

procedure TCodeSiteFake.SendWarning(const S: string);
begin
  {$IFDEF XFER2CodeSite}
  FSharedBuf.GlobalAnsiString := ABC(2, S, '');
  {$ELSE}
  HREFTestLog('warning', S, '');
  {$ENDIF}
end;

procedure TCodeSiteFake.UseCodeSiteManagerConnection;
begin
  FUseCodeSiteManagerConnection := True;
end;

procedure TCodeSiteFake.Write(const a1, a2: string);
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

procedure TCodeSiteFake.Send(const a1: string; const b2: Boolean);
begin
  Send(a1, BoolToStr(b2, True));
end;

procedure TCodeSiteFake.Send(const Fmt: string; const Args: array of const);
begin
  try
    Send(Format( Fmt, Args ), '' );
  except
    on E: EConvertError do
      SendError( 'Send Error: Invalid Format Arguments' );
  end;
end;

initialization

CodeSite := TCodeSiteFake.Create;
CodeSiteManager := TCodeSiteManagerFake.Create;

finalization

FreeAndNil(CodeSite);
FreeAndNil(CodeSiteManager);

end.
