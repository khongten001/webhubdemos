unit cntr_tlb;

{ This file contains pascal declarations imported from a type library.
  This file will be written during each import or refresh of the type
  library editor.  Changes to this file will be discarded during the
  refresh process. }

{ HREF Tools WebHub COM ServerLibrary }
{ Version 1.0 }

interface

uses Windows, ActiveX, Classes, Graphics, OleCtrls, StdVCL;

const
  LIBID_Cntr: TGUID = '{9953D563-DC9A-11D1-8C09-00C0F0168F2B}';

const

{ Component class GUIDs }
  Class_htComServer: TGUID = '{9953D565-DC9A-11D1-8C09-00C0F0168F2B}';

type

{ Forward declarations: Interfaces }
  IhtComServer = interface;
  IhtComServerDisp = dispinterface;

{ Forward declarations: CoClasses }
  htComServer = IhtComServer;

{ Dispatch interface for WebHub COM Objects }

  IhtComServer = interface(IDispatch)
    ['{9953D564-DC9A-11D1-8C09-00C0F0168F2B}']
    procedure Reset; safecall;
    procedure AddParam(Value: OleVariant); safecall;
    procedure Execute; safecall;
    function Get_ResultText: OleVariant; safecall;
    property ResultText: OleVariant read Get_ResultText;
  end;

{ DispInterface declaration for Dual Interface IhtComServer }

  IhtComServerDisp = dispinterface
    ['{9953D564-DC9A-11D1-8C09-00C0F0168F2B}']
    procedure Reset; dispid 1;
    procedure AddParam(Value: OleVariant); dispid 2;
    procedure Execute; dispid 3;
    property ResultText: OleVariant readonly dispid 4;
  end;

{ HREF Tools WebHub COM Server }

  CohtComServer = class
    class function Create: IhtComServer;
    class function CreateRemote(const MachineName: string): IhtComServer;
  end;



implementation

uses ComObj;

class function CohtComServer.Create: IhtComServer;
begin
  Result := CreateComObject(Class_htComServer) as IhtComServer;
end;

class function CohtComServer.CreateRemote(const MachineName: string): IhtComServer;
begin
  Result := CreateRemoteComObject(MachineName, Class_htComServer) as IhtComServer;
end;


end.
