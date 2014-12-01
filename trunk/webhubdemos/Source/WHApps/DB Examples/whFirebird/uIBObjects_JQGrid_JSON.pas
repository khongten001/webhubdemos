unit uIBObjects_JQGrid_JSON;

{ ---------------------------------------------------------------------------- }
{ * Copyright (c) 2014 HREF Tools Corp.  All Rights Reserved Worldwide.      * }
{ *                                                                          * }
{ * This source code file is part of the WebHubDemos.                        * }
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

{$I hrefdefines.inc}

uses
  IB_Components, JSON;

function IBObjStatement2JQGridJSON(const InTableName: string;
  statement: TIB_Statement; InPrimaryKeyFieldIdx: Integer = 0): TJSONObject;

implementation

uses
  SysUtils;

function IBObjPrimaryKey2JSON(const InTableName: string;
  statement: TIB_Statement; InPrimaryKeyFieldIdx: Integer = 0): TJSONPair;
const cFn = 'IBObjPrimaryKey2JSON';
var
  Identifier: string;
begin
  Identifier := Format('row-%s-%s',
    [InTableName, statement.Fields[InPrimaryKeyFieldIdx].FieldName]);

  Result := TJSONPair.Create(Identifier,
    TJSONString.Create(statement.Fields[InPrimaryKeyFieldIdx].AsString));
  //CSSend(cFn, Result.ToJSON);
end;

function IBObjFields2JSON(statement: TIB_Statement): TJSONPair;
const cFn = 'IBObjFields2JSON';
var
  JA: TJSONArray;
  i: Integer;
begin
  JA := TJSONArray.Create;
  for i := 0 to Pred(statement.FieldCount) do
  begin
    JA.AddElement(TJSONString.Create(statement.Fields[i].AsString));
  end;

  Result := TJSONPair.Create('cell', JA);
  //CSSend(cFn, Result.ToJSON);
end;

function IBObjStatement2JQGridJSON(const InTableName: string;
  statement: TIB_Statement; InPrimaryKeyFieldIdx: Integer = 0): TJSONObject;
const cFN = 'IBObjStatement2JQGridJSON';
begin
  Result := TJSONObject.Create;
  Result.AddPair(IBObjPrimaryKey2JSON(InTableName, statement,
    InPrimaryKeyFieldIdx));
  Result.AddPair(IBObjFields2JSON(statement));
  //CSSend(cFn, Result.ToJSON);
end;

end.
