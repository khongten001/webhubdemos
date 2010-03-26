unit memo_tlb;

{ This file contains pascal declarations imported from a type library.
  This file will be written during each import or refresh of the type
  library editor.  Changes to this file will be discarded during the
  refresh process. }

{ Project1 Library }
{ Version 1.0 }

interface

uses Windows, ActiveX, Classes, Graphics, OleCtrls, StdVCL;

const
  LIBID_Memo: TGUID = '{85EE647B-D5C7-11D1-8C06-00C0F0168F2B}';

const

{ Component class GUIDs }
  Class_TMemoServer: TGUID = '{85EE647E-D5C7-11D1-8C06-00C0F0168F2B}';

type

{ Forward declarations: Interfaces }
  ITMemoServer = interface;
  ITMemoServerDisp = dispinterface;

{ Forward declarations: CoClasses }
  TMemoServer = ITMemoServer;

{ Dispatch interface for TMemoServer Object }

  ITMemoServer = interface(IDispatch)
    ['{85EE647C-D5C7-11D1-8C06-00C0F0168F2B}']
    function Get_ResultText: OleVariant; safecall;
    procedure Execute; safecall;
    procedure AddParam(Value: OleVariant); safecall;
    procedure Reset; safecall;
    property ResultText: OleVariant read Get_ResultText;
  end;

{ DispInterface declaration for Dual Interface ITMemoServer }

  ITMemoServerDisp = dispinterface
    ['{85EE647C-D5C7-11D1-8C06-00C0F0168F2B}']
    property ResultText: OleVariant readonly dispid 1;
    procedure Execute; dispid 2;
    procedure AddParam(Value: OleVariant); dispid 3;
    procedure Reset; dispid 4;
  end;

{ TMemoServer Object }

  CoTMemoServer = class
    class function Create: ITMemoServer;
    class function CreateRemote(const MachineName: string): ITMemoServer;
  end;



implementation

uses ComObj;

class function CoTMemoServer.Create: ITMemoServer;
begin
  Result := CreateComObject(Class_TMemoServer) as ITMemoServer;
end;

class function CoTMemoServer.CreateRemote(const MachineName: string): ITMemoServer;
begin
  Result := CreateRemoteComObject(MachineName, Class_TMemoServer) as ITMemoServer;
end;


end.
