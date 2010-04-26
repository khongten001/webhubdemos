Log('0. SHOWCASE');
selenium_Open('/showcase::1204');
selenium_ClickAndWait('//div[@id=''menuThisWebHubDemo'']/ul/li[2]/a');

Log('1. SHOWCASE >> Easier HTML');
selenium_ClickAndWait('link=Easier HTML');

Log('1.1 SHOWCASE >> Easier HTML >> How and Why WebHub Works');
selenium_ClickAndWait('link=How and Why WebHub Works');

Log('1.1.1 SHOWCASE >> Easier HTML >> How and Why WebHub Works >> Automatically Saving State');
selenium_ClickAndWait('link=Automatically Saving State');
selenium_ClickAndWait('link=How and Why WebHub Works');

Log('1.1.2 SHOWCASE >> Easier HTML >> How and Why WebHub Works >> WebHub URLs');
selenium_ClickAndWait('link=WebHub URLs');
selenium_ClickAndWait('link=How and Why WebHub Works');

Log('1.1.3 SHOWCASE >> Easier HTML >> How and Why WebHub Works >> Server Side Session Data');
selenium_ClickAndWait('link=Server Side Session Data');
selenium_ClickAndWait('link=How and Why WebHub Works');

Log('1.1.4 SHOWCASE >> Easier HTML >> How and Why WebHub Works >> Dynamic Page Links');
selenium_ClickAndWait('link=Dynamic Page Links');
selenium_ClickAndWait('link=How and Why WebHub Works');

Log('1.1.5 SHOWCASE >> Easier HTML >> How and Why WebHub Works >> Automatic Defaults on Forms');
selenium_ClickAndWait('link=Automatic Defaults on Forms');
selenium_Type('litSurferName', 'Joshua');
selenium_ClickAndWait('submit');
selenium_Type('litSurferName', 'zurückkommen');
selenium_ClickAndWait('submit');
selenium_Type('litSurferName', '¹¨ÉÙ»ª');
selenium_ClickAndWait('submit');
selenium_Type('litSurferName', 'Joshua');
selenium_ClickAndWait('submit');

selenium_ClickAndWait('link=Easier HTML');

Log('1.2 SHOWCASE >> Easier HTML >> Reusable Pieces of HTML');
selenium_ClickAndWait('link=Reusable Pieces of HTML');

Log('1.2.1 SHOWCASE >> Easier HTML >> Reusable Pieces of HTML >> Text Substitution');
selenium_ClickAndWait('link=Text Substitution');
selenium_ClickAndWait('link=Reusable Pieces of HTML');

Log('1.2.2 SHOWCASE >> Easier HTML >> Reusable Pieces of HTML >> Contact Info');
selenium_ClickAndWait('link=Contact Info');
selenium_ClickAndWait('link=Reusable Pieces of HTML');

Log('1.2.3 SHOWCASE >> Easier HTML >> Reusable Pieces of HTML >> Page Headers and Footers');
selenium_ClickAndWait('link=Page Headers and Footers');
selenium_ClickAndWait('link=Reusable Pieces of HTML');

Log('1.2.4 SHOWCASE >> Easier HTML >> Reusable Pieces of HTML >> Republishing StringVars');
selenium_ClickAndWait('link=Republishing StringVars');
selenium_Type('litSurferName+5', 'GongShaoHua');
selenium_ClickAndWait('submit');

selenium_ClickAndWait('link=Easier HTML');

Log('1.3 SHOWCASE >> Easier HTML >> Dynamic Links Within a Site');
selenium_ClickAndWait('link=Dynamic Links Within a Site');

Log('1.3.1 SHOWCASE >> Easier HTML >> Dynamic Links Within a Site >> The JUMP Macro');
selenium_ClickAndWait('link=The JUMP Macro');
selenium_ClickAndWait('link=JUMP to the same page');
selenium_ClickAndWait('link=JUMP to the next page');
selenium_ClickAndWait('link=GO to the next page');
selenium_ClickAndWait('link=Don''t HIDE the link to the next page');
selenium_ClickAndWait('submit');
selenium_ClickAndWait('submit');

selenium_ClickAndWait('link=Dynamic Links Within a Site');

Log('1.3.2 SHOWCASE >> Easier HTML >> Dynamic Links Within a Site >> The CURRENT Macro');
selenium_ClickAndWait('link=The CURRENT Macro');
selenium_ClickAndWait('submit');
selenium_ClickAndWait('link=Dynamic Links Within a Site');

Log('1.3.3 SHOWCASE >> Easier HTML >> Dynamic Links Within a Site >> Reload Macros');
selenium_ClickAndWait('link=Reload Macros');
selenium_ClickAndWait('link=GO to Easier HTML Main Page');
selenium_GoBack();
selenium_ClickAndWait('link=Random GO to Easier HTML Main Page');
selenium_GoBack();
selenium_ClickAndWait('link=Dynamic Links Within a Site');

Log('1.3.4 SHOWCASE >> Easier HTML >> Dynamic Links Within a Site >> Page Aliasing');
selenium_ClickAndWait('link=Page Aliasing');
selenium_ClickAndWait('link=A JUMP to this page');
selenium_ClickAndWait('link=A JUMP to pgPageAlias2 which is aliased to pgPageAlias');

selenium_ClickAndWait('link=Easier HTML');

