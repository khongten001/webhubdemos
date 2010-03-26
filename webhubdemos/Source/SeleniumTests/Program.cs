using System;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading;
using System.IO;

using NUnit.Framework;
using Selenium;

namespace SeleniumTests
{
    public class SeleniumTests
	{
        string selenium_server = "localhost"; //"nexthelp.webhub.com";
        int selenium_server_port= 5555; //4444
        string selenium1_url = "http://demos.href.com/";
        string selenium2_url = "http://192.168.1.71/"; //"http://mydos.eicp.net/";
        string browser = "*firefox"; //"*iexplore";
        //string browser = "*custom C:\\Program Files\\Mozilla Firefox\\firefox.exe -no-remote -profile d:\\apps\\selenium\\server\\firefoxselenium";

        string cur_path = AppDomain.CurrentDomain.BaseDirectory + "\\";
        string log_path = AppDomain.CurrentDomain.BaseDirectory + "\\";
        int error_count = 0;
        ISelenium selenium1;
        ISelenium selenium2;

        //bool match(string s1, string s2)
        //{
        //}

        bool compare_result(string title)
        {
            string s1_org = selenium1.GetHtmlSource();
            string s2_org = selenium2.GetHtmlSource();

            Regex reg = new Regex("<span class=\"changing\">.*</span>", RegexOptions.IgnoreCase);
            string s1 = reg.Replace(s1_org, "");
            string s2 = reg.Replace(s2_org, "");

            reg = new Regex(":1204\\..*\"", RegexOptions.IgnoreCase);
            s1 = reg.Replace(s1, ":1204\"");
            s2 = reg.Replace(s2, ":1204\"");

            //Console.WriteLine("  Compare: result={0}", (s1 == s2 ? "Same" : "Not match"));
            //for (int i = 0; i < Math.Min(s1.Length, s2.Length); i++)
            //{
            //    if (s1[i] != s2[i])
            //    {
            //        Console.WriteLine("  Diff:\n\r    HtmlSource1={0}\n\r    HtmlSource2={1}",
            //            s1.Substring(i, (s1.Length - i - 1 >= 20 ? 20 : s1.Length - i - 1)),
            //            s2.Substring(i, (s2.Length - i - 1 >= 20 ? 20 : s2.Length - i - 1)));
            //        break;
            //    }
            //}
            //if (s1 != s2)
            //{
                error_count++;
                string file1 = String.Format("{0}A\\{1}.txt", log_path, error_count);
                if (File.Exists(file1))
                    File.Delete(file1);
                FileStream fs = File.Open(file1, FileMode.OpenOrCreate);
                TextWriter tw = new StreamWriter(fs);
                tw.WriteLine(title);
                tw.Write(s1);
                tw.Flush();
                tw.Close();
                string file2 = String.Format("{0}B\\{1}.txt", log_path, error_count);
                if (File.Exists(file2))
                    File.Delete(file2);
                fs = File.Open(file2, FileMode.OpenOrCreate);
                tw = new StreamWriter(fs);
                tw.WriteLine(title);
                tw.Write(s2);
                tw.Flush();
                tw.Close();
            //}

            return s1 == s2;
        }

        enum SeleniumAction { Open, Click, WaitForPageToLoad, Type, GoBack, Select, AddSelection }

        bool selenium_command(SeleniumAction action)
        {
            return selenium_command(action, "", "", true);
        }
        
        bool selenium_command(SeleniumAction action, bool compare)
        {
            return selenium_command(action, "", "", compare);
        }
        
        bool selenium_command(SeleniumAction action, string param)
        {
            return selenium_command(action, param, "", true);
        }
        
        bool selenium_command(SeleniumAction action, string param, bool compare)
        {
            return selenium_command(action, param, "", compare);
        }
        
        bool selenium_command(SeleniumAction action, string param, string param2)
        {
            return selenium_command(action, param, param2, true);
        }
        
