unit sample;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, f2h, ExtCtrls;
                           
type
  TsampleFrm = class(TForm)
    WHForm2HTML1: TWHForm2HTML;
    butSubmit: TButton;
    butReset: TButton;
    ImgWH: TImage;
    Label3: TLabel;
    Panel1: TPanel;
    Label4: TLabel;
    Label8: TLabel;
    Label6: TLabel;
    lboBorder: TListBox;
    grpFonts: TGroupBox;
    rdoDFonts: TRadioButton;
    rdoBFonts: TRadioButton;
    cboBGColor: TComboBox;
    chkColor: TCheckBox;
    ediColor: TEdit;
    panBrowsers: TPanel;
    Label5: TLabel;
    bfIE4: TRadioButton;
    bfIE3: TRadioButton;
    bfNS4: TRadioButton;
    bfNS3: TRadioButton;
    bfDefault: TRadioButton;
    Label7: TLabel;
    Memo1: TMemo;
    labRO: TLabel;
    editRO: TEdit;
    labPass: TLabel;
    ediPass: TEdit;
    Label9: TLabel;
    butResetData: TButton;
    chkReadOnly: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure WHForm2HTML1BeforeRendering(ctl: TControl; hctl: THControl);
  private
  public
    { Public declarations }
  end;

var
  sampleFrm: TsampleFrm;

implementation

{$R *.DFM}

uses
  WebApp, TypInfo, whDM, ucString;

procedure TsampleFrm.WHForm2HTML1BeforeRendering(ctl: TControl;
  hctl: THControl);
var
   tmpAttr : THAttribute;
   bCustomColor : Boolean;
   procedure doAdaptObjsPos(bSetFonts : Boolean);
   begin
      if bSetFonts then
         begin
            memo1.setBounds(228,224,181,71);
            chkColor.setBounds(12,122,88,17);
            ediColor.setBounds(107,121,73,21);
            panel1.height := 232;
            grpFonts.setBounds(12,149,141,64);
            labRO.top := 309;
            editRO.top := 324;
            chkReadOnly.top := 349;
            labPass.top := 330;
            ediPass.top := 324;
            butSubmit.top := 376;
            butResetData.top := 376;
            butReset.top := 376;
        end
      else begin
         memo1.setBounds(228,229,181,69);
         chkColor.setBounds(30,116,88,17);
         ediColor.setBounds(34,137,91,21);
         panel1.height := 242;
         grpFonts.setBounds(12,165,141,64);
         labRO.top := 319;
         editRO.top := 334;
         chkReadOnly.top := 359;
         labPass.top := 335;
         ediPass.top := 334;
         butSubmit.top := 386;
         butResetData.top := 386;
         butReset.top := 386;
      end;
   end;
   procedure putUserBrowserRdoInBold;
   var
      rdo : TRadioButton;
   begin
      bfIE3.font.style := [];
      bfIE4.font.style := [];
      bfNS3.font.style := [];
      bfNS4.font.style := [];
      bfDefault.font.style := [];
      rdo := TRadioButton(sampleFrm.Findcomponent(pWebApp.StringVar[USER_BF]));
      if assigned(rdo) then
         rdo.Font.style := [fsBold];
   end;
begin

  with pWebapp, whForm2Html1 do
  begin
    //font selection:
    SetFonts:= StringVar['rdoFonts'] = 'rdoDFonts';
    doAdaptObjsPos(setFonts);
    // set BrowserFamily
    BrowserFamily := rdoBF2BF; // whDM

    putUserBrowserRdoInBold;

    // chkReadOnly
    editRO.enabled := not BoolVar['chkReadOnly'];

    //process rendering options
    //border combinations:
      with HMainContainer do begin
         tmpAttr := Attributes['ShowCaption'];
         if StringVar['lboBorder']='Titlebar' then
            tmpAttr.BooleanValue:= True
         else if StringVar['lboBorder']='Border' then
            begin
               tmpAttr.BooleanValue:= False;
               Attributes['Border'].BooleanValue:= True;
            end
         else begin
            tmpAttr.BooleanValue := False;
            Attributes['Border'].BooleanValue:= False;
         end;
         //background colors
         bCustomColor := BoolVar['chkColor'];
         if (tmpAttr.BooleanValue) and (not bCustomColor) and (StringVar['cboBGColor'] = '[None]') then   // ShowCaption
            BGColor := '#FFFFFF'  // White background
         else begin
            if bCustomColor then
               BGColor:= StringVar['ediColor']
            else
               BGColor:= StringVar['cboBGColor'];
            end;
         end;
   end;
end;


procedure TsampleFrm.FormCreate(Sender: TObject);
var
  AttrObject : THAttrObject;
begin
  Self.Scaled := False;
    with pWebapp, WHForm2HTML1 do begin
      attrObject := HMainContainer.FindHObjectByName('labCompare');
      if assigned(attrObject) then
         attrObject.Attributes['HREF'].Value := '/f2h/' +
           extractFileName(AppSetting['ScreenShotJPEG']);
    end;
end;

end.


