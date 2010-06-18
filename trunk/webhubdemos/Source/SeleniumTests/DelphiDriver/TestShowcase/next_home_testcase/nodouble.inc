selenium.Open('/pgmonitor:12044:testcase=nodouble');
selenium.Click('link=home page for this application');
selenium.WaitForPageToLoad('30000');
selenium.Click('//a[contains(text(),''Impressum'')]');
selenium.WaitForPageToLoad('30000');
