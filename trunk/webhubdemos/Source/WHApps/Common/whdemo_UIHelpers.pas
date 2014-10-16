unit whdemo_UIHelpers;

{*******************************************************}
{                                                       }
{       WebHub                                          }
{       UI Helper Web Actions                           }
{                                                       }
{       Copyright (c) 2005-2014                         }
{       HREF Tools Corp.                                }
{                                                       }
{*******************************************************}

interface

uses
  SysUtils, Classes,
  tpAction, updateOK,
  webTypes, webLink;

type
  { type was TdmwhGlobal}
  TdmwhUIHelpers = class(TDataModule)
    waShowSessionVariables: TwhWebAction;

///<summary>output all WebHub Session Variables in an html table
///</summary>
/// <remarks>
///  <para>usage:</para>
///  <para>(~waSessionVariables~)</para>
///  <para>(~waSessionVariables|sorted~)</para>
///
///  <para>optional parameter:  "sorted" - alphabetically sort variable names
///  </para>
///</remarks>
    procedure waSessionVariablesExecute(Sender: TObject);

    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function Init(out ErrorText: string): Boolean;
  end;

var
  dmwhUIHelpers: TdmwhUIHelpers;

implementation

{$R *.dfm}

uses
  {$IFDEF CodeSite}CodeSiteLogging,{$ENDIF}
  ucstring,
  webApp, webSend;

procedure TdmwhUIHelpers.waSessionVariablesExecute(Sender: TObject);
var
  S: string;
  I: Integer;
  sList: TStringList;
  Sorted: Boolean;

  function ContainLineLength(S: string; LineLength: Integer): string;
  begin
    if Length(S) <=LineLength then
      Result := S
    else
    begin
      Result := '';
      while Length(S) > 0 do
      begin
        if Result <> '' then
          Result := Result + '<br />';
        Result := Result + Copy(S,1,LineLength);
        S := Copy(S,LineLength+1,MaxLongInt);
      end;
    end;
  end;

begin
  sList := nil;
  try
    sList := TStringList.Create;
    Sorted := IsEqual(TwhWebAction(Sender).HtmlParam,'sorted');

    S := '<table id="table-SessionVariables">';
    with TwhWebAction(Sender) do
    begin
      with WebApp.Session do
      begin
        S := S
          + '<tr><td colspan="2" class="title-SessionVarType">'
           + 'Session StringVars</td></tr>';
        if StringVars.Count > 0 then
        begin
          sList.Text := StringVars.Text;
          if Sorted then
            sList.Sort;
          for I := 0 to sList.Count - 1 do
          begin
            S := S + '<tr><td>' + sList.Names[I] + '</td><td>'
              + ContainLineLength(sList.Values[sList.Names[I]],80) + '</td></tr>';
          end;                   {StringVars.ValueFromIndex[I]}
        end;
        S := S + '<tr><td colspan="2" class="title-SessionVarType">'
         + 'Session Booleans</td></tr>';
        if BoolVars.Count > 0 then
        begin
          sList.Text := BoolVars.Text;
          if Sorted then
            sList.Sort;
          for I := 0 to sList.Count - 1 do
          begin
            S := S + '<tr><td>' + sList.Names[I] + '</td><td>'
              +  sList.Values[sList.Names[I]] + '</td></tr>';
          end;
        end;


      end;
      S := S + '</table>';
      Response.Send(S);
    end;
  finally
    FreeAndNil(sList);
  end;
end;

procedure TdmwhUIHelpers.DataModuleCreate(Sender: TObject);
begin
  // placeholder
end;

procedure TdmwhUIHelpers.DataModuleDestroy(Sender: TObject);
begin
  // placeholder
end;

function TdmwhUIHelpers.Init(out ErrorText: string): Boolean;
begin
  RefreshWebActions(dmwhUIHelpers);
  ErrorText := '';
  Result := True;
end;

end.
