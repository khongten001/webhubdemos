unit htsv_tlb;

{ This file contains pascal declarations imported from a type library.
  This file will be written during each import or refresh of the type
  library editor.  Changes to this file will be discarded during the
  refresh process. }

{ htSv Library }
{ Version 1.0 }

interface

uses Windows, ActiveX, Classes, Graphics, OleCtrls, StdVCL;

const
  LIBID_htSv: TGUID = '{CCE59214-F911-11D1-8C1A-00C0F0168F2B}';

const

{ Component class GUIDs }
  Class_htSvr: TGUID = '{CCE59216-F911-11D1-8C1A-00C0F0168F2B}';

type

{ Forward declarations: Interfaces }
  IhtSv = interface;
  IhtSvDisp = dispinterface;

{ Forward declarations: CoClasses }
  htSvr = IhtSv;

{ Dispatch interface for htSvr Object }

  IhtSv = interface(IDispatch)
    ['{CCE59215-F911-11D1-8C1A-00C0F0168F2B}']
    procedure Reset; safecall;
    procedure AddParam(Value: OleVariant); safecall;
    procedure Execute; safecall;
    function Get_ResultText: OleVariant; safecall;
    property ResultText: OleVariant read Get_ResultText;
  end;

{ DispInterface declaration for Dual Interface IhtSv }

  IhtSvDisp = dispinterface
    ['{CCE59215-F911-11D1-8C1A-00C0F0168F2B}']
    procedure Reset; dispid 1;
    procedure AddParam(Value: OleVariant); dispid 2;
    procedure Execute; dispid 3;
    property ResultText: OleVariant readonly dispid 4;
  end;

{ htSvrObject }

  CohtSvr = class
    class function Create: IhtSv;
    class function CreateRemote(const MachineName: string): IhtSv;
  end;



implementation

uses ComObj;

class function CohtSvr.Create: IhtSv;
begin
  Result := CreateComObject(Class_htSvr) as IhtSv;
end;

class function CohtSvr.CreateRemote(const MachineName: string): IhtSv;
begin
  Result := CreateRemoteComObject(MachineName, Class_htSvr) as IhtSv;
end;


end.
