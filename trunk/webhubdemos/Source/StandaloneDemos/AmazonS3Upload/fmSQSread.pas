unit fmSQSread;

(* example project to read messages from Amazon Simple Queue Service *)

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.StdCtrls,
  Data.Cloud.CloudAPI, Data.Cloud.AmazonAPI;

type
  TForm5 = class(TForm)
    AmazonConnectionInfo1: TAmazonConnectionInfo;
    Memo1: TMemo;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form5: TForm5;

implementation

{$R *.dfm}

uses
  System.Generics.Collections;

const
 cProtocol = 'https';

procedure TForm5.Button1Click(Sender: TObject);
{$I amazon_secret_info.txt}  // you can comment this INCLUDE out
var
  ResponseInfo: TCloudResponseInfo;
  aqs: TAmazonQueueService;
  amessage: TCloudQueueMessage;
  messageList: TList<TCloudQueueMessage>;
  infoMsg: string;
begin
  aqs := nil;

  AmazonConnectionInfo1.AccountName := cAKey;
  AmazonConnectionInfo1.AccountKey := cSAKey;
  AmazonConnectionInfo1.Protocol := cProtocol;

  //AmazonConnectionInfo1.UseDefaultEndpoints := ('us-east-1' = cS3Region);

  try
    aqs := TAmazonQueueService.Create(AmazonConnectionInfo1);
    ResponseInfo := TCloudResponseInfo.Create;
    messageList := aqs.GetMessages(
      'https://sqs.us-west-2.amazonaws.com/653403938628/' +
      'hreftools_email_problems', 100, 0, ResponseInfo);
    InfoMsg :=
      Format('ResponseInfo: statuscode %d, message %s',
      [ResponseInfo.StatusCode,
      ResponseInfo.StatusMessage]);
    Memo1.Lines.Add(InfoMsg);

    if Assigned(messageList) and (messageList.Count > 0) then
    begin
      for aMessage in messageList do
      begin
        Memo1.Lines.Add(aMessage.Properties.Text);
        Memo1.Lines.Add(aMessage.MessageText);
        Memo1.Lines.Add('---');
      end;
    end;
  finally
    FreeAndNil(ResponseInfo);
    FreeAndNil(messageList);
    FreeAndNil(aqs);
  end;
end;

end.
