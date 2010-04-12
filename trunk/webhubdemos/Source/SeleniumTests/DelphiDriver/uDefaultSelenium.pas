unit uDefaultSelenium;

interface

uses
  uISelenium, uICommandProcessor, uHttpCommandProcessor, uCommon;

type

  DefaultSelenium = class(TInterfacedObject, ISelenium)
  protected
    commandProcessor: ICommandProcessor;
  public
    constructor Create(serverHost: string; serverPort: integer; browserString: string; browserURL: string); overload;
    constructor Create(processor: ICommandProcessor); overload;
    function Processor: ICommandProcessor;
    procedure Start();
    procedure Stop();
    procedure Click(locator: string);
    procedure ClickAndWait(locator: String);
    procedure DoubleClick(locator: string);
    procedure ContextMenu(locator: string);
    procedure ClickAt(locator: string; coordString: string);
    procedure DoubleClickAt(locator: string; coordString: string);
    procedure ContextMenuAt(locator: string; coordString: string);
    procedure FireEvent(locator: string; eventName: string);
    procedure Focus(locator: string);
    procedure KeyPress(locator: string; keySequence: string);
    procedure ShiftKeyDown();
    procedure ShiftKeyUp();
    procedure MetaKeyDown();
    procedure MetaKeyUp();
    procedure AltKeyDown();
    procedure AltKeyUp();
    procedure ControlKeyDown();
    procedure ControlKeyUp();
    procedure KeyDown(locator: string; keySequence: string);
    procedure KeyUp(locator: string; keySequence: string);
    procedure MouseOver(locator: string);
    procedure MouseOut(locator: string);
    procedure MouseDown(locator: string);
    procedure MouseDownAt(locator: string; coordString: string);
    procedure MouseUp(locator: string);
    procedure MouseUpAt(locator: string; coordString: string);
    procedure MouseMove(locator: string);
    procedure MouseMoveAt(locator: string; coordString: string);
    procedure Type_(locator: string; value: string);
    procedure TypeKeys(locator: string; value: string);
    procedure SetSpeed(value: string);
    function GetSpeed(): string;
    procedure Check(locator: string);
    procedure Uncheck(locator: string);
    procedure Select(selectLocator: string; optionLocator: string);
    procedure AddSelection(locator: string; optionLocator: string);
    procedure RemoveSelection(locator: string; optionLocator: string);
    procedure RemoveAllSelections(locator: string);
    procedure Submit(formLocator: string);
    procedure Open(url: string);
    procedure OpenWindow(url: string; windowID: string);
    procedure SelectWindow(windowID: string);
    procedure SelectFrame(locator: string);
    function GetWhetherThisFrameMatchFrameExpression(currentFrameString: string; target: string): boolean;
    function GetWhetherThisWindowMatchWindowExpression(currentWindowString: string; target: string): boolean;
    procedure WaitForPopUp(windowID: string; timeout: string);
    procedure ChooseCancelOnNextConfirmation();
    procedure ChooseOkOnNextConfirmation();
    procedure AnswerOnNextPrompt(answer: string);
    procedure GoBack();
    procedure Refresh();
    procedure Close();
    function IsAlertPresent(): boolean;
    function IsPromptPresent(): boolean;
    function IsConfirmationPresent(): boolean;
    function GetAlert(): string;
    function GetConfirmation(): string;
    function GetPrompt(): string;
    function GetLocation(): string;
    function GetTitle(): string;
    function GetBodyText(): string;
    function GetValue(locator: string): string;
    function GetText(locator: string): string;
    procedure Highlight(locator: string);
    function GetEval(script: string): string;
    function IsChecked(locator: string): boolean;
    function GetTable(tableCellAddress: string): string;
    function GetSelectedLabels(selectLocator: string): ArrayOfString;
    function GetSelectedLabel(selectLocator: string): string;
    function GetSelectedValues(selectLocator: string): ArrayOfString;
    function GetSelectedValue(selectLocator: string): string;
    function GetSelectedIndexes(selectLocator: string): ArrayOfString;
    function GetSelectedIndex(selectLocator: string): string;
    function GetSelectedIds(selectLocator: string): ArrayOfString;
    function GetSelectedId(selectLocator: string): string;
    function IsSomethingSelected(selectLocator: string): boolean;
    function GetSelectOptions(selectLocator: string): ArrayOfString;
    function GetAttribute(attributeLocator: string): string;
    function IsTextPresent(pattern: string): boolean;
    function IsElementPresent(locator: string): boolean;
    function IsVisible(locator: string): boolean;
    function IsEditable(locator: string): boolean;
    function GetAllButtons(): ArrayOfString;
    function GetAllLinks(): ArrayOfString;
    function GetAllFields(): ArrayOfString;
    function GetAttributeFromAllWindows(attributeName: string): ArrayOfString;
    procedure Dragdrop(locator: string; movementsString: string);
    procedure SetMouseSpeed(pixels: string);
    function GetMouseSpeed(): double;
    procedure DragAndDrop(locator: string; movementsString: string);
    procedure DragAndDropToObject(locatorOfObjectToBeDragged: string; locatorOfDragDestinationObject: string);
    procedure WindowFocus();
    procedure WindowMaximize();
    function GetAllWindowIds(): ArrayOfString;
    function GetAllWindowNames(): ArrayOfString;
    function GetAllWindowTitles(): ArrayOfString;
    function GetHtmlSource(): string;
    procedure SetCursorPosition(locator: string; position: string);
    function GetElementIndex(locator: string): double;
    function IsOrdered(locator1: string; locator2: string): boolean;
    function GetElementPositionLeft(locator: string): double;
    function GetElementPositionTop(locator: string): double;
    function GetElementWidth(locator: string): double;
    function GetElementHeight(locator: string): double;
    function GetCursorPosition(locator: string): double;
    function GetExpression(expression: string): string;
    function GetXpathCount(xpath: string): double;
    procedure AssignId(locator: string; identifier: string);
    procedure AllowNativeXpath(allow: string);
    procedure IgnoreAttributesWithoutValue(ignore: string);
    procedure WaitForCondition(script: string; timeout: string);
    procedure SetTimeout(timeout: string);
    procedure WaitForPageToLoad(timeout: string);
    procedure WaitForFrameToLoad(frameAddress: string; timeout: string);
    function GetCookie(): string;
    function GetCookieByName(name: string): string;
    function IsCookiePresent(name: string): boolean;
    procedure CreateCookie(nameValuePair: string; optionsString: string);
    procedure DeleteCookie(name: string; optionsString: string);
    procedure DeleteAllVisibleCookies();
    procedure SetBrowserLogLevel(logLevel: string);
    procedure RunScript(script: string);
    procedure AddLocationStrategy(strategyName: string; functionDefinition: string);
    procedure CaptureEntirePageScreenshot(filename: string);
    procedure SetContext(context: string);
    procedure AttachFile(fieldLocator: string; fileLocator: string);
    procedure CaptureScreenshot(filename: string);
    procedure ShutDownSeleniumServer();
    procedure KeyDownNative(keycode: string);
    procedure KeyUpNative(keycode: string);
    procedure KeyPressNative(keycode: string);
  end;

