program S3ACLPublic;

{$APPTYPE CONSOLE}

{$R *.res}

(*
Permission is hereby granted, on 23-Jul-2017, free of charge, to any person
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

Author: Ann Lynnworth at HREF Tools Corp.
*)

uses
  System.SysUtils,
  ZM_CodeSiteInterface,
  Vcl.Forms,  // this brings in MSXML which is required for Delphi AWS
  ZaphodsMap,
  uCode in 'k:\webhub\tpack\uCode.pas',
  uAWS_S3 in '..\AmazonS3Upload\uAWS_S3.pas',
  S3ACLPublic_uMarkPublic in 'S3ACLPublic_uMarkPublic.pas';

var
  bActionIt: Boolean = False;
  bucketName, leadingPath: string;
  matchThis: string;
  awsKey, awsSecretZMKey, awsSecret: string;
  JustRootFolder: Boolean;
  awsRegion: string = 'us-east-1';
  KeyedDetail: TKeyedDetail;
  MaxFilesToTouch: Integer;

begin
  if (ParamCount = 0) or HaveParam('/?') or HaveParam('--help') then
  begin
    SetCodeSiteLoggingState([cslAll]);
    CSSendNote(ReportSyntaxAvailable);
    WriteLn(ReportSyntaxAvailable);
  end
  else
  begin

    if HaveParam('/-quiet') then
      SetCodeSiteLoggingState([cslWarning, cslError, cslException])
    else
    begin
      SetCodeSiteLoggingState([cslAll]);
      {$IFDEF DEBUG}CSSendNote(ReportSyntaxUsed);{$ENDIF} // reveals access key.
    end;

    bActionIt := NOT HaveParam('/-dryrun');
    //CSSend('DPR bActionIt', S(bActionIt));

    bucketName := ParamString('BucketName');
    leadingPath := ParamString('LeadingPath');
    matchThis := ParamString('MatchThis');
    awsKey := ParamString('AccessKey');
    awsSecretZMKey := ParamString('SecretKey');
    awsSecret := ZaphodKeyedValue('HREFTools' + PathDelim + 'FileTransfer',
      'S3', awsSecretZMKey, cxOptional, usrNone, '', KeyedDetail);
    JustRootFolder := HaveParam('/JustRoot');
    awsRegion := ParamString('Region');
    if awsRegion = '' then
      awsRegion := 'us-east-1';
    MaxFilesToTouch := StrToIntDef(ParamString('MaxFiles'), 0);

    try
      TagPublic(bActionIt, bucketName, leadingPath, matchThis,
        awsKey, awsSecret, JustRootFolder, MaxFilesToTouch, awsRegion);
    except
      on E: Exception do
        Writeln(E.ClassName, ': ', E.Message);
    end;

  end;
end.
