unit uDefaultSelenium;

interface

uses
  uISelenium, uICommandProcessor, uHttpCommandProcessor, uCommon;

type

  DefaultSelenium = class(TInterfacedObject, ISelenium)
  protected
    commandProcessor: ICommandProcessor;
  public
    constructor Create(serverHost: UTF8String; serverPort: integer; browserString: UTF8String; browserURL: UTF8String); overload;
    constructor Create(processor: ICommandProcessor); overload;
    function Processor: ICommandProcessor;
    procedure Start();
    procedure Stop();
    procedure Click(locator: UTF8String);
    procedure ClickAndWait(locator: UTF8String);
    procedure DoubleClick(locator: UTF8String);
    procedure ContextMenu(locator: UTF8String);
    procedure ClickAt(locator: UTF8String; coordString: UTF8String);
    procedure DoubleClickAt(locator: UTF8String; coordString: UTF8String);
    procedure ContextMenuAt(locator: UTF8String; coordString: UTF8String);
    procedure FireEvent(locator: UTF8String; eventName: UTF8String);
    procedure Focus(locator: UTF8String);
    procedure KeyPress(locator: UTF8String; keySequence: UTF8String);
    procedure ShiftKeyDown();
    procedure ShiftKeyUp();
    procedure MetaKeyDown();
    procedure MetaKeyUp();
    procedure AltKeyDown();
    procedure AltKeyUp();
    procedure ControlKeyDown();
    procedure ControlKeyUp();
    procedure KeyDown(locator: UTF8String; keySequence: UTF8String);
    procedure KeyUp(locator: UTF8String; keySequence: UTF8String);
    procedure MouseOver(locator: UTF8String);
    procedure MouseOut(locator: UTF8String);
    procedure MouseDown(locator: UTF8String);
    procedure MouseDownAt(locator: UTF8String; coordString: UTF8String);
    procedure MouseUp(locator: UTF8String);
    procedure MouseUpAt(locator: UTF8String; coordString: UTF8String);
    procedure MouseMove(locator: UTF8String);
    procedure MouseMoveAt(locator: UTF8String; coordString: UTF8String);
    procedure Type_(locator: UTF8String; value: UTF8String);
    procedure TypeKeys(locator: UTF8String; value: UTF8String);
    procedure SetSpeed(value: UTF8String);
    function GetSpeed(): UTF8String;
    procedure Check(locator: UTF8String);
    procedure Uncheck(locator: UTF8String);
    procedure Select(selectLocator: UTF8String; optionLocator: UTF8String);
    procedure AddSelection(locator: UTF8String; optionLocator: UTF8String);
    procedure RemoveSelection(locator: UTF8String; optionLocator: UTF8String);
    procedure RemoveAllSelections(locator: UTF8String);
    procedure Submit(formLocator: UTF8String);
    procedure Open(url: UTF8String);
    procedure OpenWindow(url: UTF8String; windowID: UTF8String);
    procedure SelectWindow(windowID: UTF8String);
    procedure SelectFrame(locator: UTF8String);
    function GetWhetherThisFrameMatchFrameExpression(currentFrameString: UTF8String; target: UTF8String): boolean;
    function GetWhetherThisWindowMatchWindowExpression(currentWindowString: UTF8String; target: UTF8String): boolean;
    procedure WaitForPopUp(windowID: UTF8String; timeout: UTF8String);
    procedure ChooseCancelOnNextConfirmation();
    procedure ChooseOkOnNextConfirmation();
    procedure AnswerOnNextPrompt(answer: UTF8String);
    procedure GoBack();
    procedure Refresh();
    procedure Close();
    function IsAlertPresent(): boolean;
    function IsPromptPresent(): boolean;
    function IsConfirmationPresent(): boolean;
    function GetAlert(): UTF8String;
    function GetConfirmation(): UTF8String;
    function GetPrompt(): UTF8String;
    function GetLocation(): UTF8String;
    function GetTitle(): UTF8String;
    function GetBodyText(): UTF8String;
    function GetValue(locator: UTF8String): UTF8String;
    function GetText(locator: UTF8String): UTF8String;
    procedure Highlight(locator: UTF8String);
    function GetEval(script: UTF8String): UTF8String;
    function IsChecked(locator: UTF8String): boolean;
    function GetTable(tableCellAddress: UTF8String): UTF8String;
    function GetSelectedLabels(selectLocator: UTF8String): ArrayOfUTF8String;
    function GetSelectedLabel(selectLocator: UTF8String): UTF8String;
    function GetSelectedValues(selectLocator: UTF8String): ArrayOfUTF8String;
    function GetSelectedValue(selectLocator: UTF8String): UTF8String;
    function GetSelectedIndexes(selectLocator: UTF8String): ArrayOfUTF8String;
    function GetSelectedIndex(selectLocator: UTF8String): UTF8String;
    function GetSelectedIds(selectLocator: UTF8String): ArrayOfUTF8String;
    function GetSelectedId(selectLocator: UTF8String): UTF8String;
    function IsSomethingSelected(selectLocator: UTF8String): boolean;
    function GetSelectOptions(selectLocator: UTF8String): ArrayOfUTF8String;
    function GetAttribute(attributeLocator: UTF8String): UTF8String;
    function IsTextPresent(pattern: UTF8String): boolean;
    function IsElementPresent(locator: UTF8String): boolean;
    function IsVisible(locator: UTF8String): boolean;
    function IsEditable(locator: UTF8String): boolean;
    function GetAllButtons(): ArrayOfUTF8String;
    function GetAllLinks(): ArrayOfUTF8String;
    function GetAllFields(): ArrayOfUTF8String;
    function GetAttributeFromAllWindows(attributeName: UTF8String): ArrayOfUTF8String;
    procedure Dragdrop(locator: UTF8String; movementsString: UTF8String);
    procedure SetMouseSpeed(pixels: UTF8String);
    function GetMouseSpeed(): double;
    procedure DragAndDrop(locator: UTF8String; movementsString: UTF8String);
    procedure DragAndDropToObject(locatorOfObjectToBeDragged: UTF8String; locatorOfDragDestinationObject: UTF8String);
    procedure WindowFocus();
    procedure WindowMaximize();
    function GetAllWindowIds(): ArrayOfUTF8String;
    function GetAllWindowNames(): ArrayOfUTF8String;
    function GetAllWindowTitles(): ArrayOfUTF8String;
    function GetHtmlSource(): UTF8String;
    procedure SetCursorPosition(locator: UTF8String; position: UTF8String);
    function GetElementIndex(locator: UTF8String): double;
    function IsOrdered(locator1: UTF8String; locator2: UTF8String): boolean;
    function GetElementPositionLeft(locator: UTF8String): double;
    function GetElementPositionTop(locator: UTF8String): double;
    function GetElementWidth(locator: UTF8String): double;
    function GetElementHeight(locator: UTF8String): double;
    function GetCursorPosition(locator: UTF8String): double;
    function GetExpression(expression: UTF8String): UTF8String;
    function GetXpathCount(xpath: UTF8String): double;
    procedure AssignId(locator: UTF8String; identifier: UTF8String);
    procedure AllowNativeXpath(allow: UTF8String);
    procedure IgnoreAttributesWithoutValue(ignore: UTF8String);
    procedure WaitForCondition(script: UTF8String; timeout: UTF8String);
    procedure SetTimeout(timeout: UTF8String);
    procedure WaitForPageToLoad(timeout: UTF8String);
    procedure WaitForFrameToLoad(frameAddress: UTF8String; timeout: UTF8String);
    function GetCookie(): UTF8String;
    function GetCookieByName(name: UTF8String): UTF8String;
    function IsCookiePresent(name: UTF8String): boolean;
    procedure CreateCookie(nameValuePair: UTF8String; optionsString: UTF8String);
    procedure DeleteCookie(name: UTF8String; optionsString: UTF8String);
    procedure DeleteAllVisibleCookies();
    procedure SetBrowserLogLevel(logLevel: UTF8String);
    procedure RunScript(script: UTF8String);
    procedure AddLocationStrategy(strategyName: UTF8String; functionDefinition: UTF8String);
    procedure CaptureEntirePageScreenshot(filename: UTF8String);
    procedure SetContext(context: UTF8String);
    procedure AttachFile(fieldLocator: UTF8String; fileLocator: UTF8String);
    procedure CaptureScreenshot(filename: UTF8String);
    procedure ShutDownSeleniumServer();
    procedure KeyDownNative(keycode: UTF8String);
    procedure KeyUpNative(keycode: UTF8String);
    procedure KeyPressNative(keycode: UTF8String);
  end;