implementation

constructor DefaultSelenium.Create(serverHost: string; serverPort: integer; browserString: string; browserURL: string);
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

procedure DefaultSelenium.Click(locator: string);
begin
  commandProcessor.DoCommand('click', ArrayOfString.Create(locator, ''));
end;

procedure DefaultSelenium.ClickAndWait(locator: String);
begin
  Click(locator);
  WaitForPageToLoad('30000');
end;

procedure DefaultSelenium.DoubleClick(locator: string);
begin
  commandProcessor.DoCommand('doubleClick', ArrayOfString.Create(locator, ''));
end;

procedure DefaultSelenium.ContextMenu(locator: string);
begin
  commandProcessor.DoCommand('contextMenu', ArrayOfString.Create(locator));
end;

procedure DefaultSelenium.ClickAt(locator: string; coordString: string);
begin
  commandProcessor.DoCommand('clickAt', ArrayOfString.Create(locator, coordString));
end;

procedure DefaultSelenium.DoubleClickAt(locator: string; coordString: string);
begin
  commandProcessor.DoCommand('doubleClickAt', ArrayOfString.Create(locator, coordString));
end;

procedure DefaultSelenium.ContextMenuAt(locator: string; coordString: string);
begin
  commandProcessor.DoCommand('contextMenuAt', ArrayOfString.Create(locator, coordString));
