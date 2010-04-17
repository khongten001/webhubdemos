  Log('---Test star Open home page......');
  selenium_Open('/showcase::1204');
  selenium_ClickAndWait('//div[@id=''menuThisWebHubDemo'']/ul/li[2]/a');

  Log('---Star:1.Easier HTML......');
  selenium_ClickAndWait('link=Easier HTML');

  Log('---1.1......');
  selenium_ClickAndWait('//img[@alt=''Down'']');

  Log('---1.1.1......');
  selenium_ClickAndWait('//img[@alt=''Down'']');

  Log('---1.1.2......');
  selenium_ClickAndWait('//img[@alt=''Next'']');

  Log('---1.1.3......');
  selenium_ClickAndWait('//img[@alt=''Next'']');

  Log('---1.1.4......');
  selenium_ClickAndWait('//img[@alt=''Next'']');

  Log('---1.1.5......');
  selenium_ClickAndWait('//img[@alt=''Next'']');
  selenium_Type('litSurferName', 'Emily');
  selenium_ClickAndWait('submit');

  Log('---Back:1.1......');
  selenium_ClickAndWait('//img[@alt=''Next'']');

  Log('---1.2......');
  selenium_ClickAndWait('//img[@alt=''Next'']');

  Log('---1.2.1......');
  selenium_ClickAndWait('//img[@alt=''Down'']');

  Log('---1.2.2......');
  selenium_ClickAndWait('//img[@alt=''Next'']');

  Log('---1.2.3......');
  selenium_ClickAndWait('//img[@alt=''Next'']');

  Log('---1.2.4......');
  selenium_ClickAndWait('//img[@alt=''Next'']');
  selenium_Type('litSurferName+5', 'Emily');
  selenium_ClickAndWait('submit');

  Log('---Back:1.2......');
  selenium_ClickAndWait('//img[@alt=''Up'']');

  Log('---1.3......');
  selenium_ClickAndWait('//img[@alt=''Next'']');

  Log('---1.3.1......');
  selenium_ClickAndWait('//img[@alt=''Down'']');

  Log('---1.3.2......');
  selenium_ClickAndWait('link=JUMP to the next page');

  Log('---1.3.3......');
  selenium_ClickAndWait('link=GO to the next page');

  Log('---1.3.4......');
  selenium_ClickAndWait('link=Don''t HIDE the link to the next page');
  selenium_ClickAndWait('link=TwhAppBase.Properties');
  selenium_GoBack();
  selenium_WaitForPageToLoad('30000');

  Log('---1.3.5......');
  selenium_ClickAndWait('//img[@alt=''Next'']');
  selenium_Type('litSurferName', 'Emily');
  selenium_ClickAndWait('submit');

  Log('---1.3.6......');
  selenium_ClickAndWait('//img[@alt=''Next'']');
  selenium_ClickAndWait('link=GO to Easier HTML Main Page');
  selenium_GoBack();
  selenium_WaitForPageToLoad('30000');

  selenium_ClickAndWait('link=Random GO to Easier HTML Main Page');
  selenium_GoBack();
  selenium_WaitForPageToLoad('30000');

  Log('---1.3.7......');
  selenium_ClickAndWait('//img[@alt=''Next'']');
  selenium_ClickAndWait('link=A JUMP to this page');

  Log('---Back:1.3......');
  selenium_ClickAndWait('//img[@alt=''Next'']');

  Log('---1.4......');
  selenium_ClickAndWait('//img[@alt=''Next'']');

  Log('---1.4.1......');
  selenium_ClickAndWait('//img[@alt=''Down'']');
  selenium_Click('v1');
  selenium_ClickAndWait('submit');
  selenium_GoBack();
  selenium_WaitForPageToLoad('30000');

  Log('---1.4.2......');
  selenium_ClickAndWait('//img[@alt=''Next'']');
  selenium_ClickAndWait('submit');
  selenium_GoBack();
  selenium_WaitForPageToLoad('30000');

  Log('---1.4.3......');
  selenium_ClickAndWait('//img[@alt=''Next'']');
  selenium_ClickAndWait('submit');
  selenium_GoBack();
  selenium_WaitForPageToLoad('30000');

  Log('---1.4.4......');
  selenium_ClickAndWait('//img[@alt=''Next'']');

  Log('---1.4.5......');
  selenium_ClickAndWait('//img[@alt=''Next'']');

  Log('---1.4.6......');
  selenium_ClickAndWait('//img[@alt=''Next'']');

  Log('---1.4.7......');
  selenium_ClickAndWait('//img[@alt=''Next'']');

  Log('---1.4.8......');
  selenium_ClickAndWait('//img[@alt=''Next'']');

  Log('---1.4.9......');
  selenium_ClickAndWait('//img[@alt=''Next'']');

  Log('---1.4.9.1......');
  selenium_ClickAndWait('//img[@alt=''Down'']');

  Log('---1.4.9.2......');
  selenium_ClickAndWait('//img[@alt=''Next'']');

  Log('---1.4.9.3......');
  selenium_ClickAndWait('//img[@alt=''Next'']');

  Log('---1.4.9.4......');
  selenium_ClickAndWait('//img[@alt=''Next'']');

  Log('---1.4.9.5......');
  selenium_ClickAndWait('//img[@alt=''Next'']');

  Log('---1.4.9.6......');
  selenium_ClickAndWait('//img[@alt=''Next'']');

  Log('---1.4.9.7......');
  selenium_ClickAndWait('//img[@alt=''Next'']');

  Log('---1.4.9.8......');
  selenium_ClickAndWait('//img[@alt=''Next'']');

  Log('---Back:1.4.9......');
  selenium_ClickAndWait('//img[@alt=''Next'']');

  Log('---1.4.10 ......');
  selenium_ClickAndWait('//img[@alt=''Next'']');

  Log('---Back:1.Easier HTML......');
  selenium_ClickAndWait('link=Easier HTML');

  Log('---1.5......');
  selenium_ClickAndWait('link=Frames');

  Log('---1.5.1......');
  selenium_ClickAndWait('//img[@alt=''Down'']');
  selenium_GoBack();
  selenium_WaitForPageToLoad('30000');

  Log('---Bak:Homepage......');
  selenium_ClickAndWait('link=SHOWCASE');

  Log('---Star:2.Forms with Built-in Save-State......');
  selenium_ClickAndWait('link=Forms with Built-in Save-State');

  Log('---2.1......');
  selenium_ClickAndWait('//img[@alt=''Down'']');

  Log('---2.1.1......');
  selenium_ClickAndWait('//img[@alt=''Down'']');
  selenium_ClickAndWait('submit');
  selenium_Select('litIconFile', 'label=Fair');
  selenium_ClickAndWait('submit');

  selenium_Select('litIconFile', 'label=Sold');
  selenium_ClickAndWait('submit');

  Log('---2.1.2......');
  selenium_ClickAndWait('//div[@id=''whRightNavButtons'']/a/img');
  selenium_AddSelection('MYSELECT', 'label=This is option #1');
  selenium_ClickAndWait('submit');

  Log('---2.1.3......');
  selenium_ClickAndWait('//img[@alt=''Next'']');
  selenium_Click('//input[@name=''color'' and @value=''Green'']');
  selenium_ClickAndWait('submit');
  selenium_Click('//input[@name=''color'' and @value=''Blue'']');
  selenium_ClickAndWait('submit');

  selenium_Click('color');
  selenium_ClickAndWait('submit');

  selenium_Click('//input[@name=''Language'' and @value=''German'']');
  selenium_ClickAndWait('//div[@id=''Layer2'']/form[2]/input[5]');

  selenium_Click('//input[@name=''Language'' and @value=''French'']');
  selenium_ClickAndWait('//div[@id=''Layer2'']/form[2]/input[5]');

  selenium_Click('//input[@name=''Language'' and @value=''Spanish'']');
  selenium_ClickAndWait('//div[@id=''Layer2'']/form[2]/input[5]');

  selenium_Click('Language');
  selenium_ClickAndWait('//div[@id=''Layer2'']/form[2]/input[5]');

  Log('---2.1.4......');
  selenium_ClickAndWait('//div[@id=''whRightNavButtons'']/a/img');

  selenium_Type('Retail', '1');
  selenium_Type('wholesale', '2');
  selenium_Type('cost', '3');
  selenium_Type('loss', '4');
  selenium_Click('radioA');
  selenium_ClickAndWait('submit');

  selenium_Click('//input[@name=''radioA'' and @value=''Wholesale'']');
  selenium_ClickAndWait('submit');

  selenium_Click('//input[@name=''radioA'' and @value=''Cost'']');
  selenium_ClickAndWait('submit');

  selenium_Click('//input[@name=''radioA'' and @value=''Loss'']');
  selenium_ClickAndWait('submit');

  Log('---2.1.5......');
  selenium_ClickAndWait('//img[@alt=''Next'']');

  selenium_Click('MYCHECKBOX');
  selenium_ClickAndWait('submit');

  selenium_Click('YOURCHECKBOX');
  selenium_ClickAndWait('submit');

  Log('---2.1.6......');
  selenium_ClickAndWait('//img[@alt=''Next'']');

  selenium_Type('txtDescription', 'testtest');
  selenium_ClickAndWait('submit');

  selenium_Type('txtDescription', 'apples=red');
  selenium_ClickAndWait('submit');

  selenium_Type('txtDescription', '(~litSurfername~)');
  selenium_ClickAndWait('submit');

  Log('---2.1.7......');
  selenium_ClickAndWait('//img[@alt=''Next'']');
  selenium_ClickAndWait('submit');
  selenium_ClickAndWait('//input[@name=''submit'' and @value=''HairStyle,Punk'']');
  selenium_ClickAndWait('//input[@name=''submit'' and @value=''HairStyle,Matted'']');
  selenium_ClickAndWait('//input[@name=''submit'' and @value=''HairStyle,Toupee'']');
  selenium_ClickAndWait('//input[@name=''submit'' and @value=''HairStyle,Curly'']');

  Log('---Back:2.1......');
  selenium_ClickAndWait('//img[@alt=''Next'']');

  Log('---2.2......');
  selenium_ClickAndWait('//img[@alt=''Next'']');

  Log('---2.2.1......');
  selenium_ClickAndWait('//img[@alt=''Down'']');
  selenium_Type('litSurferName', 'ran');
  selenium_Type('litOrganization', 'abc');
  selenium_ClickAndWait('submit');

  Log('---2.2.2......');
  selenium_ClickAndWait('//img[@alt=''Next'']');
  selenium_ClickAndWait('link=Set Your Preferences');
  selenium_GoBack();
  selenium_WaitForPageToLoad('30000');

  Log('---Back:2.2......');
  selenium_ClickAndWait('//img[@alt=''Next'']');

  Log('---Back:Homepage......');
  selenium_ClickAndWait('link=SHOWCASE');

  Log('---Star:3.WebMaster Topics......');
  selenium_ClickAndWait('link=WebMaster Topics');

  Log('---3.1......');
  selenium_ClickAndWait('//img[@alt=''Down'']');

  Log('---3.1.1......');
  selenium_ClickAndWait('//img[@alt=''Down'']');
  selenium_ClickAndWait('link=Try this link');
  selenium_GoBack();
  selenium_WaitForPageToLoad('30000');

  Log('---3.1.2......');
  selenium_ClickAndWait('//div[@id=''whRightNavButtons'']/a/img');
  selenium_ClickAndWait('link=Try this link');
  selenium_GoBack();
  selenium_WaitForPageToLoad('30000');

  selenium_ClickAndWait('link=InvalidPage');
  selenium_GoBack();
  selenium_WaitForPageToLoad('30000');

  Log('---3.1.3......');
  selenium_ClickAndWait('//div[@id=''whRightNavButtons'']/a/img');
  selenium_ClickAndWait('//img[@alt=''Next'']');

  Log('---3.2......');
  selenium_ClickAndWait('y//img[@alt=''Next'']');
  selenium_ClickAndWait('link=SPEED');
  selenium_GoBack();
  selenium_WaitForPageToLoad('30000');

  Log('---3.3......');
  selenium_ClickAndWait('//img[@alt=''Next'']');

  Log('---3.3.1......');
  selenium_ClickAndWait('//img[@alt=''Down'']');
  selenium_GoBack();
  selenium_WaitForPageToLoad('30000');

  Log('---3.3.2......');
  selenium_ClickAndWait('link=The Status Page');
  selenium_GoBack();
  selenium_WaitForPageToLoad('30000');

  Log('---3.3.3......');
  selenium_ClickAndWait('link=The Speed Page');
  selenium_GoBack();
  selenium_WaitForPageToLoad('30000');

  Log('---3.3.4......');
  selenium_ClickAndWait('link=The Echo Page');
  selenium_GoBack();
  selenium_WaitForPageToLoad('30000');

  Log('---3.3.5......');
  selenium_ClickAndWait('link=The Personal Preferences Page');
  selenium_GoBack();
  selenium_WaitForPageToLoad('30000');

  Log('---3.3.6......');
  selenium_ClickAndWait('link=The Errors Page');
  selenium_GoBack();
  selenium_WaitForPageToLoad('30000');

  Log('---3.4......');
  selenium_ClickAndWait('//img[@alt=''Next'']');

  Log('---3.4.1 Error:time out......');
  selenium_ClickAndWait('//img[@alt=''Down'']');

  Log('---Back:3.4......');
  selenium_ClickAndWait('link=StyleSheets');

  Log('---3.5......');
  selenium_ClickAndWait('//img[@alt=''Next'']');

  Log('---Back:Homepage......');
  selenium_ClickAndWait('link=SHOWCASE');

  Log('---Star:4.E-Mail......');
  selenium_ClickAndWait('link=E-Mail');

  Log('---4.1......');
  selenium_ClickAndWait('//img[@alt=''Down'']');
  selenium_Type('//input[@name=''Msg To'']', 'ccdzhang@hotmail.com');
  selenium_Type('MsgFrom', 'ran@hotmail.com');
  selenium_Type('SurferName', 'ranzhang');
  selenium_Type('TxtVar.txtMessage', 'Most companies want to get feedback from people surfing their site. WebHub provides explicit support for structured feedback pages.');
  selenium_ClickAndWait('submit');
  selenium_GoBack();
  selenium_WaitForPageToLoad('30000');

  Log('---4.2......');
  selenium_ClickAndWait('//img[@alt=''Next'']');

  Log('---Back:Homepage......');
  selenium_ClickAndWait('link=SHOWCASE');

  Log('---Star:5.Surfer Tracking......');
  selenium_ClickAndWait('link=Surfer Tracking');

  Log('---5.1......');
  selenium_ClickAndWait('//img[@alt=''Down'']');

  Log('---5.1.1......');
  selenium_ClickAndWait('//img[@alt=''Down'']');
  selenium_ClickAndWait('link=Click this link to see the cookies displayed.');
  selenium_ClickAndWait('//img[@alt=''Next'']');
  selenium_ClickAndWait('link=Reload this page to confirm the cookies are deleted');

  Log('---5.1.3......');
  selenium_ClickAndWait('//img[@alt=''Next'']');

  Log('---5.1.4......');
  selenium_ClickAndWait('//img[@alt=''Next'']');
  selenium_ClickAndWait('link=bounce test A');

  Log('---5.1.5......');
  selenium_ClickAndWait('//div[@id=''whRightNavButtons'']/a/img');

  Log('---5.1.6......');
  selenium_ClickAndWait('//div[@id=''whRightNavButtons'']/a/img');

  Log('---Back:5.1......');
  selenium_ClickAndWait('//img[@alt=''Next'']');
  selenium_ClickAndWait('//img[@alt=''Next'']');

  Log('---5.2......');
  selenium_ClickAndWait('link=I''m rich! Run up my bill! I want to Download Again!');

  Log('---Back:Homepage......');
  selenium_ClickAndWait('link=SHOWCASE');

  Log('---Star:6.Java, JavaScript and XML......');
  selenium_ClickAndWait('link=Java, JavaScript and XML');

  Log('---6.1......');
  selenium_ClickAndWait('//img[@alt=''Down'']');

  Log('---6.2......');
  selenium_ClickAndWait('//img[@alt=''Next'']');

  Log('---6.3......');
  selenium_ClickAndWait('//img[@alt=''Next'']');
  selenium_Type('word', 'test');
  selenium_ClickAndWait('//input[@value=''Go'']');

  Log('---6.4......');
  selenium_ClickAndWait('//img[@alt=''Next'']');

  Log('---6.5......');
  selenium_ClickAndWait('//img[@alt=''Next'']');

  Log('---Back:Homepage......');
  selenium_ClickAndWait('link=SHOWCASE');

  Log('---Star:7.Unleash your imagination......');
  selenium_ClickAndWait('link=Unleash your imagination');

  Log('---7.1......');
  selenium_ClickAndWait('//img[@alt=''Down'']');
  Log('---7.1.1......');
  selenium_ClickAndWait('//img[@alt=''Down'']');
  Log('---7.1.2......');
  selenium_ClickAndWait('//img[@alt=''Next'']');
  Log('---7.1.3......');
  selenium_ClickAndWait('//img[@alt=''Next'']');
  Log('---7.1.4......');
  selenium_ClickAndWait('//img[@alt=''Next'']');
  Log('---7.1.5......');
  selenium_ClickAndWait('//img[@alt=''Next'']');
  Log('---7.1.6......');
  selenium_ClickAndWait('//img[@alt=''Next'']');
  Log('---7.1.7......');
  selenium_ClickAndWait('//img[@alt=''Next'']');
  Log('---7.1.8......');
  selenium_ClickAndWait('//img[@alt=''Next'']');
  Log('---7.1.9......');
  selenium_ClickAndWait('//img[@alt=''Next'']');
  Log('---7.1.10......');
  selenium_ClickAndWait('//img[@alt=''Next'']');

