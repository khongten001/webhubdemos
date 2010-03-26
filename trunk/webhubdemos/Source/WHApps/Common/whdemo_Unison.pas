unit whdemo_Unison;

interface

uses
  SysUtils, Classes,
  tpShareB;

type
  TdmwhUnison = class(TDataModule)
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
    fSharedExitTrigger: TSharedint;
  protected
    procedure tpSharedLongint1Change(Sender: TObject);
  public
    { Public declarations }
    procedure Init;
    procedure CancelSharedExitTrigger;
    procedure CloseAppQuietly;
  end;

var
  dmwhUnison: TdmwhUnison;

implementation

{$R *.dfm}

uses
  Forms;
  
procedure TdmwhUnison.Init;
begin
  fSharedExitTrigger := TSharedInt.CreateNamed(Self, 'RHSExit',
    SizeOf(Longint));
  with fSharedExitTrigger do
  begin
    if GlobalInteger <> 1 then
      GlobalInteger := 1;
    OnChange := tpSharedLongint1Change;
  end;

  Application.ProcessMessages;
end;

procedure TdmwhUnison.tpSharedLongint1Change(Sender: TObject);
begin
  with fSharedExitTrigger do
  begin
    if GlobalInteger = 0 then
      Application.MainForm.Close;
  end;
end;

procedure TdmwhUnison.DataModuleDestroy(Sender: TObject);
begin
  {fConnection will quit as it is being destroyed.}

  if Assigned(fSharedExitTrigger) then
    with fSharedExitTrigger do
      if GlobalInteger <> 0 then
        GlobalInteger := 0;
  inherited;
end;

procedure TdmwhUnison.CancelSharedExitTrigger;
begin
  FreeAndNil(fSharedExitTrigger);
end;

procedure TdmwhUnison.CloseAppQuietly;
begin
  FreeAndNil(fSharedExitTrigger);
  if Assigned(Application) and Assigned(Application.MainForm) then
    Application.MainForm.Close;
end;

end.