Log('1.4 SHOWCASE >> Easier HTML >> WebHub Commands');
selenium_ClickAndWait('link=WebHub Commands');

Log('1.4.1 SHOWCASE >> Easier HTML >> WebHub Commands >> The IF, IFNOT Macro');
selenium_ClickAndWait('link=The IF, IFNOT Macro');
selenium_ClickAndWait('submit');
selenium_ClickAndWait('submit');
selenium_Click('v1');
selenium_ClickAndWait('submit');
selenium_Click('v1');
selenium_ClickAndWait('submit');
selenium_ClickAndWait('link=WebHub Commands');
selenium_ClickAndWait('link=The IF, IFNOT Macro');
selenium_Click('v1');
selenium_ClickAndWait('submit');
selenium_Click('v1');
selenium_ClickAndWait('submit');
selenium_ClickAndWait('link=WebHub Commands');

Log('1.4.2 SHOWCASE >> Easier HTML >> WebHub Commands >> Conditional Processing');
selenium_ClickAndWait('link=Conditional Processing');
selenium_Click('v1');
selenium_ClickAndWait('submit');
selenium_Click('v1');
selenium_ClickAndWait('submit');
selenium_ClickAndWait('link=WebHub Commands');

Log('1.4.3 SHOWCASE >> Easier HTML >> WebHub Commands >> WebHub and Checkboxes');
selenium_ClickAndWait('link=WebHub and Checkboxes');
selenium_Click('v1');
selenium_ClickAndWait('submit');
selenium_ClickAndWait('link=WebHub Commands');

Log('1.4.4 SHOWCASE >> Easier HTML >> WebHub Commands >> The MATCH, NOMATCH Macro');
selenium_ClickAndWait('link=The MATCH, NOMATCH Macro');
selenium_ClickAndWait('link=WebHub Commands');

Log('1.4.5 SHOWCASE >> Easier HTML >> WebHub Commands >> The PAGE Macro');
selenium_ClickAndWait('link=The PAGE Macro');
selenium_ClickAndWait('link=WebHub Commands');

Log('1.4.6 SHOWCASE >> Easier HTML >> WebHub Commands >> The REQUIRES Macro');
selenium_ClickAndWait('link=The REQUIRES Macro');
selenium_ClickAndWait('link=WebHub Commands');

Log('1.4.7 SHOWCASE >> Easier HTML >> WebHub Commands >> The INCLUDE Macro');
selenium_ClickAndWait('link=The INCLUDE Macro');
selenium_ClickAndWait('link=WebHub Commands');

Log('1.4.8 SHOWCASE >> Easier HTML >> WebHub Commands >> The SENDFILE Macro');
selenium_ClickAndWait('link=The SENDFILE Macro');
selenium_ClickAndWait('link=WebHub Commands');

Log('1.4.9 SHOWCASE >> Easier HTML >> WebHub Commands >> The EXPIRES Macro');
selenium_ClickAndWait('link=The EXPIRES Macro');

Log('1.4.9.1 SHOWCASE >> Easier HTML >> WebHub Commands >> The EXPIRES Macro >> Now');
selenium_ClickAndWait('link=Now');
selenium_ClickAndWait('link=The EXPIRES Command');

Log('1.4.9.2 SHOWCASE >> Easier HTML >> WebHub Commands >> The EXPIRES Macro >> Tomorrow');
selenium_ClickAndWait('link=Tomorrow');
selenium_ClickAndWait('link=The EXPIRES Command');

Log('1.4.9.3 SHOWCASE >> Easier HTML >> WebHub Commands >> The EXPIRES Macro >> Yesterday');
selenium_ClickAndWait('link=Yesterday');
selenium_ClickAndWait('link=The EXPIRES Command');

Log('1.4.9.4 SHOWCASE >> Easier HTML >> WebHub Commands >> The EXPIRES Macro >> 2 Days Ago');
selenium_ClickAndWait('link=2 Days Ago');
selenium_ClickAndWait('link=The EXPIRES Command');

Log('1.4.9.5 SHOWCASE >> Easier HTML >> WebHub Commands >> The EXPIRES Macro >> At the Turn of the Century');
selenium_ClickAndWait('link=At the Turn of the Century');
selenium_ClickAndWait('link=The EXPIRES Command');

Log('1.4.9.6 SHOWCASE >> Easier HTML >> WebHub Commands >> The EXPIRES Macro >> exact:14:00');
selenium_ClickAndWait('link=exact:14:00');
selenium_ClickAndWait('link=The EXPIRES Command');

Log('1.4.9.7 SHOWCASE >> Easier HTML >> WebHub Commands >> The EXPIRES Macro >> exact:2:15 P.M.');
selenium_ClickAndWait('link=exact:2:15 P.M.');
selenium_ClickAndWait('link=The EXPIRES Command');
selenium_ClickAndWait('link=WebHub Commands');

Log('1.4.10 SHOWCASE >> Easier HTML >> WebHub Commands >> The EXPIRES Macro >> The SUMMARY Macro');
selenium_ClickAndWait('link=The SUMMARY Macro');
selenium_ClickAndWait('link=WebHub Commands');
selenium_ClickAndWait('link=Easier HTML');

Log('1.5 SHOWCASE >> Easier HTML >> Frames');
selenium_ClickAndWait('link=Frames');
selenium_ClickAndWait('link=Content Picker Example');
selenium_GoBack();


