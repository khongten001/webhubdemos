unit whConverter_fmWhProcess;
(*
Copyright (c) 2003-2017 HREF Tools Corp.
Author: Ann Lynnworth

Permission is hereby granted, on 22-Aug-2003, free of charge, to any person
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
*)

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UTPANFRM, ExtCtrls, StdCtrls, Buttons, Vcl.ComCtrls,
  UpdateOk, tpAction, Toolbar, iniLink, tpCompPanel, Restorer, tpmemo, tpstatus,
  webTypes, weblink, webBase;

type
  TfmWhProcess = class(TutParentForm)
    ToolBar: TtpToolBar;
    Panel: TPanel;
    ConverterFilename: TGroupBox;
    tpMemoConfig: TtpMemo;
    tpToolButton2: TtpToolButton;
    iniconfig: TIniFileLink;
    tpToolButton1: TtpToolButton;
    waValidateCoupon: TwhWebAction;
    tpStatusBar1: TtpStatusBar;
    waConvert: TwhWebAction;
    waDownload: TwhWebAction;
    procedure tpToolButton2Click(Sender: TObject);
    procedure tpToolButton1Click(Sender: TObject);
    procedure waValidateCouponExecute(Sender: TObject);
    procedure waConvertExecute(Sender: TObject);
    procedure waDownloadExecute(Sender: TObject);
  private
    { Private declarations }
    FLastFileType: string;
    FLastFileTooBig: Boolean;
  public
    { Public declarations }
    function Init: Boolean; override;
    procedure Uploaded(      Sender: TwhBasicApp;
                       const ServerKey: string;
                       const UploadFileCount, UploadFileTotal: Integer;
                       const FileName, FileType, FileSource: string;
                       const FileSize: Integer;
                       const FileTooBig: Boolean;
                       var   SaveAs: String;
                       var   KeepNow, KeepOnExit: Boolean);
    end;

var
  fmWhProcess: TfmWhProcess;

implementation

{$R *.DFM}

uses
  {$IFDEF CodeSite}CodeSiteLogging,{$ENDIF}
  DateUtils,
  ucShell, ucLogFil, ucFile, ucDlgs, ZM_CodeSiteInterface,
  webApp;

function TfmWhProcess.Init: Boolean;
begin
  Result:= inherited Init;
  if not Result then
    Exit;

  {This INIT function is used to initialize aspects of the WebHub system that
   are particular to the file conversion application.}

  ConverterFilename.Caption := pWebApp.AppSetting['ConverterEXE'];
  iniConfig.IniFilename := pWebApp.AppSetting['ConverterConfig'];
  tpMemoConfig.Filename := iniConfig.IniFilename;

  {Hook up the OnUploaded event at run-time to avoid changing the standard
   WebHub datamodules.}
  pWebApp.OnUploaded := fmWhProcess.Uploaded;
end;


{______________________________________________________________________________}
{ The next 2 procedures are for testing within the GUI only.  They are not used}
{ by any site visitors.                                                        }
{______________________________________________________________________________}

procedure TfmWhProcess.tpToolButton2Click(Sender: TObject);
begin
  inherited;
  {Save the changes made to the test configuration file.}
  tpMemoConfig.Save;
end;

procedure TfmWhProcess.tpToolButton1Click(Sender: TObject);
var
  S, ErrorText: String;
  outputFile: String;
begin
  inherited;
  {This procedure is here so that you can test from the panel GUI. It is not
   used by the web application at all.}

  { usage: converter.exe configurationFilename
    the output will be placed into a file specified through the configuration }
  iniConfig.Section := 'CharReplace';
  outputFile := iniConfig.StringEntry['OutputFile'];
  DeleteFile(outputFile);

  {Start running the converter.}
  Launch(ConverterFilename.Caption,
    '"' + tpMemoConfig.Filename + '"', '', True, 3000, ErrorText);

  if FileExists(outputFile) then
  begin
    S := StringLoadFromFile(outputFile);
    MsgInfoOk(S);
  end
  else
  begin
    MsgInfoOk('Converter did not generate output file named ' + outputFile
     + sLineBreak + ErrorText);
  end;
end;

{______________________________________________________________________________}

procedure TfmWhProcess.Uploaded(Sender: TwhBasicApp; const ServerKey: string;
  const UploadFileCount, UploadFileTotal: Integer;
  const FileName, FileType, FileSource: String; const FileSize: Integer;
  const FileTooBig: Boolean;
  var SaveAs: String; var KeepNow, KeepOnExit: Boolean);
const cFn = 'Uploaded';
var
  tempPath: String;
begin
  CSEnterMethod(Self, cFn);
  {This event is called by the WebHub System whenever a file is uploaded.      }
  CSSend('FileName', FileName);
  CSSend('FileSource', FileSource);
  CSSend('FileType', FileType);
  CSSend('FileSize', S(FileSize));
  CSSend('default SaveAs', SaveAs);
  CSSend('FileTooBig', S(FileTooBig));
  FLastFileType := FileType;
  FLastFileTooBig := FileTooBig;

  if NOT FileTooBig then
  begin
    {Save the uploaded file to a temporary directory, making the file sufficiently
     unique for our purposes by putting the surfer session number into the
     filename.}
    tempPath := pWebApp.AppSetting['TempPath'];
    CSSend('tempPath', tempPath);
    ForceDirectories(tempPath);  // make sure target folder exists

    SaveAs := tempPath + 'whConverterInput' +
              IntToStr(TwhAppBase(Sender).SessionNumber) + '.dat';
    CSSend('SaveAs', SaveAs);
    if FileExists(SaveAs) then
      SysUtils.DeleteFile(SaveAs)
    else
      ;  // this is normal when a unique file name is uploaded
    KeepNow := True;
    KeepOnExit := True;
  end
  else
  begin
    KeepNow := False;
    KeepOnExit := False;
  end;
  CSExitMethod(Self, cFn);
