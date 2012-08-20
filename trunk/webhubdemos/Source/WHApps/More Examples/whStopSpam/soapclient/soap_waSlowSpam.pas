// ************************************************************************ //
// The types declared in this file were generated from data read from the
// WSDL File described below:
// WSDL     : http://more.demos.href.com/scripts/runisa.dll/htun/wsdl/waSlowSpam
// Encoding : utf-8
// Version  : 1.0
// (07/04/2005 5:54:40 PM - 1.33.2.5)
// URL adjusted 15-Oct-2010 from demos.href.com to more.demos.href.com
//                          and to make the AppID 'htun' lowercase
// ************************************************************************ //

unit soap_waSlowSpam;

interface

uses InvokeRegistry, SOAPHTTPClient, Types, XSBuiltIns;

type

  // ************************************************************************ //
  // The following types, referred to in the WSDL document are not being represented
  // in this file. They are either aliases[@] of other types represented or were referred
  // to but never[!] declared in the document. The types from the latter category
  // typically map to predefined/known XML or Borland types; however, they could also
  // indicate incorrect WSDL documents that failed to declare or import a schema type.
  // ************************************************************************ //
  // !:unsignedInt     - "http://www.w3.org/2001/XMLSchema"
  // !:string          - "http://www.w3.org/2001/XMLSchema"
  // !:boolean         - "http://www.w3.org/2001/XMLSchema"


  // ************************************************************************ //
  // Namespace : urn:whStopSpam_dmwh-waSlowSpam
  // soapAction: urn:whStopSpam_dmwh-waSlowSpam#MailtoStrObfuscate
  // transport : http://schemas.xmlsoap.org/soap/http
  // style     : rpc
  // binding   : waSlowSpamBinding
  // service   : waSlowSpamService
  // port      : waSlowSpamPort
  // URL       : http://more.demos.href.com/scripts/runisa.dll/htun/soap/waSlowSpam
  // ************************************************************************ //
  IwaSlowSpam = interface(IInvokable)
  ['{B50CBDD7-C839-6817-0DA5-FE8C213BD54B}']
    function  MailtoStrObfuscate(var ProcessID: Cardinal;
      var SessionID: Cardinal; const input: WideString;
      const MakeResultReadyToCopyFromWeb: Boolean): WideString; stdcall;
    function TestStringTransfer(const MakeStringThisLong: Integer): string;
      stdcall;
  end;

function GetIwaSlowSpam(UseWSDL: Boolean=System.False; Addr: string=''; HTTPRIO: THTTPRIO = nil): IwaSlowSpam;

procedure SetURLs(const WSDL, URL: string);

implementation

var
  defWSDL: string;
  defURL: string;

function GetIwaSlowSpam(UseWSDL: Boolean; Addr: string; HTTPRIO: THTTPRIO): IwaSlowSpam;
const
  defSvc  = 'waSlowSpamService';
  defPrt  = 'waSlowSpamPort';
var
  RIO: THTTPRIO;
begin
  Result := nil;
  if (Addr = '') then
  begin
    if UseWSDL then
      Addr := defWSDL
    else
      Addr := defURL;
  end;
  if HTTPRIO = nil then
    RIO := THTTPRIO.Create(nil)
  else
    RIO := HTTPRIO;
  try
    Result := (RIO as IwaSlowSpam);
    if UseWSDL then
    begin
      RIO.WSDLLocation := Addr;
      RIO.Service := defSvc;
      RIO.Port := defPrt;
    end else
      RIO.URL := Addr;
  finally
    if (Result = nil) and (HTTPRIO = nil) then
      RIO.Free;
  end;
end;

procedure SetURLs(const WSDL, URL: string);
begin
  defWSDL := WSDL;
  defURL := URL;
end;

initialization
  defWSDL := 'http://more.demos.href.com/' +
    'scripts/runisa.dll/htun/wsdl/waSlowSpam';
  defURL  := 'http://more.demos.href.com/' +
    'scripts/runisa.dll/htun/soap/waSlowSpam';
  InvRegistry.RegisterInterface(TypeInfo(IwaSlowSpam),
    'urn:whStopSpam_dmWh-waSlowSpam', '');
  InvRegistry.RegisterDefaultSOAPAction(TypeInfo(IwaSlowSpam),
    'urn:whStopSpam_dmWh-waSlowSpam#MailtoStrObfuscate');

end.