end;

procedure DefaultSelenium.FireEvent(locator: string; eventName: string);
begin
  commandProcessor.DoCommand('fireEvent', ArrayOfString.Create(locator, eventName));
end;

procedure DefaultSelenium.Focus(locator: string);
begin
  commandProcessor.DoCommand('focus', ArrayOfString.Create(locator));
end;

procedure DefaultSelenium.KeyPress(locator: string; keySequence: string);
begin
  commandProcessor.DoCommand('keyPress', ArrayOfString.Create(locator, keySequence));
end;

procedure DefaultSelenium.ShiftKeyDown();
begin
  commandProcessor.DoCommand('shiftKeyDown', ArrayOfString.Create());
end;

procedure DefaultSelenium.ShiftKeyUp();
begin
  commandProcessor.DoCommand('shiftKeyUp', ArrayOfString.Create());
end;

procedure DefaultSelenium.MetaKeyDown();
begin
  commandProcessor.DoCommand('metaKeyDown', ArrayOfString.Create());
end;

procedure DefaultSelenium.MetaKeyUp();
begin
  commandProcessor.DoCommand('metaKeyUp', ArrayOfString.Create());
end;

procedure DefaultSelenium.AltKeyDown();
begin
  commandProcessor.DoCommand('altKeyDown', ArrayOfString.Create());
end;

procedure DefaultSelenium.AltKeyUp();
begin
  commandProcessor.DoCommand('altKeyUp', ArrayOfString.Create());
end;

procedure DefaultSelenium.ControlKeyDown();
begin
  commandProcessor.DoCommand('controlKeyDown', ArrayOfString.Create());
end;

procedure DefaultSelenium.ControlKeyUp();
begin
  commandProcessor.DoCommand('controlKeyUp', ArrayOfString.Create());
end;

procedure DefaultSelenium.KeyDown(locator: string; keySequence: string);
begin
  commandProcessor.DoCommand('keyDown', ArrayOfString.Create(locator, keySequence));
end;

procedure DefaultSelenium.KeyUp(locator: string; keySequence: string);
begin
  commandProcessor.DoCommand('keyUp', ArrayOfString.Create(locator, keySequence));
end;

procedure DefaultSelenium.MouseOver(locator: string);
begin
  commandProcessor.DoCommand('mouseOver', ArrayOfString.Create(locator));
end;

procedure DefaultSelenium.MouseOut(locator: string);
begin
  commandProcessor.DoCommand('mouseOut', ArrayOfString.Create(locator));
end;

procedure DefaultSelenium.MouseDown(locator: string);
begin
  commandProcessor.DoCommand('mouseDown', ArrayOfString.Create(locator));
end;

procedure DefaultSelenium.MouseDownAt(locator: string; coordString: string);
begin
  commandProcessor.DoCommand('mouseDownAt', ArrayOfString.Create(locator, coordString));
end;

procedure DefaultSelenium.MouseUp(locator: string);
begin
  commandProcessor.DoCommand('mouseUp', ArrayOfString.Create(locator));
end;