end;

{______________________________________________________________________________}

procedure TfmWhProcess.waValidateCouponExecute(Sender: TObject);
begin
  inherited;
  {This procedure could be made much more sophisticated so as to allow for
   various coupons based on various rules to enforce various billing policies.}
  with TwhWebActionEx(Sender) do
  begin
    if (CompareText(WebApp.StringVar['inCoupon'], 'FREE') = 0) then
       // okay
    else
      WebApp.SendMacro('PAGE|pgInvalidCoupon');
  end;
end;

{______________________________________________________________________________}

procedure TfmWhProcess.waConvertExecute(Sender: TObject);
const cFn = 'waConvertExecute';
var
  tempPath: String;
  inputFilename, outputFilename: String;
  FromData, ToData: String;
  ErrorText: String;
  maximumBytes: Integer;
  convConfigFilespec: string;
  bContinue: Boolean;
begin
  CSEnterMethod(Self, cFn);

  bContinue := NOT FLastFileTooBig;
  if NOT bContinue then
  begin
    pWebApp.SendStringImm('<p>Error: That file was exceeded the upload limit for the WebHub runner.</p>');
    bContinue := False;
  end;

  if bContinue then
  begin
    { NB: Count can be 0 when KeepNow in OnUploaded event gets set to False
      because the uploaded file was too big. }
    bContinue := pWebApp.Runtime.UploadedFiles.Count > 0;
    if NOT bContinue then
      pWebApp.SendStringImm('<p>Error: No uploaded files detected.</p>');
  end;

  if bContinue then
  begin

    with TwhWebActionEx(Sender), WebApp do
    begin
      bContinue := FileExists(ConverterFilename.Caption);
      if NOT bContinue then
      begin
        SendString('Error: converter "' + ConverterFilename.Caption +
          '" does not exist.');
      end;
      if bContinue then
      begin

        if (FLastFileType <> 'image/jpeg') then
        begin
          tempPath := AppSetting['TempPath'];
          convConfigFilespec := tempPath + 'whConverterConfig' +
            IntToStr(SessionNumber) + '.set';
          iniConfig.Section := 'CharReplace';
          inputFilename := tempPath + 'whConverterInput' + IntToStr(SessionNumber) +
            '.dat';

          if NOT FileExists(inputFilename) then
          begin
            SendString('Error: input file "' + inputFilename +
              '" does not exist.');
            bContinue := False;
          end;
        end
        else
        begin
          SendStringImm('Invalid file type: ' + FLastFileType);
            bContinue := False;
        end;
      end;

      if bContinue then
      begin
        maximumBytes := StrToIntDef(AppSetting['MaximumFreeSize'], 1) * 1024;
        if GetFileSize(inputFilename) > maximumBytes then
        begin
          SendString('With FREE coupon, input file size must be smaller than ' +
            IntToStr(maximumBytes) + ' bytes.');
          DeleteFile(inputFilename);
          bContinue := False;
        end;
      end;

      if bContinue then
      begin
          outputFilename := tempPath + 'whConverterOutput' + IntToStr(SessionNumber) +
            '.dat';
          DeleteFile(outputFilename);

          FromData := StringVar['inFrom'];
          ToData := StringVar['inTo'];

          if (Length(FromData)<>1) or (Length(ToData)<>1) then
          begin
            SendString('Both the "From" and the "To" values must be single characters.');
            DeleteFile(inputFilename);
            bContinue := False;
          end;
      end;

      if bContinue then
      begin
        {This is where we create a temporary configuration file which guides the
         converter to do its job.  The name of the configuration file is based on
         the surfer session number.}
        StringWriteToFile(convConfigFilespec,
          '[CharReplace]' + sLineBreak +
          'InputFile=' + inputFilename + sLineBreak +
          'OutputFile=' + outputFilename + sLineBreak +
          'From=' + FromData + sLineBreak +
          'To=' + ToData + sLineBreak);

        {Start running the converter. Allow 20 seconds max to complete.}
        SendStringImm('Launching: ' +
          ConverterFilename.Caption + ' ' + convConfigFilespec + '<p>');
        Launch( ConverterFilename.Caption,
          '"' + convConfigFilespec + '"', '', True, 20000, ErrorText);

        {Delete the temporary configuration file.}
        DeleteFile(convConfigFilespec);

        if FileExists(outputFilename) then
        begin
          SendStringImm('The conversion was successful.<p>Click ');
          SendMacro('JUMP|pgDownloadResult,/output.dat|here');
          SendStringImm(' to download the result.');
        end
        else
        begin
          SendStringImm('Unable to create output file named ' + outputFilename);
          if ErrorText <> '' then
            SendStringImm( '<p>Error:' + ErrorText + '</p>');
        end;
      end;
    end;
  end;
  CSExitMethod(Self, cFn);
end;

{______________________________________________________________________________}

procedure TfmWhProcess.waDownloadExecute(Sender: TObject);
var
  outputFilename: String;
begin
  inherited;
  {Make the output file available to the surfer.}
  with TwhWebActionEx(Sender) do
  begin
    outputFilename := WebApp.AppSetting['TempPath'] + 'whConverterOutput' +
                      IntToStr(WebApp.SessionNumber) + '.dat';
    Response.SendFileIIS(outputFilename, 'application/octet-stream',
      True);  // delete after send = True
  end;
end;

end.
