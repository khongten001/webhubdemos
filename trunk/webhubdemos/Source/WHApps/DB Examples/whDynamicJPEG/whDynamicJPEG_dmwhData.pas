unit whDynamicJPEG_dmwhData;

(*
Copyright (c) 2003-2014 HREF Tools Corp.

Permission is hereby granted, on 29-Jan-2013, free of charge, to any person
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
  SysUtils, Classes, DB, DBClient,
  updateOK, tpAction,
  webLink, webTypes;

type
  TDMBIOLIFE = class(TDataModule)
    ClientDataSet1: TClientDataSet;
    DataSourceBiolife: TDataSource;
    waAnimalNav: TwhWebAction;
    procedure DataModuleCreate(Sender: TObject);
    procedure waAnimalNavExecute(Sender: TObject);
  private
    { Private declarations }
    FlagInitDone: Boolean;
    procedure WebAppUpdate(Sender: TObject);
  public
    { Public declarations }
    function Init(out ErrorText: string): Boolean;
  end;

var
  DMBIOLIFE: TDMBIOLIFE;

implementation

{$R *.dfm}

uses
  {$IFDEF CodeSite}CodeSiteLogging,{$ENDIF}
  webApp, htWebApp, ucCodeSiteInterface, whdemo_ViewSource;

{ TDM001 }

procedure TDMBIOLIFE.DataModuleCreate(Sender: TObject);
begin
  FlagInitDone := False;
  ClientDataSet1.Filename := getHtDemoDataRoot + 'embSample\' + 'biolife.xml';
  ClientDataSet1.ReadOnly := True;
end;

function TDMBIOLIFE.Init(out ErrorText: string): Boolean;
const cFn = 'Init';
begin
  {$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn);{$ENDIF}
  ErrorText := '';
  // reserved for code that should run once, after AppID set
  if NOT FlagInitDone then
  begin

    if Assigned(pWebApp) and pWebApp.IsUpdated then
    begin
      try
        ClientDataSet1.Active := True;
      except
        on E: Exception do
        begin
          ErrorText := E.Message;
          {$IFDEF CodeSite}
          CodeSite.SendException(E);
          {$ENDIF}
        end;
      end;

      if ErrorText = '' then
      begin
        // Call RefreshWebActions here only if it is not called within a TtpProject event
        RefreshWebActions(Self);

        // helpful to know that WebAppUpdate will be called whenever the
        // WebHub app is refreshed.
        AddAppUpdateHandler(WebAppUpdate);
        FlagInitDone := True;
      end;
    end;
  end;
  Result := FlagInitDone;
  {$IFDEF CodeSite}CodeSite.Send('Result', Result);
  CodeSite.ExitMethod(Self, cFn);{$ENDIF}
end;

procedure TDMBIOLIFE.waAnimalNavExecute(Sender: TObject);
const cFn = 'waAnimalNavExecute';
begin
  {$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn);{$ENDIF}
  // Move pointer within the table to the next record so that the
  // the display shows a different image.
  with TwhWebAction(Sender) do
  begin
    CSSend(TwhWebAction(Sender).Name + '.Command', Command);
    if (Command = 'Prev') then
    begin
      ClientDataSet1.Prior;
      if ClientDataSet1.BOF then
        ClientDataSet1.Last
    end
    else
    begin
      ClientDataSet1.Next;
      if ClientDataSet1.EOF then
        ClientDataSet1.First;
    end;
  end;
  {$IFDEF CodeSite}CodeSite.ExitMethod(Self, cFn);{$ENDIF}
end;

procedure TDMBIOLIFE.WebAppUpdate(Sender: TObject);
const cFn = 'WebAppUpdate';
begin
  {$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn);{$ENDIF}
  // reserved for when the WebHub application object refreshes
  // e.g. to make adjustments because the config changed.
  {$IFDEF CodeSite}CodeSite.ExitMethod(Self, cFn);{$ENDIF}
end;

end.