        bool selenium_command(SeleniumAction action, string param,string param2, bool compare)
        {
            try
            {
                switch (action)
                {
                    case SeleniumAction.Open:
                        Console.WriteLine("action={0} host={1} param={2},{3}", action.ToString(), selenium1_url, param, param2);
                        selenium1.Open(param);
                        Console.WriteLine("action={0} host={1} param={2},{3}", action.ToString(), selenium2_url, param, param2);
                        selenium2.Open(param);
                        break;
                    case SeleniumAction.Click:
                        Console.WriteLine("action={0} host={1} param={2},{3}", action.ToString(), selenium1_url, param, param2);
                        selenium1.Click(param);
                        Console.WriteLine("action={0} host={1} param={2},{3}", action.ToString(), selenium2_url, param, param2);
                        selenium2.Click(param);
                        break;
                    case SeleniumAction.WaitForPageToLoad:
                        Console.WriteLine("action={0} host={1} param={2},{3}", action.ToString(), selenium1_url, param, param2);
                        selenium1.WaitForPageToLoad(param);
                        Console.WriteLine("action={0} host={1} param={2},{3}", action.ToString(), selenium2_url, param, param2);
                        selenium2.WaitForPageToLoad(param);
                        break;
                    case SeleniumAction.Type:
                        Console.WriteLine("action={0} host={1} param={2},{3}", action.ToString(), selenium1_url, param, param2);
                        selenium1.Type(param, param2);
                        Console.WriteLine("action={0} host={1} param={2},{3}", action.ToString(), selenium2_url, param, param2);
                        selenium2.Type(param, param2);
                        break;
                    case SeleniumAction.GoBack:
                        Console.WriteLine("action={0} host={1} param={2},{3}", action.ToString(), selenium1_url, param, param2);
                        selenium1.GoBack();
                        Console.WriteLine("action={0} host={1} param={2},{3}", action.ToString(), selenium2_url, param, param2);
                        selenium2.GoBack();
                        break;
                    case SeleniumAction.Select:
                        Console.WriteLine("action={0} host={1} param={2},{3}", action.ToString(), selenium1_url, param, param2);
                        selenium1.Select(param, param2);
                        Console.WriteLine("action={0} host={1} param={2},{3}", action.ToString(), selenium2_url, param, param2);
                        selenium2.Select(param, param2);
                        break;
                    case SeleniumAction.AddSelection:
                        Console.WriteLine("action={0} host={1} param={2},{3}", action.ToString(), selenium1_url, param, param2);
                        selenium1.AddSelection(param, param2);
                        Console.WriteLine("action={0} host={1} param={2},{3}", action.ToString(), selenium2_url, param, param2);
                        selenium2.AddSelection(param, param2);
                        break;
                }
                if (compare)
                    return compare_result(String.Format("action={0} param={1},{2}", action.ToString(), param, param2));
                else
                    return true;
            }
            catch (Exception ee)
            {
                Console.WriteLine("Exception: action={0} param={1},{2} message={3}", action.ToString(), param, param2, ee.Message);
                Console.WriteLine("Press any key to conitnue......");
				Console.ReadKey();
				//ConsoleKeyInfo key = Console.ReadKey();
				//if (key.Key == CosoleKey.Escape)
				//{
				//}				
                return false;
            }
        }

        public void Run()
        {
            try
            {
								string[] files = Directory.GetFiles(log_path + "a");
                for (int i = 0; i < files.Length; i++)
                    File.Delete(files[i]);
                files = Directory.GetFiles(log_path + "b");
                for (int i = 0; i < files.Length; i++)
                    File.Delete(files[i]);
                    
                Console.WriteLine("Start selenium instance: host={0}", selenium1_url);
                selenium1 = new DefaultSelenium(selenium_server, selenium_server_port, browser, selenium1_url);
                selenium1.Start();
                Console.WriteLine("Start selenium instance: host={0}", selenium2_url);
                selenium2 = new DefaultSelenium(selenium_server, selenium_server_port, browser, selenium2_url);
                selenium2.Start();
                compare_showcase();
            }
            catch (Exception ee)
            {
                Console.WriteLine("Exception: {0}", ee.Message);
            }
            finally
            {
                try
                {
                    selenium1.Stop();
                    selenium2.Stop();
                }
                catch (Exception ee)
                {
                    Console.WriteLine("Exception: {0}", ee.Message);
                }
            }
            Console.WriteLine("Press any key to continue......");
            //Console.ReadKey();
        }