procedure DefaultSelenium.MouseUpAt(locator: string; coordString: string);
begin
  commandProcessor.DoCommand('mouseUpAt', ArrayOfString.Create(locator, coordString));
end;

procedure DefaultSelenium.MouseMove(locator: string);
begin
  commandProcessor.DoCommand('mouseMove', ArrayOfString.Create(locator));
end;

procedure DefaultSelenium.MouseMoveAt(locator: string; coordString: string);
begin
  commandProcessor.DoCommand('mouseMoveAt', ArrayOfString.Create(locator, coordString));
end;

procedure DefaultSelenium.Type_(locator: string; value: string);
begin
  commandProcessor.DoCommand('type', ArrayOfString.Create(locator, value));
end;

procedure DefaultSelenium.TypeKeys(locator: string; value: string);
begin
  commandProcessor.DoCommand('typeKeys', ArrayOfString.Create(locator, value));
end;

procedure DefaultSelenium.SetSpeed(value: string);
begin
  commandProcessor.DoCommand('setSpeed', ArrayOfString.Create(value));
end;

function DefaultSelenium.GetSpeed(): string;
begin
  result := commandProcessor.GetString('getSpeed', ArrayOfString.Create());
end;

procedure DefaultSelenium.Check(locator: string);
begin
  commandProcessor.DoCommand('check', ArrayOfString.Create(locator));
end;

procedure DefaultSelenium.Uncheck(locator: string);
begin
  commandProcessor.DoCommand('uncheck', ArrayOfString.Create(locator));
end;

procedure DefaultSelenium.Select(selectLocator: string; optionLocator: string);
begin
  commandProcessor.DoCommand('select', ArrayOfString.Create(selectLocator, optionLocator));
end;

procedure DefaultSelenium.AddSelection(locator: string; optionLocator: string);
begin
  commandProcessor.DoCommand('addSelection', ArrayOfString.Create(locator, optionLocator));
end;

procedure DefaultSelenium.RemoveSelection(locator: string; optionLocator: string);
begin
  commandProcessor.DoCommand('removeSelection', ArrayOfString.Create(locator, optionLocator));
end;

procedure DefaultSelenium.RemoveAllSelections(locator: string);
begin
  commandProcessor.DoCommand('removeAllSelections', ArrayOfString.Create(locator));
end;

procedure DefaultSelenium.Submit(formLocator: string);
begin
  commandProcessor.DoCommand('submit', ArrayOfString.Create(formLocator));
end;

procedure DefaultSelenium.Open(url: string);
begin
  commandProcessor.DoCommand('open', ArrayOfString.Create(url));
end;

procedure DefaultSelenium.OpenWindow(url: string; windowID: string);
begin
  commandProcessor.DoCommand('openWindow', ArrayOfString.Create(url, windowID));
end;

procedure DefaultSelenium.SelectWindow(windowID: string);
begin
  commandProcessor.DoCommand('selectWindow', ArrayOfString.Create(windowID));
end;

procedure DefaultSelenium.SelectFrame(locator: string);
begin
  commandProcessor.DoCommand('selectFrame', ArrayOfString.Create(locator));
end;

function DefaultSelenium.GetWhetherThisFrameMatchFrameExpression(currentFrameString: string; target: string): boolean;
begin
  result := commandProcessor.GetBoolean('getWhetherThisFrameMatchFrameExpression', ArrayOfString.Create(currentFrameString, target));
end;

function DefaultSelenium.GetWhetherThisWindowMatchWindowExpression(currentWindowString: string; target: string): boolean;
begin
  result := commandProcessor.GetBoolean('getWhetherThisWindowMatchWindowExpression', ArrayOfString.Create(currentWindowString, target));
end;

procedure DefaultSelenium.WaitForPopUp(windowID: string; timeout: string);
begin
  commandProcessor.DoCommand('waitForPopUp', ArrayOfString.Create(windowID, timeout));
end;

