unit whObjectInspector_dmWhAction;
(*
Copyright (c) 2004 HREF Tools Corp.

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
  SysUtils, Classes, WebObjInsp;

type
  TMyClass = class(TComponent)
  private
    fCustomerName: String;
    fCustomerCity: String;
    fCustomerActive: Boolean;
  published
    property CustomerName: String read fCustomerName write fCustomerName;
    property CustomerCity: String read fCustomerCity write fCustomerCity;
    property CustomerActive: Boolean read fCustomerActive write fCustomerActive;
  end;

type
  TdmWhAction = class(TDataModule)
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
    fMyClass: TMyClass;
    fWebObjectInspector: TwhObjectInspector;
  public
    { Public declarations }
    property MyClass: TMyClass read fMyClass write fMyClass;
    property WebObjectInspector: TwhObjectInspector read fWebObjectInspector write fWebObjectInspector;
    procedure Init;
  end;

var
  dmWhAction: TdmWhAction;

implementation

{$R *.dfm}

uses WebLink;

procedure TdmWhAction.DataModuleCreate(Sender: TObject);
begin
  fMyClass := TMyClass.Create(dmWhAction);  // one instance only, not per-surfer, in this demo.
  fMyClass.Name := 'MyClass';
  fMyClass.CustomerName := 'Mickey Mouse';
  fMyClass.CustomerCity := 'Orlando';
  fMyClass.CustomerActive := True;

  fWebObjectInspector := TwhObjectInspector.Create(dmWhAction);
  fWebObjectInspector.Name := 'WebObjectInspector';
  fWebobjectInspector.Caption := 'TMyClass Properties';
  fWebobjectInspector.ReadOnly := False;
  fWebObjectInspector.CurrentControl := MyClass;
end;

procedure TdmWhAction.DataModuleDestroy(Sender: TObject);
begin
  FreeAndNil(fMyClass);
  FreeAndNil(fWebObjectInspector);
end;

procedure TdmWhAction.Init;
begin
  RefreshWebActions(dmWhAction);
end;

end.
