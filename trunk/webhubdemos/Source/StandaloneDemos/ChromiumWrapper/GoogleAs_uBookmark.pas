unit GoogleAs_uBookmark;

(*
Permission is hereby granted, on 14-Jul-2017, free of charge, to any person
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

interface

uses
  Classes, SysUtils,
  System.Generics.Defaults,
  System.Generics.Collections,
  ZaphodsMap;

const
  cGoogleAs_ZMBranch = 'HREFTools' + PathDelim + 'CleanEntrance' + PathDelim +
    'cv001';

type
  /// <summary> lipAll means all fields entered at once on the same page.
  /// lipIndividual means enter one field at a time. </summary>
  TLoginInputPattern = (lipAll, lipIndividual);
type
  THtmlField = record
    guiNum: integer;
    guiPrompt_en: string;
    htmlID: string;
    end;
type
  TGoogleAsBookmark = record
    id: string;
    caption_en: string;
    url: string;
    inputPattern: TLoginInputPattern;
    htmlFields: array of ThtmlField;
  end;
type
  TGoogleAsBookmarkList = class(TList<TGoogleAsBookmark>);

function Load_Bookmarks: TGoogleAsBookmarkList;

implementation

uses
  NativeXml,
  ZM_CodeSiteInterface;

function Load_Bookmarks: TGoogleAsBookmarkList;
const cFn = 'Load_Bookmarks';
var
  ZM: TZaphodsMap;
  ADoc: TZaphodXmlDoc;
  WebNodeList, FieldNodeList: TXmlNodeList;
  //I,
  J: Integer;
  ABookmark: TGoogleAsBookmark;
  AHtmlField: THtmlField;
  WebSiteNode: TXmlNode;
  InputPatternStr: string;
begin
  CSEnterMethod(nil, cFn);
  CSSend('cGoogleAs_ZMBranch', cGoogleAs_ZMBranch);

  Result := TGoogleAsBookmarkList.Create;

  ZM := nil;
  WebNodeList := nil;
  FieldNodeList := nil;
  try
    ZM := TZaphodsMap.CreateForBranch(nil, cGoogleAs_ZMBranch);
    if ZM.BranchKeyboxExists then
    begin
      ADoc := ZM.ActivateKeyDoc('CleanEntrance', 'main', cxOptional, usrNone,
        'CleanEntrance',
        'D:\Projects\webhubdemos\Source\StandaloneDemos\ChromiumWrapper\' +
        'DevMenu01\CleanEntranceConfig.xml');

      if ADoc <> nil then
      begin

        WebNodeList := TXmlNodeList.Create;
        FieldNodeList := TXmlNodeList.Create;

        ADoc.Root.FindNodes('WebSite', WebNodeList);
        //CSSend('WebNodeList.Count', S(WebNodeList.Count));

        for WebSiteNode in WebNodeList do
        begin
          ABookmark.id := WebSiteNode.AttributeByName['id'];

          ABookmark.caption_en := ADoc.ZNodeAttr(WebSiteNode,
            ['Caption', '@lingvo', 'en'], cxOptional, '', 'value');
          //CSSend('ABookmark.caption_en', ABookmark.caption_en);

          ABookmark.url := ADoc.ZNodeAttr(WebSiteNode,
            ['Url'], cxOptional, '', 'value');
          //CSSend('ABookmark.url', ABookmark.url);

          InputPatternStr := ADoc.ZNodeAttr(WebSiteNode,
            ['InputPattern'], cxOptional, '', 'value');
          //CSSend('InputPatternStr', InputPatternStr);

          if InputPatternStr = 'individual' then
            ABookmark.InputPattern := lipIndividual
          else
            ABookmark.InputPattern := lipAll;

          WebSiteNode.FindNodes('Field', FieldNodeList);
          //CSSend('Found Field Nodes; Count', S(FieldNodeList.Count));

          SetLength(ABookmark.htmlFields, FieldNodeList.Count);

          for J := 0 to Pred(FieldNodeList.Count) do
          begin
            AHtmlField.guiNum :=
              StrToIntDef(FieldNodeList[J].AttributeByName['num'], -1);
            AHtmlField.guiPrompt_en :=
              FieldNodeList[J].AttributeByName['prompt'];
            AHtmlField.htmlID :=
              FieldNodeList[J].AttributeByName['htmlField'];
            //CSSend('AHtmlField.htmlID', AHtmlField.htmlID);
            ABookmark.htmlFields[J] := AHtmlField;
          end;
          Result.Add(ABookmark);
          FieldNodeList.Clear;
        end;
      end
      else
        CSSendError(ZM.LastKeyedDetail.ErrorMessage);
    end
    else
      CSSendError('ZM.BranchKeyboxExists FALSE');
  finally
    FreeAndNil(FieldNodeList);
    FreeAndNil(WebNodeList);
    ZM.DeactivateAllKeys;
    FreeAndNil(ZM);
  end;

  CSExitMethod(nil, cFn);
end;

end.