implementation

constructor DefaultSelenium.Create(serverHost: UTF8String; serverPort: integer; browserString: UTF8String; browserURL: UTF8String);
begin
  commandProcessor := HttpCommandProcessor.Create(serverHost, serverPort, browserString, browserURL);
end;

constructor DefaultSelenium.Create(processor: ICommandProcessor);
begin
  commandProcessor := processor;
end;

function DefaultSelenium.Processor: ICommandProcessor;
begin
  result := commandProcessor;
end;

procedure DefaultSelenium.Start();
begin
  commandProcessor.Start();
end;

procedure DefaultSelenium.Stop();
begin
  commandProcessor.Stop();
end;

procedure DefaultSelenium.Click(locator: UTF8String);
begin
  commandProcessor.DoCommand('click',
    ArrayOfUTF8String.Create(locator, ''));
end;

procedure DefaultSelenium.ClickAndWait(locator: UTF8String);
begin
  Click(locator);
  WaitForPageToLoad('30000');
end;

procedure DefaultSelenium.DoubleClick(locator: UTF8String);
begin
  commandProcessor.DoCommand('doubleClick', ArrayOfUTF8String.Create(locator, ''));
end;

procedure DefaultSelenium.ContextMenu(locator: UTF8String);
begin
  commandProcessor.DoCommand('contextMenu', ArrayOfUTF8String.Create(locator));