        void compare_showcase()
        {
            selenium_command(SeleniumAction.Open, "/showcase:pgmonitor:1204");
            selenium_command(SeleniumAction.Click, "btnMonitor1204");
            selenium_command(SeleniumAction.Open, "/showcase::1204");
            //selenium_command(SeleniumAction.Click, "//div[@id='whdemopagecontent']/center/table/tbody/tr/td[1]/a[4]/img");
			selenium_command(SeleniumAction.Click, "link=Easier HTML");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//img[@alt='Down']");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//img[@alt='Down']");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//img[@alt='Next']");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//img[@alt='Next']");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//img[@alt='Next']");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//img[@alt='Next']");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Type, "litSurferName", "Emily");
			selenium_command(SeleniumAction.Click, "submit");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//img[@alt='Next']");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//img[@alt='Next']");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//img[@alt='Down']");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//img[@alt='Next']");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//img[@alt='Next']");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//img[@alt='Next']");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Type, "litSurferName+5", "Emily");
			selenium_command(SeleniumAction.Click, "submit");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//img[@alt='Up']");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//img[@alt='Next']");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//img[@alt='Down']");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "link=JUMP to the next page");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "link=GO to the next page");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "link=Don't HIDE the link to the next page");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "link=TwhAppBase.Properties");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.GoBack);
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Type, "litSurferName", "Emily");
			selenium_command(SeleniumAction.Click, "submit");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "submit");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//img[@alt='Next']");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "link=GO to Easier HTML Main Page");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.GoBack);
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "link=Random GO to Easier HTML Main Page");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.GoBack);
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//img[@alt='Next']");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "link=A JUMP to this page");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//img[@alt='Next']");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//img[@alt='Next']");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//img[@alt='Down']");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "v1");
			selenium_command(SeleniumAction.Click, "submit");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.GoBack);
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//img[@alt='Next']");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "submit");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.GoBack);
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//img[@alt='Next']");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "submit");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.GoBack);
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//img[@alt='Next']");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//img[@alt='Next']");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//img[@alt='Next']");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//img[@alt='Next']");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//img[@alt='Next']");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//img[@alt='Next']");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//img[@alt='Down']");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//img[@alt='Next']");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//img[@alt='Next']");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//img[@alt='Next']");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//img[@alt='Next']");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//img[@alt='Next']");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//img[@alt='Next']");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//img[@alt='Next']");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//img[@alt='Next']");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//img[@alt='Next']");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "link=Easier HTML");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "link=Frames");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//img[@alt='Down']");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.GoBack);
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "link=SHOWCASE");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "link=Forms with Built-in Save-State");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//img[@alt='Down']");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//img[@alt='Down']");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "submit");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Select, "litIconFile", "label=Fair");
			selenium_command(SeleniumAction.Click, "submit");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Select, "litIconFile", "label=Sold");
			selenium_command(SeleniumAction.Click, "submit");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//div[@id='whRightNavButtons']/a/img");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.AddSelection, "MYSELECT", "label=This is option #1");
			selenium_command(SeleniumAction.Click, "submit");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//img[@alt='Next']");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//input[@name='color' and @value='Green']");
			selenium_command(SeleniumAction.Click, "submit");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//input[@name='color' and @value='Blue']");
			selenium_command(SeleniumAction.Click, "submit");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "color");
			selenium_command(SeleniumAction.Click, "submit");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//input[@name='Language' and @value='German']");
			selenium_command(SeleniumAction.Click, "//div[@id='Layer2']/form[2]/input[5]");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//input[@name='Language' and @value='French']");
			selenium_command(SeleniumAction.Click, "//div[@id='Layer2']/form[2]/input[5]");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//input[@name='Language' and @value='Spanish']");
			selenium_command(SeleniumAction.Click, "//div[@id='Layer2']/form[2]/input[5]");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "Language");
			selenium_command(SeleniumAction.Click, "//div[@id='Layer2']/form[2]/input[5]");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//div[@id='whRightNavButtons']/a/img");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Type, "Retail", "1");
			selenium_command(SeleniumAction.Type, "wholesale", "2");
			selenium_command(SeleniumAction.Type, "cost", "3");
			selenium_command(SeleniumAction.Type, "loss", "4");
			selenium_command(SeleniumAction.Click, "radioA");
			selenium_command(SeleniumAction.Click, "submit");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//input[@name='radioA' and @value='Wholesale']");
			selenium_command(SeleniumAction.Click, "submit");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//input[@name='radioA' and @value='Cost']");
			selenium_command(SeleniumAction.Click, "submit");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//input[@name='radioA' and @value='Loss']");
			selenium_command(SeleniumAction.Click, "submit");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//img[@alt='Next']");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "MYCHECKBOX");
			selenium_command(SeleniumAction.Click, "submit");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "YOURCHECKBOX");
			selenium_command(SeleniumAction.Click, "submit");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//img[@alt='Next']");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Type, "txtDescription", "testtest");
			selenium_command(SeleniumAction.Click, "submit");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Type, "txtDescription", "apples=red");
			selenium_command(SeleniumAction.Click, "submit");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Type, "txtDescription", "(~litSurfername~)");
			selenium_command(SeleniumAction.Click, "submit");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//img[@alt='Next']");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "submit");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//input[@name='submit' and @value='HairStyle,Punk']");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//input[@name='submit' and @value='HairStyle,Matted']");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//input[@name='submit' and @value='HairStyle,Toupee']");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//input[@name='submit' and @value='HairStyle,Curly']");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//img[@alt='Next']");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//img[@alt='Next']");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//img[@alt='Down']");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Type, "litSurferName", "ran");
			selenium_command(SeleniumAction.Type, "litOrganization", "abc");
			selenium_command(SeleniumAction.Click, "submit");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//img[@alt='Next']");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "link=Set Your Preferences");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.GoBack);
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//img[@alt='Next']");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "link=SHOWCASE");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "link=WebMaster Topics");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//img[@alt='Down']");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//img[@alt='Down']");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "link=Try this link");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.GoBack);
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//div[@id='whRightNavButtons']/a/img");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "link=Try this link");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.GoBack);
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "link=InvalidPage");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.GoBack);
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//div[@id='whRightNavButtons']/a/img");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//img[@alt='Next']");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//img[@alt='Next']");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "link=SPEED");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.GoBack);
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//img[@alt='Next']");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//img[@alt='Down']");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.GoBack);
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "link=The Status Page");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.GoBack);
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "link=The Speed Page");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.GoBack);
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "link=The Echo Page");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.GoBack);
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "link=The Personal Preferences Page");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.GoBack);
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "link=The Errors Page");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.GoBack);
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//img[@alt='Next']");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//img[@alt='Down']");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//img[@alt='Next']");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//img[@alt='Next']");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "link=SHOWCASE");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "link=E-Mail");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//img[@alt='Down']");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Type, "//input[@name='Msg To']", "ccdzhang@hotmail.com");
			selenium_command(SeleniumAction.Type, "MsgFrom", "ran@hotmail.com");
			selenium_command(SeleniumAction.Type, "SurferName", "ranzhang");
			selenium_command(SeleniumAction.Type, "TxtVar.txtMessage", "Most companies want to get feedback from people surfing their site. WebHub provides explicit support for structured feedback pages.");
			selenium_command(SeleniumAction.Click, "submit");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.GoBack);
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//img[@alt='Next']");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "link=SHOWCASE");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "link=Surfer Tracking");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//img[@alt='Down']");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//img[@alt='Down']");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "link=Click this link to see the cookies displayed.");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//img[@alt='Next']");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "link=Reload this page to confirm the cookies are deleted");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//img[@alt='Next']");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//img[@alt='Next']");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "link=bounce test A");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.GoBack);
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//div[@id='whRightNavButtons']/a/img");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//div[@id='whRightNavButtons']/a/img");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//img[@alt='Next']");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//img[@alt='Next']");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "link=I'm rich! Run up my bill! I want to Download Again!");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//img[@alt='Next']");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "link=SHOWCASE");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "link=Java, JavaScript and XML");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//img[@alt='Down']");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//img[@alt='Next']");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//img[@alt='Next']");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Type, "word", "test");
			selenium_command(SeleniumAction.Click, "//input[@value='Go']");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//img[@alt='Next']");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "link=Click to see a tiny XML document");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.GoBack);
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "link=Employee data served by WebHub.");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.GoBack);
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//img[@alt='Next']");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//div[@id='whRightNavButtons']/a/img");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "link=SHOWCASE");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "link=Unleash your imagination");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//img[@alt='Down']");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//img[@alt='Down']");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//img[@alt='Next']");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//img[@alt='Next']");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//img[@alt='Next']");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//img[@alt='Next']");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//img[@alt='Next']");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//img[@alt='Next']");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//img[@alt='Next']");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//img[@alt='Next']");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
			selenium_command(SeleniumAction.Click, "//img[@alt='Next']");
			selenium_command(SeleniumAction.WaitForPageToLoad, "60000");
        }

        static void Main(string[] args)
        {
            //Regex reg = new Regex(":1204\\..*\"", RegexOptions.IgnoreCase);
            //string s = reg.Replace("aaa:1204.bbbb\"ccc", "");
            //Console.WriteLine(s);
            //Console.ReadKey();
            //return;

            Console.WriteLine("Start......");
            SeleniumTests test = new SeleniumTests();
            test.Run();
        }        
	}

}