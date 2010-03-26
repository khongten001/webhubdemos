unit DSP_fmPanel;

// This started as the standard AppPanel.pas and was modified
// for the DSP. It has an extra page control, and more.


////////////////////////////////////////////////////////////////////////
//  Copyright (c) 1995-97 HREF Tools Corp.  All Rights Reserved.      //
//  This source is a part of the WebHub(tm) Component Package.        //
//  You may not redistribute this file unless you redistribute the    //
//  entire WebHub(tm) Trial Package. The full license is on the web.  //
//  http://www.href.com/webhub/  http://www.href.com/techsupport.html //
////////////////////////////////////////////////////////////////////////

//This is an example unit that was inherited from
//TutParentForm through File|New|<Project>|TutParentForm
//For inheritance to work, your uses clause must include
//the units to be inherited from.

interface

uses
   Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
   ExtCtrls, StdCtrls, ComCtrls,
   UTPANFRM, UpdateOk, Toolbar, Restorer, tpCompPanel;

type
   TfmPanel = class(TutParentForm)
      PageControl1: TPageControl;
      TabSheet1: TTabSheet;
      Panel: TPanel;
      ToolBar: TtpToolBar;
   private
      { Private declarations }
   public
      { Public declarations }
      function Init: Boolean; override;
   end;

var
   fmPanel: TfmPanel;

implementation

{$R *.DFM}

function TfmPanel.Init:Boolean;
begin
  Result := Inherited Init;
  If not Result then Exit;
end;

end.