end;

procedure DefaultSelenium.ClickAt(locator: UTF8String; coordString: UTF8String);
begin
  commandProcessor.DoCommand('clickAt', ArrayOfUTF8String.Create(locator, coordString));
end;

procedure DefaultSelenium.DoubleClickAt(locator: UTF8String; coordString: UTF8String);
begin
  commandProcessor.DoCommand('doubleClickAt', ArrayOfUTF8String.Create(locator, coordString));
end;

procedure DefaultSelenium.ContextMenuAt(locator: UTF8String; coordString: UTF8String);
begin
  commandProcessor.DoCommand('contextMenuAt', ArrayOfUTF8String.Create(locator, coordString));
end;

procedure DefaultSelenium.FireEvent(locator: UTF8String; eventName: UTF8String);
begin
  commandProcessor.DoCommand('fireEvent', ArrayOfUTF8String.Create(locator, eventName));
end;

procedure DefaultSelenium.Focus(locator: UTF8String);
begin
  commandProcessor.DoCommand('focus', ArrayOfUTF8String.Create(locator));
end;

procedure DefaultSelenium.KeyPress(locator: UTF8String; keySequence: UTF8String);
begin
  commandProcessor.DoCommand('keyPress', ArrayOfUTF8String.Create(locator, keySequence));
end;

procedure DefaultSelenium.ShiftKeyDown();
begin
  commandProcessor.DoCommand('shiftKeyDown', ArrayOfUTF8String.Create());
end;

procedure DefaultSelenium.ShiftKeyUp();
begin
  commandProcessor.DoCommand('shiftKeyUp', ArrayOfUTF8String.Create());
end;

procedure DefaultSelenium.MetaKeyDown();
begin
  commandProcessor.DoCommand('metaKeyDown', ArrayOfUTF8String.Create());
end;

procedure DefaultSelenium.MetaKeyUp();
begin
  commandProcessor.DoCommand('metaKeyUp', ArrayOfUTF8String.Create());
end;

procedure DefaultSelenium.AltKeyDown();
begin
  commandProcessor.DoCommand('altKeyDown', ArrayOfUTF8String.Create());
end;

procedure DefaultSelenium.AltKeyUp();
begin
  commandProcessor.DoCommand('altKeyUp', ArrayOfUTF8String.Create());
end;

procedure DefaultSelenium.ControlKeyDown();
begin
  commandProcessor.DoCommand('controlKeyDown', ArrayOfUTF8String.Create());
end;

procedure DefaultSelenium.ControlKeyUp();
begin
  commandProcessor.DoCommand('controlKeyUp', ArrayOfUTF8String.Create());
end;

procedure DefaultSelenium.KeyDown(locator: UTF8String; keySequence: UTF8String);
begin
  commandProcessor.DoCommand('keyDown', ArrayOfUTF8String.Create(locator, keySequence));
end;

procedure DefaultSelenium.KeyUp(locator: UTF8String; keySequence: UTF8String);
begin
  commandProcessor.DoCommand('keyUp', ArrayOfUTF8String.Create(locator, keySequence));
end;

procedure DefaultSelenium.MouseOver(locator: UTF8String);
begin
  commandProcessor.DoCommand('mouseOver', ArrayOfUTF8String.Create(locator));
end;

procedure DefaultSelenium.MouseOut(locator: UTF8String);
begin
  commandProcessor.DoCommand('mouseOut', ArrayOfUTF8String.Create(locator));
