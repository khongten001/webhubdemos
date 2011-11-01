unit dmBasic;  {basic WebHub data module}
////////////////////////////////////////////////////////////////////////////////
//  Copyright (c) 1995-2003 HREF Tools Corp.  All Rights Reserved Worldwide.  //
//                                                                            //
//  This source code file is part of WebHub v2.018.  Please obtain a WebHub   //
//  development license from HREF Tools Corp. before using this file, and     //
//  refer friends and colleagues to href.com/webhub for downloading. Thanks!  //
////////////////////////////////////////////////////////////////////////////////

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UpdateOk, tpAction, IniLink, webStLst;

type
  TdmBasicDatamodule = class(TDataModule)
  private
    fList: TwhStoreList;
    procedure SetList(Value:TwhStoreList);
  public
    constructor Create(aOwner:TComponent); override;
    destructor Destroy; override;
    function Init:Boolean; virtual;
    property List:TwhStoreList read fList write SetList;
    end;

var
  dmBasicDatamodule: TdmBasicDatamodule;

implementation

{$R *.DFM}

function TdmBasicDatamodule.Init:Boolean;
begin
  Result:=True;
end;

procedure TdmBasicDatamodule.SetList(Value:TwhStoreList);
begin
  fList.Assign(Value);
end;

constructor TdmBasicDatamodule.Create(aOwner:TComponent);
begin
  fList:=TwhStoreList.Create;
  inherited Create(aOwner);
end;

destructor TdmBasicDatamodule.Destroy;
begin
  FreeAndNil(fList);
  inherited Destroy;
end;

end.
