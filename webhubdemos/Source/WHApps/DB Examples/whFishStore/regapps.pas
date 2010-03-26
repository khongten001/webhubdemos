unit regapps;  {Register Components for WebHub Demos}

//  Authors: Michael Ax and Ann Lynnworth.
//  Copyright (c) 1995-1998 HREF Tools Corp.  All Rights Reserved.

interface

uses 
  Classes, DsgnIntf, tFish;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents( 'HT+', [ TFishApp, TFishSession]);
end;

end.