end;

procedure DefaultSelenium.MouseDown(locator: UTF8String);
begin
  commandProcessor.DoCommand('mouseDown', ArrayOfUTF8String.Create(locator));
end;

procedure DefaultSelenium.MouseDownAt(locator: UTF8String; coordString: UTF8String);
begin
  commandProcessor.DoCommand('mouseDownAt', ArrayOfUTF8String.Create(locator, coordString));
end;

procedure DefaultSelenium.MouseUp(locator: UTF8String);
begin
  commandProcessor.DoCommand('mouseUp', ArrayOfUTF8String.Create(locator));
end;

procedure DefaultSelenium.MouseUpAt(locator: UTF8String; coordString: UTF8String);
begin
  commandProcessor.DoCommand('mouseUpAt', ArrayOfUTF8String.Create(locator, coordString));
end;

procedure DefaultSelenium.MouseMove(locator: UTF8String);
begin
  commandProcessor.DoCommand('mouseMove', ArrayOfUTF8String.Create(locator));
end;

procedure DefaultSelenium.MouseMoveAt(locator: UTF8String; coordString: UTF8String);
begin
  commandProcessor.DoCommand('mouseMoveAt', ArrayOfUTF8String.Create(locator, coordString));
end;

procedure DefaultSelenium.Type_(locator: UTF8String; value: UTF8String);
begin
  commandProcessor.DoCommand('type', ArrayOfUTF8String.Create(locator, value));
end;

procedure DefaultSelenium.TypeKeys(locator: UTF8String; value: UTF8String);
begin
  commandProcessor.DoCommand('typeKeys', ArrayOfUTF8String.Create(locator, value));
end;

procedure DefaultSelenium.SetSpeed(value: UTF8String);
begin
  commandProcessor.DoCommand('setSpeed', ArrayOfUTF8String.Create(value));
end;

function DefaultSelenium.GetSpeed(): UTF8String;
begin
  result := commandProcessor.GetString('getSpeed', ArrayOfUTF8String.Create());
end;

procedure DefaultSelenium.Check(locator: UTF8String);
begin
  commandProcessor.DoCommand('check', ArrayOfUTF8String.Create(locator));
end;

procedure DefaultSelenium.Uncheck(locator: UTF8String);
begin
  commandProcessor.DoCommand('uncheck', ArrayOfUTF8String.Create(locator));
end;

procedure DefaultSelenium.Select(selectLocator: UTF8String; optionLocator: UTF8String);
begin
  commandProcessor.DoCommand('select', ArrayOfUTF8String.Create(selectLocator, optionLocator));
end;

procedure DefaultSelenium.AddSelection(locator: UTF8String; optionLocator: UTF8String);
begin
  commandProcessor.DoCommand('addSelection', ArrayOfUTF8String.Create(locator, optionLocator));
end;

procedure DefaultSelenium.RemoveSelection(locator: UTF8String; optionLocator: UTF8String);
begin
  commandProcessor.DoCommand('removeSelection', ArrayOfUTF8String.Create(locator, optionLocator));
end;

procedure DefaultSelenium.RemoveAllSelections(locator: UTF8String);
begin
  commandProcessor.DoCommand('removeAllSelections', ArrayOfUTF8String.Create(locator));
end;

procedure DefaultSelenium.Submit(formLocator: UTF8String);
begin
  commandProcessor.DoCommand('submit', ArrayOfUTF8String.Create(formLocator));
end;

procedure DefaultSelenium.Open(url: UTF8String);
begin
  commandProcessor.DoCommand('open', ArrayOfUTF8String.Create(url));
end;

procedure DefaultSelenium.OpenWindow(url: UTF8String; windowID: UTF8String);
begin
  commandProcessor.DoCommand('openWindow', ArrayOfUTF8String.Create(url, windowID));
end;

procedure DefaultSelenium.SelectWindow(windowID: UTF8String);
begin
  commandProcessor.DoCommand('selectWindow', ArrayOfUTF8String.Create(windowID));
end;

procedure DefaultSelenium.SelectFrame(locator: UTF8String);
begin
  commandProcessor.DoCommand('selectFrame', ArrayOfUTF8String.Create(locator));
end;

function DefaultSelenium.GetWhetherThisFrameMatchFrameExpression(currentFrameString: UTF8String; target: UTF8String): boolean;
begin
  result := commandProcessor.GetBoolean('getWhetherThisFrameMatchFrameExpression', ArrayOfUTF8String.Create(currentFrameString, target));
