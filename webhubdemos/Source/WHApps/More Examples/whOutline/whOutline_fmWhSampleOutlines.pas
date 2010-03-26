unit whOutline_fmWhSampleOutlines;
(*
Copyright (c) 2003 HREF Tools Corp.
Authors: Ann Lynnworth and Ronan van Riet

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
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UTPANFRM, ExtCtrls, StdCtrls, UpdateOk, tpAction, IniLink,
    Toolbar, Restorer, WebTypes, weblink, Weboutln, Buttons,
  ComCtrls, tpstatus;

type
  TfmWhSampleOutlines = class(TutParentForm)
    ToolBar: TtpToolBar;
    Panel: TPanel;
    WebOutline: TwhOutline;
    WebOutlineMaslow: TwhOutline;
    tpStatusBar1: TtpStatusBar;
    PageControl1: TPageControl;
    tsOutline1: TTabSheet;
    tsOutline2: TTabSheet;
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    procedure InitializeSimpleOutline;
    procedure InitializeMaslowOutline;
    function ElderSiblingIndex(const thisLevel:Integer): TTreeNode;
  public
    { Public declarations }
    function Init: Boolean; override;
    end;

var
  fmWhSampleOutlines: TfmWhSampleOutlines;

implementation

{$R *.DFM}

uses
  WebApp, ucString;

//------------------------------------------------------------------------------

var
  idx: integer = -1;

function ExtendFakeData(Const S: String ): String;
begin
  {This function builds up some reasonable, but fake, data for use in the
   first example.

   The treeview.items.text property must be in this form:
   pageDescription|WebHub PageID[|more HTML]
  }
  inc(idx); {idx is for educational purposes, it does not do anything.}
  Result := S + '(item#' + IntToStr(idx) + ')' + '|pgOkay';
end;

procedure TfmWhSampleOutlines.InitializeSimpleOutline;
var
  MyTreeNode1,MyTreeNode2: TTreeNode;
begin
  {Create the TTreeView dynamically (this is a recommended technique when the
   component might not be on the developer's palette. Delphi 7 does not put
   TTreeView on the palette by default.}
  WebOutline.Outline := TTreeView.Create(WebOutline);
  with WebOutline.Outline do
  begin
    ParentWindow := fmWhSampleOutlines.tsOutline1.Handle;
    Height := 250;  {align client did not seem to work, so a size is set.}
    Width := 500;
  end;

  with WebOutline.Outline.Items do
  begin
    {The following example code for adding nodes came from the Delphi 7 Help
     for TTreeView. Apologies for lack of imagination.}

    Clear; { remove any existing nodes }
    MyTreeNode1 := Add(nil, ExtendFakeData('RootTreeNode0')); { Add a root node }
    { Add a child node to the node just added }
    AddChild(MyTreeNode1,ExtendFakeData('ChildNode0'));

    {Add another root node}
    MyTreeNode2 := Add(MyTreeNode1, ExtendFakeData('RootTreeNode1'));
    {add a child }
    AddChild(MyTreeNode2,ExtendFakeData('ChildNode1'));

    {Reuse MyTreeNode2}
    { and add a child node to it}
    MyTreeNode2 := WebOutline.Outline.Items[3];
    AddChild(MyTreeNode2,ExtendFakeData('ChildNode1a'));

    {Add a sibling}
    Add(MyTreeNode2,ExtendFakeData('ChildNode1b'));

    {add another root node}
    Add(MyTreeNode1, ExtendFakeData('RootTreeNode2'));
  end;
end;

// -----------------------------------------------------------------------------

function TfmWhSampleOutlines.ElderSiblingIndex(const thisLevel:Integer): TTreeNode;
var
  i,n: Integer;
begin
  {Starting from the end of the outline, go backwards until you find a node
   which is an appropriate place to link the desired-level of sibling.}
  with WebOutlineMaslow.Outline do
  begin
    n := Items.Count - 1;
    for i := n downto 0 do
    begin
      Result := Items[i];
      if Result.Level = thisLevel then exit;
    end;
    Result := nil;  {should not occur, unless the data is wrong.}
  end;
end;

procedure TfmWhSampleOutlines.InitializeMaslowOutline;
var
  MyTree,MyTreeNode2: TTreeNode;
  list: TStringList;
  i, currentLevel, thisLevel: Integer;
  aLevel,aPhrase,aPageID: String;
  S: String;
  ini: TIniFileLink;
begin
  {This example is more ambitious. It loads content from a section of the
   application-level INI file, and assigns that into the TTreeView.  Again we
   are creating the actual TTreeView dynamically at run-time.}
  WebOutlineMaslow.Outline := TTreeView.Create(WebOutlineMaslow);
  ini := TIniFileLink.Create(Self);

  with WebOutlineMaslow.Outline do
  begin
    ParentWindow := fmWhSampleOutlines.tsOutline2.Handle;
    Top := 0;
    Left := 0;
    Height := 250;
    Width := 500;

    Items.Clear;
    MyTree := nil;
    MyTreeNode2 := nil;

    list := TStringList.Create;
    with ini do
    begin
      IniFilename := ExtractFilePath(pWebApp.ConfigFilespec)
      + 'whOutlineContent.ini';
      ReadSection('WebOutlineContent',list);
    end;
    currentLevel := -99;

    for i := 0 to pred(List.Count) do
    begin
      {This is what an example line in the list should look like:
       01=1:Self-Actualization(pgSelfActualize)

       The meaning of these elements are:
       listindex=level:page description(pageid)
      }
      SplitString(RightOfEqual(list[i]),':',aLevel,aPhrase);
      SplitString(aPhrase,'(',aPhrase,aPageID);
      aPageID := Copy(aPageID,1,Length(aPageID)-1); // drop trailing ) character
      if aPageID = '' then aPageID := 'pgOkay';     // avoid having to create much site content

      thisLevel := StrToIntDef(aLevel,0);

      S := aPhrase + '|' + aPageID;

      if currentLevel = -99 then
      begin
        MyTree := Items.Add(nil, S);
        MyTreeNode2 := MyTree;
      end
      else if thisLevel = 0 then
      begin
        MyTreeNode2 := Items.Add(MyTree, S);
      end
      else if thisLevel > currentLevel then
      begin
        MyTreeNode2 := Items.AddChild(MyTreeNode2,S);
      end
      else if thisLevel = currentLevel then
      begin
        MyTreeNode2 := Items.Add(MyTreeNode2,S);
      end
      else if thisLevel < currentLevel then
      begin
        MyTreeNode2 := ElderSiblingIndex(thisLevel);
        MyTreeNode2 := Items.Add(MyTreeNode2,S);
      end;
      currentLevel := thisLevel;
    end;
  end;
  FreeAndNil(list);
  FreeAndNil(ini);
  {Now the outline has been loaded with data, and may be used from W-HTML, etc.}
end;

(* written permission for the text in the sample

Date: Thu, 22 May 2003 07:01:28 -0400
From: (snip)
Subject: Re: request for permission to quote
To: Ann Lynnworth <ann@href.com>

You have my permission to use the material in the way you described.

Dr. Robert Gwynne
University of Tennessee, Knoxville
*)


function TfmWhSampleOutlines.Init:Boolean;
begin
  Result:= inherited Init;
  if not Result then
    exit;
  InitializeSimpleOutline;     {visible on the first tabsheet}
  InitializeMaslowOutline;     {visible on the second tabsheet}
end;

//------------------------------------------------------------------------------

procedure TfmWhSampleOutlines.FormDestroy(Sender: TObject);
begin
  inherited;
  {Since we created these dynamically, we must free them as well.}
  WebOutline.Outline.Free;
  WebOutline.Outline := nil;
  WebOutlineMaslow.Outline.Free;
  WebOutlineMaslow.Outline := nil;
end;

end.
