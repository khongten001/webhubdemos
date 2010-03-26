unit htshopc;
(*
Copyright (c) 1998 HREF Tools Corp.

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

// The WebDataGrid1.DataScanOptions were changed from the default settings.

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons, DBTables, DB, Grids, DBGrids, ComCtrls, 
  DBCtrls, 
  tpStatus, UTPANFRM, UpdateOk, tpAction, tpMemo, toolbar, {}tpCompPanel, 
  webMail, webSock, wbdeSource, webTypes, webLink, webScan, wdbLink, wdbScan, 
  wbdeGrid, webMemo, wdbSSrc;

type
  TfmShopPanel = class(TutParentForm)
    ToolBar: TtpToolBar;
    WebDataGrid1: TwhbdeGrid;
    WebActionOrderList: TwhWebActionEx;
    WebActionPostLit: TwhWebActionEx;
    WebDataSource1: TwhbdeSource;
    DataSource1: TDataSource;
    Table1: TTable;
    Table1PartNo: TFloatField;
    Table1VendorNo: TFloatField;
    Table1Description: TStringField;
    Table1OnHand: TFloatField;
    Table1OnOrder: TFloatField;
    Table1Cost: TCurrencyField;
    Table1ListPrice: TCurrencyField;
    Table1Qty: TSmallintField;
    WebActionMailer: TwhWebActionEx;
    tpStatusBar1: TtpStatusBar;
    tpToolButton1: TtpToolButton;
    Label7: TLabel;
    tpComponentPanel2: TtpComponentPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    DBGrid1: TDBGrid;
    DBNavigator1: TDBNavigator;
    tsEConfig: TTabSheet;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    EditEMailFrom: TEdit;
    EditEMailTo: TEdit;
    EditMailhost: TEdit;
    EditSubject: TEdit;
    EditMailPort: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    waScrollGrid: TwhWebActionEx;
    procedure Table1QtyGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure WebActionPostLitExecute(Sender: TObject);
    procedure WebActionOrderListExecute(Sender: TObject);
    procedure WebActionMailerExecute(Sender: TObject);
    procedure tpToolButton1Click(Sender: TObject);
    procedure waScrollGridExecute(Sender: TObject);
  private
    { Private declarations }
    procedure getOrderList( sList: TStringList );
    procedure ConfigEMail;
  public
    { Public declarations }
    function Init: Boolean; override;
  end;

var
  fmShopPanel: TfmShopPanel;

implementation

{$R *.DFM}

uses
  WebApp, ucString, whMail, whdemo_ViewSource;

//------------------------------------------------------------------------------

function TfmShopPanel.Init:Boolean;
begin
  Result:= inherited Init;
  if not result then
    exit;
  //
  with Table1 do
  begin
    DatabaseName := getHtDemoDataRoot + 'whShopping\';
    TableName := 'PARTS.DB';
  end;

  RefreshWebActions(fmShopPanel);

  DataModuleWhMail.WebMail.subject:='';   // init so that we know to config later.
  //
  {Other required settings:
  TwhbdeGrid
    datascanoptions        all set to true, except refresh and checkboxes
    buttonsWhere           above
    controlsWhere          none

  TwhbdeSource
    maxOpenDataSets        1 (no cloning)
    displaySets            defined in .ini file

  TTable
    add fields using Delphi field editor
    add calculated field called Qty, type integer
  }
end;

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

procedure TfmShopPanel.ConfigEMail;
begin
  {configure email based on values on form. These are saved to the
   href.ini file by the Restorer component.}
  // e-mail settings -- please change to use your own defaults!
  if EditEMailFrom.text='' then EditEMailFrom.text:='someone@theweb.com';
  if EditEMailTo.text=''   then EditEMailTo.text:='info@href.com';
  if EditMailHost.text=''  then EditMailHost.text:='mail.href.com';
  if EditMailPort.text=''  then EditMailPort.text:='25';
  if EditSubject.text=''   then EditSubject.text:='** Shop1 Sale';
  //
  with DataModuleWhMail.WebMail do
  begin
    Sender.EMail:=EditEmailFrom.text;
    MailTo.clear;
    MailTo.add(editEMailTo.text);
    MailHost.hostname:=EditMailhost.text;
    MailHost.port:=StrToIntDef(EditMailport.text,25);
    Subject:=EditSubject.text;
  end;
end;

{ ------------------------------------------------------------------------- }

{ To see what webhub is doing with your data, add %=chDebugInfo=% to the
  bottom of the homepage and/or confirm pages.  That will display some
  key arrays: Request.dbFields, Request.FormLiterals and Session.StringVars.

  The data entered by the surfer into the webdatagrid is posted to the
  dbFields array.  We need to jump in and copy that to the StringVars array,
  because dbFields is cleared at the end of the page.  Since we don't have
  a real table to post to, we are using the StringVars array as temporary
  storage.  (Yes, you could add a temporary order table and post Qty there.)
}
procedure TfmShopPanel.WebActionPostLitExecute(Sender: TObject);
var
  a1,a2:string;
  i:integer;
begin
  //WebDataSource1.Qty@1316=35
  with TwhWebActionEx(Sender).WebApp do begin
    for i:=0 to pred(Request.dbFields.count) do begin
      SplitString(Request.dbFields[i],'=',a1,a2);
      if a2<>'' then
        StringVar[a1]:=a2;   {post single entry to StringVars array}
      end;
    end;
end;

{ ------------------------------------------------------------------------- }

{ Illusion central:
  Make the table act multi-surfer by defining the calculated field as equal to
  the current surfer's StringVars.}
procedure TfmShopPanel.Table1QtyGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  Text:=pWebApp.StringVar['webdatasource1.Qty@'+
    Sender.DataSet.FieldByName('PartNo').asString];
end;


{ ------------------------------------------------------------------------- }
{ ------------------------------------------------------------------------- }

{Fill a stringlist with the current order.
 Loop thru the StringVars[] array looking for items with @ which come from the
 data entry session.}
procedure TfmShopPanel.getOrderList( sList: TStringList );
var
  a1,a2:string;
  i:integer;
begin
  slist.clear;
  with pWebApp.Session do begin
    for i:=0 to pred(StringVars.count) do begin
      a1:=LeftOfEqual(StringVars[i]);
      if pos( '@', a1 ) > 0 then begin
        //WebDataSource1.Qty@1316=35
        SplitString(StringVars[i],'=',a1,a2);  // SplitString is in the ucString unit
        slist.add( 'Qty ' + a2 + ' of Product #' + RightOf( '@', a1 ));
        end;
      end;
    end;
end;


{ ------------------------------------------------------------------------- }

{this is one way to echo the current order.}
procedure TfmShopPanel.WebActionOrderListExecute(Sender: TObject);
var
  sList:TStringList;
begin
  sList:=nil;
  try
    sList:=TStringList.create;
    getOrderList(slist);
    //send out the order, with a <BR> at end of each line
    TwhWebActionEx(Sender).WebApp.Response.SendStringListBR(slist);
  finally
    slist.free;
    end;
end;

{ ------------------------------------------------------------------------- }

{ Prepare and send mail message.}
procedure TfmShopPanel.WebActionMailerExecute(Sender: TObject);
var
  sList:TStringList;
begin
  with TwhWebActionEx(Sender).WebApp, DataModuleWhMail.WebMail do
  begin
    if subject='' then
      configEMail;
    //
    Sender.Name:=StringVar['CustFullName'];
    // fill in the message (Lines property)
    Lines.clear;
    Lines.add( 'CUSTOMER:' );
    Lines.add( StringVar['CustFullName'] );
    Lines.add( StringVar['CustCity'] );
    Lines.add( '' );
    Lines.add( 'ORDER:' );
    sList:=nil;
    try
      sList:=TStringList.create;
      getOrderList(slist);
      Lines.AddStrings(slist);
    finally
      slist.free;
      end;
    execute;  {send the message}
    end;
end;

{ ------------------------------------------------------------------------- }

{ fun with tool buttons...}

procedure TfmShopPanel.tpToolButton1Click(Sender: TObject);
begin
  with DBGrid1 do
    if DataSource=nil then
    begin
      DataSource:=DataSource1;
      DbNavigator1.DataSource:=DataSource1;
      DataSource.DataSet.Open;
    end
    else
    begin
      DataSource:=nil;
      DbNavigator1.DataSource:=nil;
    end
end;

procedure TfmShopPanel.waScrollGridExecute(Sender: TObject);
var
  a1,a2:string;
begin
  inherited;
  with TwhWebActionEx(Sender).WebApp do begin
    SplitString(StringVar['BtnShop'],' ',a1,a2);  // e.g. Next Page
    if a1='Save' then a1:='This'; // save but do not scroll anywhere.
    WebDataGrid1.Command:=a1;     // Make the grid scroll by setting its command, e.g. Next
    end;
end;

end.