end;

function DefaultSelenium.GetWhetherThisWindowMatchWindowExpression(currentWindowString: UTF8String; target: UTF8String): boolean;
begin
  result := commandProcessor.GetBoolean('getWhetherThisWindowMatchWindowExpression', ArrayOfUTF8String.Create(currentWindowString, target));
end;

procedure DefaultSelenium.WaitForPopUp(windowID: UTF8String; timeout: UTF8String);
begin
  commandProcessor.DoCommand('waitForPopUp', ArrayOfUTF8String.Create(windowID, timeout));
end;

procedure DefaultSelenium.ChooseCancelOnNextConfirmation();
begin
  commandProcessor.DoCommand('chooseCancelOnNextConfirmation', ArrayOfUTF8String.Create());
end;

procedure DefaultSelenium.ChooseOkOnNextConfirmation();
begin
  commandProcessor.DoCommand('chooseOkOnNextConfirmation', ArrayOfUTF8String.Create());
end;

procedure DefaultSelenium.AnswerOnNextPrompt(answer: UTF8String);
begin
  commandProcessor.DoCommand('answerOnNextPrompt', ArrayOfUTF8String.Create(answer));
end;

procedure DefaultSelenium.GoBack();
begin
  commandProcessor.DoCommand('goBack', ArrayOfUTF8String.Create());
end;

procedure DefaultSelenium.Refresh();
begin
  commandProcessor.DoCommand('refresh', ArrayOfUTF8String.Create());
end;

procedure DefaultSelenium.Close();
begin
  commandProcessor.DoCommand('close', ArrayOfUTF8String.Create());
end;

function DefaultSelenium.IsAlertPresent(): boolean;
begin
  result := commandProcessor.GetBoolean('isAlertPresent', ArrayOfUTF8String.Create());
end;

function DefaultSelenium.IsPromptPresent(): boolean;
begin
  result := commandProcessor.GetBoolean('isPromptPresent', ArrayOfUTF8String.Create());
end;

function DefaultSelenium.IsConfirmationPresent(): boolean;
begin
  result := commandProcessor.GetBoolean('isConfirmationPresent', ArrayOfUTF8String.Create());
end;

function DefaultSelenium.GetAlert(): UTF8String;
begin
  result := commandProcessor.GetString('getAlert', ArrayOfUTF8String.Create());
end;

function DefaultSelenium.GetConfirmation(): UTF8String;
begin
  result := commandProcessor.GetString('getConfirmation', ArrayOfUTF8String.Create());
end;

function DefaultSelenium.GetPrompt(): UTF8String;
begin
  result := commandProcessor.GetString('getPrompt', ArrayOfUTF8String.Create());
end;

function DefaultSelenium.GetLocation(): UTF8String;
begin
  result := commandProcessor.GetString('getLocation', ArrayOfUTF8String.Create());
end;

function DefaultSelenium.GetTitle(): UTF8String;
begin
  result := commandProcessor.GetString('getTitle', ArrayOfUTF8String.Create());
end;

function DefaultSelenium.GetBodyText(): UTF8String;
begin
  result := commandProcessor.GetString('getBodyText', ArrayOfUTF8String.Create());
end;

function DefaultSelenium.GetValue(locator: UTF8String): UTF8String;
begin
  result := commandProcessor.GetString('getValue', ArrayOfUTF8String.Create(locator));
end;

function DefaultSelenium.GetText(locator: UTF8String): UTF8String;
begin
  result := commandProcessor.GetString('getText', ArrayOfUTF8String.Create(locator));
end;

procedure DefaultSelenium.Highlight(locator: UTF8String);
begin
  commandProcessor.DoCommand('highlight', ArrayOfUTF8String.Create(locator));
end;

function DefaultSelenium.GetEval(script: UTF8String): UTF8String;
begin
  result := commandProcessor.GetString('getEval', ArrayOfUTF8String.Create(script));
end;

function DefaultSelenium.IsChecked(locator: UTF8String): boolean;
begin
  result := commandProcessor.GetBoolean('isChecked', ArrayOfUTF8String.Create(locator));
end;

function DefaultSelenium.GetTable(tableCellAddress: UTF8String): UTF8String;
begin
  result := commandProcessor.GetString('getTable', ArrayOfUTF8String.Create(tableCellAddress));
end;

function DefaultSelenium.GetSelectedLabels(selectLocator: UTF8String): ArrayOfUTF8String;
begin
  result := commandProcessor.GetStringArray('getSelectedLabels', ArrayOfUTF8String.Create(selectLocator));