procedure DefaultSelenium.ChooseCancelOnNextConfirmation();
begin
  commandProcessor.DoCommand('chooseCancelOnNextConfirmation', ArrayOfString.Create());
end;

procedure DefaultSelenium.ChooseOkOnNextConfirmation();
begin
  commandProcessor.DoCommand('chooseOkOnNextConfirmation', ArrayOfString.Create());
end;

procedure DefaultSelenium.AnswerOnNextPrompt(answer: string);
begin
  commandProcessor.DoCommand('answerOnNextPrompt', ArrayOfString.Create(answer));
end;

procedure DefaultSelenium.GoBack();
begin
  commandProcessor.DoCommand('goBack', ArrayOfString.Create());
end;

procedure DefaultSelenium.Refresh();
begin
  commandProcessor.DoCommand('refresh', ArrayOfString.Create());
end;

procedure DefaultSelenium.Close();
begin
  commandProcessor.DoCommand('close', ArrayOfString.Create());
end;

function DefaultSelenium.IsAlertPresent(): boolean;
begin
  result := commandProcessor.GetBoolean('isAlertPresent', ArrayOfString.Create());
end;

function DefaultSelenium.IsPromptPresent(): boolean;
begin
  result := commandProcessor.GetBoolean('isPromptPresent', ArrayOfString.Create());
end;

function DefaultSelenium.IsConfirmationPresent(): boolean;
begin
  result := commandProcessor.GetBoolean('isConfirmationPresent', ArrayOfString.Create());
end;

function DefaultSelenium.GetAlert(): string;
begin
  result := commandProcessor.GetString('getAlert', ArrayOfString.Create());
end;

function DefaultSelenium.GetConfirmation(): string;
begin
  result := commandProcessor.GetString('getConfirmation', ArrayOfString.Create());
end;

function DefaultSelenium.GetPrompt(): string;
begin
  result := commandProcessor.GetString('getPrompt', ArrayOfString.Create());
end;

function DefaultSelenium.GetLocation(): string;
begin
  result := commandProcessor.GetString('getLocation', ArrayOfString.Create());
end;

function DefaultSelenium.GetTitle(): string;
begin
  result := commandProcessor.GetString('getTitle', ArrayOfString.Create());
end;

function DefaultSelenium.GetBodyText(): string;
begin
  result := commandProcessor.GetString('getBodyText', ArrayOfString.Create());
end;

function DefaultSelenium.GetValue(locator: string): string;
begin
  result := commandProcessor.GetString('getValue', ArrayOfString.Create(locator));
end;

function DefaultSelenium.GetText(locator: string): string;
begin
  result := commandProcessor.GetString('getText', ArrayOfString.Create(locator));
end;

procedure DefaultSelenium.Highlight(locator: string);
begin
  commandProcessor.DoCommand('highlight', ArrayOfString.Create(locator));
end;

function DefaultSelenium.GetEval(script: string): string;
begin
  result := commandProcessor.GetString('getEval', ArrayOfString.Create(script));
end;

function DefaultSelenium.IsChecked(locator: string): boolean;
begin
  result := commandProcessor.GetBoolean('isChecked', ArrayOfString.Create(locator));
end;

function DefaultSelenium.GetTable(tableCellAddress: string): string;
begin
  result := commandProcessor.GetString('getTable', ArrayOfString.Create(tableCellAddress));
end;

function DefaultSelenium.GetSelectedLabels(selectLocator: string): ArrayOfString;
begin
  result := commandProcessor.GetStringArray('getSelectedLabels', ArrayOfString.Create(selectLocator));
end;

function DefaultSelenium.GetSelectedLabel(selectLocator: string): string;
begin
  result := commandProcessor.GetString('getSelectedLabel', ArrayOfString.Create(selectLocator));
end;

function DefaultSelenium.GetSelectedValues(selectLocator: string): ArrayOfString;
begin
  result := commandProcessor.GetStringArray('getSelectedValues', ArrayOfString.Create(selectLocator));
