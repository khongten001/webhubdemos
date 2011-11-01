unit DSP_fmConfigure;
////////////////////////////////////////////////////////////////////////////////
//  Copyright (c) 1995-2002 HREF Tools Corp.  All Rights Reserved Worldwide.  //
//  This source is a part of the WebHub VCL.  Please refer friends and        //
//  colleagues to the download links at www.webhub.com.              Thanks!  //
////////////////////////////////////////////////////////////////////////////////

interface

uses
   Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
   UTPANFRM, ExtCtrls, StdCtrls, UpdateOk, tpAction, IniLink,
   Toolbar, Restorer, Buttons, tpCompPanel;

type
   TfmAppConfigure = class(TutParentForm)
      ToolBar: TtpToolBar;
      Panel: TPanel;
      laDBAlias: TLabel;
      Label1: TLabel;
      edDBAlias: TEdit;
      edWords: TEdit;
      btSet: TButton;
      procedure btSetClick(Sender: TObject);
   private
      { Private declarations }
   public
      { Public declarations }
      function Init: Boolean; override;
      procedure Save(Restorer:TFormRestorer); override;
      procedure Load(Restorer:TFormRestorer); override;
   end;

var fmAppConfigure: TfmAppConfigure;

implementation

{$R *.DFM}

uses
   WebApp, WebInfou;

//------------------------------------------------------------------------------
function TfmAppConfigure.Init:Boolean;
begin
   Result:= inherited Init;
   If not result then Exit;
//note.. keep ComponentStatusBar OFF for webaction components on this form.
//usually place 'extra' webaction components into datamodules or
//directly on the main form of the application.
//use the panels like subroutines and ADD PUBLIC VARIABLES TO THEIR
//Forms and set the pointers from the app's DPRs should that be required.
//again.. use a indirect pointer to get to global components from here.
//freely add components and code to the main-form or through datamodules.
//  WebListGrid.WebApp:=WebApp;
//  WebMailForm.WebApp:=WebApp;
end;

//------------------------------------------------------------------------------
procedure TfmAppConfigure.Save(Restorer:TFormRestorer);
//example OnSave Handler
begin
   Inherited Save(Restorer);
   With Restorer do
      begin
         LongintEntry['Panel']:= Panel.Width;
         //    BooleanEntry['xyz']:=   button.Down;
      end;
end;

procedure TfmAppConfigure.Load(Restorer:TFormRestorer);
//example OnLoad Handler
begin
   Inherited Load(Restorer);
   With Restorer do
      begin
         LongintEntry['Panel']:= Panel.Width;
         //    Button.Down:= BooleanEntry['xyz'];
      end;
end;

//------------------------------------------------------------------------------
procedure TfmAppConfigure.btSetClick(Sender: TObject);
begin
   Inherited;
   pwebApp.AppSetting['WordsTable']:=edWords.Text;
   pwebApp.AppSetting['DatabaseAlias']:=edDBAlias.Text;
   ////pWebApp.Defaults.SaveList;
   ////pwebApp.AppSettings.SaveList;
   pWebApp.Refresh;
end;

end.
