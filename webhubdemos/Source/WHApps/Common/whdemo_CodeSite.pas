unit whdemo_CodeSite;

(*
Copyright (c) 2014 HREF Tools Corp.

Permission is hereby granted, on 7-Jul-2014, free of charge, to any person
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

{$I hrefdefines.inc}

uses
  SysUtils, Classes,
  webLink, updateOK, tpAction, webTypes;

type
  TdmwhCodeSiteHelper = class(TDataModule)
    waCodeSite: TwhWebAction;
    procedure DataModuleCreate(Sender: TObject);

/// <summary> WebHub action component to log to CodeSite from WHTEKO
/// </summary>
/// <param name="Sender"> WebHub will pass in the webaction component.
/// </param>
/// <remarks>
/// Usage examples:
/// <para>(~waCodeSiteSend.Execute|Error|(~ErrorMessage~)~)</para>
/// <para>(~waCodeSiteSend.Execute|BoolVar|abc_t,afterAdd~)</para>
/// <para>(~waCodeSiteSend.Execute|Info|url,(~Request.QueryString~)~)</para>
/// <para>(~waCodeSiteSend.Execute|Info|data,(~EXPAND|ksrLocationNo=(~LocationNo~),ksrDate=(~ksrDate~)~)~)</para>
/// </remarks>
    procedure waCodeSiteExecute(Sender: TObject);
  private
    { Private declarations }
    FlagInitDone: Boolean;
  public
    { Public declarations }
    function Init(out ErrorText: string): Boolean;
  end;

var
  dmwhCodeSiteHelper: TdmwhCodeSiteHelper;

implementation

{$R *.dfm}

uses
  {$IFDEF CodeSite}CodeSiteLogging,{$ENDIF}
  ucCodeSiteInterface, ucString,
  webApp, htWebApp;

procedure TdmwhCodeSiteHelper.DataModuleCreate(Sender: TObject);
begin
  FlagInitDone := False;
end;

function TdmwhCodeSiteHelper.Init(out ErrorText: string): Boolean;
const cFn = 'Init';
begin
  CSEnterMethod(Self, cFn);
  ErrorText := '';
  // reserved for code that should run once, after AppID set
  if NOT FlagInitDone then
  begin

    waCodeSite.SilentExecution := True; // requires webhub v3.217+
    
    if Assigned(pWebApp) and pWebApp.IsUpdated then
    begin
      RefreshWebActions(Self);
      FlagInitDone := True;
    end;
  end;

  Result := FlagInitDone;
  CSSend('Result', S(Result));
  CSExitMethod(Self, cFn);
end;

procedure TdmwhCodeSiteHelper.waCodeSiteExecute(Sender: TObject);
{$IFDEF CodeSite}
var
  ASendType, Params, Param1, Param2: string;
  wa: TwhAppBase;
{$ENDIF}
begin
  {$IFDEF CodeSite}
  wa :=(TwhWebAction(Sender).WebApp);
  SplitString(TwhWebAction(Sender).HtmlParam, '|', ASendType, Params);
  if SameText(ASendType, 'Info') then
  begin
    SplitString(Params, ',', Param1, Param2);
    Param1 := wa.MoreIfParentild(Param1);
    Param2 := wa.MoreIfParentild(Param2);
    CodeSite.Send(Param1, Param2);
  end
  else
  if SameText(ASendType, 'BoolVar') then
  begin
    SplitString(Params, ',', Param1, Param2);
    Param1 := wa.MoreIfParentild(Param1);
    Param2 := wa.MoreIfParentild(Param2);
    CodeSite.Send(Param1, Format('%s="%s"', [Param2,
      S(pWebApp.BoolVar[Param2])]));
  end
  else
  if SameText(ASendType, 'StringVar') then
  begin
    SplitString(Params, ',', Param1, Param2);
    Param1 := wa.MoreIfParentild(Param1);
    Param2 := wa.MoreIfParentild(Param2);
    CodeSite.Send(Param1, Format('%s="%s"', [Param2, pWebApp.StringVar[Param2]]));
  end
  else
  begin
    Params := wa.MoreIfParentild(Params);
    if SameText(ASendType, 'Error') then
      CodeSite.SendError(Params)
    else
    if SameText(ASendType, 'Warning') then
      CodeSite.SendWarning(Params)
    else
    //if (ASendType = 'Note') then
      CodeSite.SendNote(Params);
  end;
  {$ENDIF}
end;

end.
