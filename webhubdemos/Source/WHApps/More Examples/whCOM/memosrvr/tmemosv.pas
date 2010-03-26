unit tmemosv;

// The purpose of this example is to show a very, very simple COM server
// example.  The required methods are implemented: Get_ResultText, AddParam,
// Execute and Reset.  These methods are called by the TwhDCOM object within
// a WebHub application, when the COM macro is used.
//
// They are called in this order:
// Reset
// AddParam for all parameters passed in to the COM macro
// Execute
// Get_ResultText --> this is what is displayed on the web.

interface

uses
  Variants, ComObj, Memo_TLB;

type
  TTMemoServer = class(TAutoObject, ITMemoServer)
  protected
    function Get_ResultText: OleVariant; safecall;      // output
    procedure AddParam(Value: OleVariant); safecall;    // input
    procedure Execute; safecall;                        // process
    procedure Reset; safecall;                          // process
  end;

implementation

uses
  SysUtils, ComServ, fmMemoSv;

function TTMemoServer.Get_ResultText: OleVariant;
begin
  // This function defines the data which will be displayed on the web.
  // The result is passed back to the TwhDCOM object (when this server
  // is used within a WebHub application.)
  Result:=Form1.Memo1.Text;
end;

procedure TTMemoServer.AddParam(Value: OleVariant);
begin
  // This function is called for each parameter passed through the
  // COM macro.
  Form1.Memo1.Lines.Add('<li>'+VarToStr(Value));
end;

procedure TTMemoServer.Execute;
begin
  // Change the input data in some way to convince you that there is
  // fire behind the smoke and mirrors.
  // Here we are just adding a <ul> and trailing </ul>
  Form1.Memo1.Text:='<ul>'+sLineBreak+Form1.Memo1.Text+'</ul>'+sLineBreak;
end;

procedure TTMemoServer.Reset; safecall;
begin
  // Reset to blank.  This is called before any parameters are added.
  Form1.Memo1.Text:='';
end;

initialization
  TAutoObjectFactory.Create(ComServer, TTMemoServer, Class_TMemoServer, ciMultiInstance);
end.