end;

function DefaultSelenium.GetSelectedValue(selectLocator: string): string;
begin
  result := commandProcessor.GetString('getSelectedValue', ArrayOfString.Create(selectLocator));
end;

function DefaultSelenium.GetSelectedIndexes(selectLocator: string): ArrayOfString;
begin
  result := commandProcessor.GetStringArray('getSelectedIndexes', ArrayOfString.Create(selectLocator));
end;

function DefaultSelenium.GetSelectedIndex(selectLocator: string): string;
begin
  result := commandProcessor.GetString('getSelectedIndex', ArrayOfString.Create(selectLocator));
end;

function DefaultSelenium.GetSelectedIds(selectLocator: string): ArrayOfString;
begin
  result := commandProcessor.GetStringArray('getSelectedIds', ArrayOfString.Create(selectLocator));
end;

function DefaultSelenium.GetSelectedId(selectLocator: string): string;
begin
  result := commandProcessor.GetString('getSelectedId', ArrayOfString.Create(selectLocator));
end;

function DefaultSelenium.IsSomethingSelected(selectLocator: string): boolean;
begin
  result := commandProcessor.GetBoolean('isSomethingSelected', ArrayOfString.Create(selectLocator));
end;

function DefaultSelenium.GetSelectOptions(selectLocator: string): ArrayOfString;
begin
  result := commandProcessor.GetStringArray('getSelectOptions', ArrayOfString.Create(selectLocator));
end;

function DefaultSelenium.GetAttribute(attributeLocator: string): string;
begin
  result := commandProcessor.GetString('getAttribute', ArrayOfString.Create(attributeLocator));
end;

function DefaultSelenium.IsTextPresent(pattern: string): boolean;
begin
  result := commandProcessor.GetBoolean('isTextPresent', ArrayOfString.Create(pattern));
end;

function DefaultSelenium.IsElementPresent(locator: string): boolean;
begin
  result := commandProcessor.GetBoolean('isElementPresent', ArrayOfString.Create(locator));
end;

function DefaultSelenium.IsVisible(locator: string): boolean;
begin
  result := commandProcessor.GetBoolean('isVisible', ArrayOfString.Create(locator));
end;

function DefaultSelenium.IsEditable(locator: string): boolean;
begin
  result := commandProcessor.GetBoolean('isEditable', ArrayOfString.Create(locator));
end;

function DefaultSelenium.GetAllButtons(): ArrayOfString;
begin
  result := commandProcessor.GetStringArray('getAllButtons', ArrayOfString.Create());
end;

function DefaultSelenium.GetAllLinks(): ArrayOfString;
begin
  result := commandProcessor.GetStringArray('getAllLinks', ArrayOfString.Create());
end;

function DefaultSelenium.GetAllFields(): ArrayOfString;
begin
  result := commandProcessor.GetStringArray('getAllFields', ArrayOfString.Create());
end;

function DefaultSelenium.GetAttributeFromAllWindows(attributeName: string): ArrayOfString;
begin
  result := commandProcessor.GetStringArray('getAttributeFromAllWindows', ArrayOfString.Create(attributeName));
end;

procedure DefaultSelenium.Dragdrop(locator: string; movementsString: string);
begin
  commandProcessor.DoCommand('dragdrop', ArrayOfString.Create(locator, movementsString));
end;

procedure DefaultSelenium.SetMouseSpeed(pixels: string);
begin
  commandProcessor.DoCommand('setMouseSpeed', ArrayOfString.Create(pixels));
end;

function DefaultSelenium.GetMouseSpeed(): double;
begin
  result := commandProcessor.GetNumber('getMouseSpeed', ArrayOfString.Create());
end;

procedure DefaultSelenium.DragAndDrop(locator: string; movementsString: string);
begin
  commandProcessor.DoCommand('dragAndDrop', ArrayOfString.Create(locator, movementsString));