end;

function DefaultSelenium.GetSelectedLabel(selectLocator: UTF8String): UTF8String;
begin
  result := commandProcessor.GetString('getSelectedLabel', ArrayOfUTF8String.Create(selectLocator));
end;

function DefaultSelenium.GetSelectedValues(selectLocator: UTF8String): ArrayOfUTF8String;
begin
  result := commandProcessor.GetStringArray('getSelectedValues', ArrayOfUTF8String.Create(selectLocator));
end;

function DefaultSelenium.GetSelectedValue(selectLocator: UTF8String): UTF8String;
begin
  result := commandProcessor.GetString('getSelectedValue', ArrayOfUTF8String.Create(selectLocator));
end;

function DefaultSelenium.GetSelectedIndexes(selectLocator: UTF8String): ArrayOfUTF8String;
begin
  result := commandProcessor.GetStringArray('getSelectedIndexes', ArrayOfUTF8String.Create(selectLocator));
end;

function DefaultSelenium.GetSelectedIndex(selectLocator: UTF8String): UTF8String;
begin
  result := commandProcessor.GetString('getSelectedIndex', ArrayOfUTF8String.Create(selectLocator));
end;

function DefaultSelenium.GetSelectedIds(selectLocator: UTF8String): ArrayOfUTF8String;
begin
  result := commandProcessor.GetStringArray('getSelectedIds', ArrayOfUTF8String.Create(selectLocator));
end;

function DefaultSelenium.GetSelectedId(selectLocator: UTF8String): UTF8String;
begin
  result := commandProcessor.GetString('getSelectedId', ArrayOfUTF8String.Create(selectLocator));
end;

function DefaultSelenium.IsSomethingSelected(selectLocator: UTF8String): boolean;
begin
  result := commandProcessor.GetBoolean('isSomethingSelected', ArrayOfUTF8String.Create(selectLocator));
end;

function DefaultSelenium.GetSelectOptions(selectLocator: UTF8String): ArrayOfUTF8String;
begin
  result := commandProcessor.GetStringArray('getSelectOptions', ArrayOfUTF8String.Create(selectLocator));
end;

function DefaultSelenium.GetAttribute(attributeLocator: UTF8String): UTF8String;
begin
  result := commandProcessor.GetString('getAttribute', ArrayOfUTF8String.Create(attributeLocator));
end;

function DefaultSelenium.IsTextPresent(pattern: UTF8String): boolean;
begin
  result := commandProcessor.GetBoolean('isTextPresent', ArrayOfUTF8String.Create(pattern));
end;

function DefaultSelenium.IsElementPresent(locator: UTF8String): boolean;
begin
  result := commandProcessor.GetBoolean('isElementPresent', ArrayOfUTF8String.Create(locator));
end;

function DefaultSelenium.IsVisible(locator: UTF8String): boolean;
begin
  result := commandProcessor.GetBoolean('isVisible', ArrayOfUTF8String.Create(locator));
end;

function DefaultSelenium.IsEditable(locator: UTF8String): boolean;
begin
  result := commandProcessor.GetBoolean('isEditable', ArrayOfUTF8String.Create(locator));
end;

function DefaultSelenium.GetAllButtons(): ArrayOfUTF8String;
begin
  result := commandProcessor.GetStringArray('getAllButtons', ArrayOfUTF8String.Create());
end;

function DefaultSelenium.GetAllLinks(): ArrayOfUTF8String;
begin
  result := commandProcessor.GetStringArray('getAllLinks', ArrayOfUTF8String.Create());
end;

function DefaultSelenium.GetAllFields(): ArrayOfUTF8String;
begin
  result := commandProcessor.GetStringArray('getAllFields', ArrayOfUTF8String.Create());
end;

function DefaultSelenium.GetAttributeFromAllWindows(attributeName: UTF8String): ArrayOfUTF8String;
begin
  result := commandProcessor.GetStringArray('getAttributeFromAllWindows', ArrayOfUTF8String.Create(attributeName));
end;

procedure DefaultSelenium.Dragdrop(locator: UTF8String; movementsString: UTF8String);
begin
  commandProcessor.DoCommand('dragdrop', ArrayOfUTF8String.Create(locator, movementsString));
end;

procedure DefaultSelenium.SetMouseSpeed(pixels: UTF8String);
begin
  commandProcessor.DoCommand('setMouseSpeed', ArrayOfUTF8String.Create(pixels));
end;

