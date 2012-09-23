unit whdemo_IbObjCodeGenGUI;

{ ---------------------------------------------------------------------------- }
{ * Copyright (c) 2012 HREF Tools Corp.  All Rights Reserved Worldwide.      * }
{ *                                                                          * }
{ * This source code file is part of WebHub v2.1x.  Please obtain a WebHub   * }
{ * development license from HREF Tools Corp. before using this file, and    * }
{ * refer friends and colleagues to http://www.href.com/webhub. Thanks!      * }
{ ---------------------------------------------------------------------------- }

{ ---------------------------------------------------------------------------- }
{ * Requires IBObjects from www.ibobjects.com                                * }
{ * Requires Interbase or Firebird SQL Database                              * }
{ * Requires WebHub v2.175+                                                  * }
{ *                                                                          * }
{ * EXTREMELY EXPERIMENTAL !                                                 * }
{ *                                                                          * }
{ ---------------------------------------------------------------------------- }

interface

uses
  SysUtils, Classes, Controls, StdCtrls;

procedure CreateCodeGenPatternListbox(var ListBox: TListBox;
  InParent: TWinControl);

implementation

uses
  Math;

procedure CreateCodeGenPatternListbox(var ListBox: TListBox;
  InParent: TWinControl);
begin
  if ListBox = nil then
    ListBox := TListBox.Create(InParent);
  ListBox.Visible := False;
  ListBox.Parent := InParent;
  ListBox.Top := 3;
  ListBox.Left := 3;
  ListBox.Height := InParent.Height - 6;
  ListBox.Width := Min(370, InParent.Width - 3);
  ListBox.Items.Clear;
  ListBox.Items.Add('Whteko: Macros for Field Labels');
  ListBox.Items.Add('Whteko: Macros for Primary Keys');
  ListBox.Items.Add('Ini: Field List for IBObjects Import');
  ListBox.Items.Add('Whteko: Droplets with Select SQL for each table');
  ListBox.Items.Add('Whteko: Droplets with Update SQL for each table');
  ListBox.Items.Add('Whteko: Readonly Form for each table');
  ListBox.Items.Add('Whteko: Editable Form for each table');
  ListBox.Items.Add('Whteko: Editable Form, labels above, for each table');
  ListBox.MultiSelect := True;
  ListBox.Visible := True;
  ListBox.Selected[0] := True;
end;

end.