end;

procedure DefaultSelenium.DragAndDropToObject(locatorOfObjectToBeDragged: string; locatorOfDragDestinationObject: string);
begin
  commandProcessor.DoCommand('dragAndDropToObject', ArrayOfString.Create(locatorOfObjectToBeDragged, locatorOfDragDestinationObject));
end;

procedure DefaultSelenium.WindowFocus();
begin
  commandProcessor.DoCommand('windowFocus', ArrayOfString.Create());
end;

procedure DefaultSelenium.WindowMaximize();
begin
  commandProcessor.DoCommand('windowMaximize', ArrayOfString.Create());
end;

function DefaultSelenium.GetAllWindowIds(): ArrayOfString;
begin
  result := commandProcessor.GetStringArray('getAllWindowIds', ArrayOfString.Create());
end;

function DefaultSelenium.GetAllWindowNames(): ArrayOfString;
begin
  result := commandProcessor.GetStringArray('getAllWindowNames', ArrayOfString.Create());
end;

function DefaultSelenium.GetAllWindowTitles(): ArrayOfString;
begin
  result := commandProcessor.GetStringArray('getAllWindowTitles', ArrayOfString.Create());
end;

function DefaultSelenium.GetHtmlSource(): string;
begin
  result := commandProcessor.GetString('getHtmlSource', ArrayOfString.Create());
end;

procedure DefaultSelenium.SetCursorPosition(locator: string; position: string);
begin
  commandProcessor.DoCommand('setCursorPosition', ArrayOfString.Create(locator, position));
end;

function DefaultSelenium.GetElementIndex(locator: string): double;
begin
  result := commandProcessor.GetNumber('getElementIndex', ArrayOfString.Create(locator));
end;

function DefaultSelenium.IsOrdered(locator1: string; locator2: string): boolean;
begin
  result := commandProcessor.GetBoolean('isOrdered', ArrayOfString.Create(locator1, locator2));
end;

function DefaultSelenium.GetElementPositionLeft(locator: string): double;
begin
  result := commandProcessor.GetNumber('getElementPositionLeft', ArrayOfString.Create(locator));
end;

function DefaultSelenium.GetElementPositionTop(locator: string): double;
begin
  result := commandProcessor.GetNumber('getElementPositionTop', ArrayOfString.Create(locator));
end;

function DefaultSelenium.GetElementWidth(locator: string): double;
begin
  result := commandProcessor.GetNumber('getElementWidth', ArrayOfString.Create(locator));
end;

function DefaultSelenium.GetElementHeight(locator: string): double;
begin
  result := commandProcessor.GetNumber('getElementHeight', ArrayOfString.Create(locator));
end;

function DefaultSelenium.GetCursorPosition(locator: string): double;
begin
  result := commandProcessor.GetNumber('getCursorPosition', ArrayOfString.Create(locator));
end;

function DefaultSelenium.GetExpression(expression: string): string;
begin
  result := commandProcessor.GetString('getExpression', ArrayOfString.Create(expression));
end;

function DefaultSelenium.GetXpathCount(xpath: string): double;
begin
  result := commandProcessor.GetNumber('getXpathCount', ArrayOfString.Create(xpath));
end;

procedure DefaultSelenium.AssignId(locator: string; identifier: string);
begin
  commandProcessor.DoCommand('assignId', ArrayOfString.Create(locator, identifier));
end;

procedure DefaultSelenium.AllowNativeXpath(allow: string);
begin
  commandProcessor.DoCommand('allowNativeXpath', ArrayOfString.Create(allow));
end;

procedure DefaultSelenium.IgnoreAttributesWithoutValue(ignore: string);
begin
  commandProcessor.DoCommand('ignoreAttributesWithoutValue', ArrayOfString.Create(ignore));
end;