function DefaultSelenium.GetMouseSpeed(): double;
begin
  result := commandProcessor.GetNumber('getMouseSpeed', ArrayOfUTF8String.Create());
end;

procedure DefaultSelenium.DragAndDrop(locator: UTF8String; movementsString: UTF8String);
begin
  commandProcessor.DoCommand('dragAndDrop', ArrayOfUTF8String.Create(locator, movementsString));
end;

procedure DefaultSelenium.DragAndDropToObject(locatorOfObjectToBeDragged: UTF8String; locatorOfDragDestinationObject: UTF8String);
begin
  commandProcessor.DoCommand('dragAndDropToObject', ArrayOfUTF8String.Create(locatorOfObjectToBeDragged, locatorOfDragDestinationObject));
end;

procedure DefaultSelenium.WindowFocus();
begin
  commandProcessor.DoCommand('windowFocus', ArrayOfUTF8String.Create());
end;

procedure DefaultSelenium.WindowMaximize();
begin
  commandProcessor.DoCommand('windowMaximize', ArrayOfUTF8String.Create());
end;

function DefaultSelenium.GetAllWindowIds(): ArrayOfUTF8String;
begin
  result := commandProcessor.GetStringArray('getAllWindowIds', ArrayOfUTF8String.Create());
end;

function DefaultSelenium.GetAllWindowNames(): ArrayOfUTF8String;
begin
  result := commandProcessor.GetStringArray('getAllWindowNames', ArrayOfUTF8String.Create());
end;

function DefaultSelenium.GetAllWindowTitles(): ArrayOfUTF8String;
begin
  result := commandProcessor.GetStringArray('getAllWindowTitles', ArrayOfUTF8String.Create());
end;

function DefaultSelenium.GetHtmlSource(): UTF8String;
begin
  result := commandProcessor.GetString('getHtmlSource', ArrayOfUTF8String.Create());
end;

procedure DefaultSelenium.SetCursorPosition(locator: UTF8String; position: UTF8String);
begin
  commandProcessor.DoCommand('setCursorPosition', ArrayOfUTF8String.Create(locator, position));
end;

function DefaultSelenium.GetElementIndex(locator: UTF8String): double;
begin
  result := commandProcessor.GetNumber('getElementIndex', ArrayOfUTF8String.Create(locator));
end;

function DefaultSelenium.IsOrdered(locator1: UTF8String; locator2: UTF8String): boolean;
begin
  result := commandProcessor.GetBoolean('isOrdered', ArrayOfUTF8String.Create(locator1, locator2));
end;

function DefaultSelenium.GetElementPositionLeft(locator: UTF8String): double;
begin
  result := commandProcessor.GetNumber('getElementPositionLeft', ArrayOfUTF8String.Create(locator));
end;

function DefaultSelenium.GetElementPositionTop(locator: UTF8String): double;
begin
  result := commandProcessor.GetNumber('getElementPositionTop', ArrayOfUTF8String.Create(locator));
end;

function DefaultSelenium.GetElementWidth(locator: UTF8String): double;
begin
  result := commandProcessor.GetNumber('getElementWidth', ArrayOfUTF8String.Create(locator));
end;

function DefaultSelenium.GetElementHeight(locator: UTF8String): double;
begin
  result := commandProcessor.GetNumber('getElementHeight', ArrayOfUTF8String.Create(locator));
end;

function DefaultSelenium.GetCursorPosition(locator: UTF8String): double;
begin
  result := commandProcessor.GetNumber('getCursorPosition', ArrayOfUTF8String.Create(locator));
end;

function DefaultSelenium.GetExpression(expression: UTF8String): UTF8String;
begin
  result := commandProcessor.GetString('getExpression', ArrayOfUTF8String.Create(expression));
end;

function DefaultSelenium.GetXpathCount(xpath: UTF8String): double;
begin
  result := commandProcessor.GetNumber('getXpathCount', ArrayOfUTF8String.Create(xpath));
end;

procedure DefaultSelenium.AssignId(locator: UTF8String; identifier: UTF8String);
begin
  commandProcessor.DoCommand('assignId', ArrayOfUTF8String.Create(locator, identifier));
end;

procedure DefaultSelenium.AllowNativeXpath(allow: UTF8String);
begin
  commandProcessor.DoCommand('allowNativeXpath', ArrayOfUTF8String.Create(allow));
end;

procedure DefaultSelenium.IgnoreAttributesWithoutValue(ignore: UTF8String);
begin
  commandProcessor.DoCommand('ignoreAttributesWithoutValue', ArrayOfUTF8String.Create(ignore));