procedure DefaultSelenium.WaitForCondition(script: string; timeout: string);
begin
  commandProcessor.DoCommand('waitForCondition', ArrayOfString.Create(script, timeout));
end;

procedure DefaultSelenium.SetTimeout(timeout: string);
begin
  commandProcessor.DoCommand('setTimeout', ArrayOfString.Create(timeout));
end;

procedure DefaultSelenium.WaitForPageToLoad(timeout: string);
begin
  commandProcessor.DoCommand('waitForPageToLoad', ArrayOfString.Create(timeout));
end;

procedure DefaultSelenium.WaitForFrameToLoad(frameAddress: string; timeout: string);
begin
  commandProcessor.DoCommand('waitForFrameToLoad', ArrayOfString.Create(frameAddress, timeout));
end;

function DefaultSelenium.GetCookie(): string;
begin
  result := commandProcessor.GetString('getCookie', ArrayOfString.Create());
end;

function DefaultSelenium.GetCookieByName(name: string): string;
begin
  result := commandProcessor.GetString('getCookieByName', ArrayOfString.Create(name));
end;

function DefaultSelenium.IsCookiePresent(name: string): boolean;
begin
  result := commandProcessor.GetBoolean('isCookiePresent', ArrayOfString.Create(name));
end;

procedure DefaultSelenium.CreateCookie(nameValuePair: string; optionsString: string);
begin
  commandProcessor.DoCommand('createCookie', ArrayOfString.Create(nameValuePair, optionsString));
end;

procedure DefaultSelenium.DeleteCookie(name: string; optionsString: string);
begin
  commandProcessor.DoCommand('deleteCookie', ArrayOfString.Create(name, optionsString));
end;

procedure DefaultSelenium.DeleteAllVisibleCookies();
begin
  commandProcessor.DoCommand('deleteAllVisibleCookies', ArrayOfString.Create());
end;

procedure DefaultSelenium.SetBrowserLogLevel(logLevel: string);
begin
  commandProcessor.DoCommand('setBrowserLogLevel', ArrayOfString.Create(logLevel));
end;

procedure DefaultSelenium.RunScript(script: string);
begin
  commandProcessor.DoCommand('runScript', ArrayOfString.Create(script));
end;

procedure DefaultSelenium.AddLocationStrategy(strategyName: string; functionDefinition: string);
begin
  commandProcessor.DoCommand('addLocationStrategy', ArrayOfString.Create(strategyName, functionDefinition));
end;

procedure DefaultSelenium.CaptureEntirePageScreenshot(filename: string);
begin
  commandProcessor.DoCommand('captureEntirePageScreenshot', ArrayOfString.Create(filename));
end;

procedure DefaultSelenium.SetContext(context: string);
begin
  commandProcessor.DoCommand('setContext', ArrayOfString.Create(context));
end;

procedure DefaultSelenium.AttachFile(fieldLocator: string; fileLocator: string);
begin
  commandProcessor.DoCommand('attachFile', ArrayOfString.Create(fieldLocator, fileLocator));
end;

procedure DefaultSelenium.CaptureScreenshot(filename: string);
begin
  commandProcessor.DoCommand('captureScreenshot', ArrayOfString.Create(filename));
end;

procedure DefaultSelenium.ShutDownSeleniumServer();
begin
  commandProcessor.DoCommand('shutDownSeleniumServer', ArrayOfString.Create());
end;

procedure DefaultSelenium.KeyDownNative(keycode: string);
begin
  commandProcessor.DoCommand('keyDownNative', ArrayOfString.Create(keycode));
end;

procedure DefaultSelenium.KeyUpNative(keycode: string);
begin
  commandProcessor.DoCommand('keyUpNative', ArrayOfString.Create(keycode));
end;

procedure DefaultSelenium.KeyPressNative(keycode: string);
begin
  commandProcessor.DoCommand('keyPressNative', ArrayOfString.Create(keycode));
end;

end.