end;

procedure DefaultSelenium.WaitForCondition(script: UTF8String; timeout: UTF8String);
begin
  commandProcessor.DoCommand('waitForCondition', ArrayOfUTF8String.Create(script, timeout));
end;

procedure DefaultSelenium.SetTimeout(timeout: UTF8String);
begin
  commandProcessor.DoCommand('setTimeout', ArrayOfUTF8String.Create(timeout));
end;

procedure DefaultSelenium.WaitForPageToLoad(timeout: UTF8String);
begin
  commandProcessor.DoCommand('waitForPageToLoad', ArrayOfUTF8String.Create(timeout));
end;

procedure DefaultSelenium.WaitForFrameToLoad(frameAddress: UTF8String; timeout: UTF8String);
begin
  commandProcessor.DoCommand('waitForFrameToLoad', ArrayOfUTF8String.Create(frameAddress, timeout));
end;

function DefaultSelenium.GetCookie(): UTF8String;
begin
  result := commandProcessor.GetString('getCookie', ArrayOfUTF8String.Create());
end;

function DefaultSelenium.GetCookieByName(name: UTF8String): UTF8String;
begin
  result := commandProcessor.GetString('getCookieByName', ArrayOfUTF8String.Create(name));
end;

function DefaultSelenium.IsCookiePresent(name: UTF8String): boolean;
begin
  result := commandProcessor.GetBoolean('isCookiePresent', ArrayOfUTF8String.Create(name));
end;

procedure DefaultSelenium.CreateCookie(nameValuePair: UTF8String; optionsString: UTF8String);
begin
  commandProcessor.DoCommand('createCookie', ArrayOfUTF8String.Create(nameValuePair, optionsString));
end;

procedure DefaultSelenium.DeleteCookie(name: UTF8String; optionsString: UTF8String);
begin
  commandProcessor.DoCommand('deleteCookie', ArrayOfUTF8String.Create(name, optionsString));
end;

procedure DefaultSelenium.DeleteAllVisibleCookies();
begin
  commandProcessor.DoCommand('deleteAllVisibleCookies', ArrayOfUTF8String.Create());
end;

procedure DefaultSelenium.SetBrowserLogLevel(logLevel: UTF8String);
begin
  commandProcessor.DoCommand('setBrowserLogLevel', ArrayOfUTF8String.Create(logLevel));
end;

procedure DefaultSelenium.RunScript(script: UTF8String);
begin
  commandProcessor.DoCommand('runScript', ArrayOfUTF8String.Create(script));
end;

procedure DefaultSelenium.AddLocationStrategy(strategyName: UTF8String; functionDefinition: UTF8String);
begin
  commandProcessor.DoCommand('addLocationStrategy', ArrayOfUTF8String.Create(strategyName, functionDefinition));
end;

procedure DefaultSelenium.CaptureEntirePageScreenshot(filename: UTF8String);
begin
  commandProcessor.DoCommand('captureEntirePageScreenshot', ArrayOfUTF8String.Create(filename));
end;

procedure DefaultSelenium.SetContext(context: UTF8String);
begin
  commandProcessor.DoCommand('setContext', ArrayOfUTF8String.Create(context));
end;

procedure DefaultSelenium.AttachFile(fieldLocator: UTF8String; fileLocator: UTF8String);
begin
  commandProcessor.DoCommand('attachFile', ArrayOfUTF8String.Create(fieldLocator, fileLocator));
end;

procedure DefaultSelenium.CaptureScreenshot(filename: UTF8String);
begin
  commandProcessor.DoCommand('captureScreenshot', ArrayOfUTF8String.Create(filename));
end;

procedure DefaultSelenium.ShutDownSeleniumServer();
begin
  commandProcessor.DoCommand('shutDownSeleniumServer', ArrayOfUTF8String.Create());
end;

procedure DefaultSelenium.KeyDownNative(keycode: UTF8String);
begin
  commandProcessor.DoCommand('keyDownNative', ArrayOfUTF8String.Create(keycode));
end;

procedure DefaultSelenium.KeyUpNative(keycode: UTF8String);
begin
  commandProcessor.DoCommand('keyUpNative', ArrayOfUTF8String.Create(keycode));
end;

procedure DefaultSelenium.KeyPressNative(keycode: UTF8String);
begin
  commandProcessor.DoCommand('keyPressNative', ArrayOfUTF8String.Create(keycode));
end;

end.

