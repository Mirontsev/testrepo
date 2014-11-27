/*The script demonstrates integration of TestComplete and AQtime. 
The script is used for automatic testing of an application, loaded from AQtime.

The script will work only if AQTime 8 is installed on your computer.
*/

function Integration()
{
var AppPath
  AppPath = TestedApps.Orders.FullFileName
  if (AQtimeIntegration.IsSupportedVersionAvailable (8) == true) {
       AQtime.CreateProjectFromModule(AppPath)
       AQtime.SelectProfiler ("Coverage Profiler")
       AQtime.StartProfiling()
       Test()
       AQtime.WaitAndExportResults(Project.Path + "ProfilingResults\\SummaryResults.xml",Project.Path + "\\ProfilingResults\\FullResults.xml")
       AQtime.WaitForEndOfProfiling()
       AQtime.Close()
       }  
  else
       Log.Error("You should install AQtime version 8")	   
}

function Test()
{
  var orders;
  var mainForm;
  var edit;
  var orderFrm;
  var cardNoEdit;
  
  orders = Sys.Process("Orders");
  orders.VCLObject("MainForm").MainMenu.Click("[0]|[1]");

  edit = orders.Window("#32770", "Open").WaitWindow("Edit");
  orders.Window("#32770", "Open").Window("ComboBoxEx32").Window("ComboBox").Window("Edit").wText = Project.Path + "..\\..\\Orders\\MyTable.tbl";
  orders.Window("#32770", "Open", 1).Window("Button", "&Open").ClickButton();	

  mainForm = orders.VCLObject("MainForm");
  mainForm.VCLObject("ListView").ClickItem("Samuel Clemens", 0);
  mainForm.VCLObject("ToolButton6").Click(9, 10);
  
  orderFrm = orders.VCLObject("OrderFrm");
  orderFrm.VCLObject("Product_ComboBox").ClickItem("FamilyAlbum");
  cardNoEdit = orderFrm.VCLObject("CardNo_Edit");
  cardNoEdit.DblClick(83, 12);
  cardNoEdit.Keys("12456789012");
  orderFrm.VCLObject("OKButton").ClickButton();
    
  mainForm.MainMenu.Click("Orders|[0]");

  orderFrm = orders.VCLObject("OrderFrm");
  orderFrm.VCLObject("Product_ComboBox").ClickItem("ScreenSaver");
  orderFrm.VCLObject("Qty_Edit").Keys("4");
  orderFrm.VCLObject("Date_Edit").SetText(aqConvert.DateTimeToStr(aqDateTime.Today()));  
  orderFrm.VCLObject("CustomerName_Edit").Keys("John Black");
  orderFrm.VCLObject("Street_Edit").Keys("Light street");
  orderFrm.VCLObject("City_Edit").Keys("Rain city");
  orderFrm.VCLObject("State_Edit").Keys("US");
  orderFrm.VCLObject("Zip_Edit").Keys("123456");
  orderFrm.VCLObject("AE_RadioButton").ClickButton();
  orderFrm.VCLObject("CardNo_Edit").Keys("1324354657");
  orderFrm.VCLObject("ExpireDate_Edit").SetText(aqConvert.DateTimeToStr(aqDateTime.AddMonths(aqDateTime.Today(), 1)));  
  orderFrm.VCLObject("OKButton").Keys("[Enter]");
  mainForm.Close(0);
  orders.Window("#32770", "Confirm").Window("Button", "&No").ClickButton();
  
  // Waiting until the Orders process is terminated
  do
    Delay(500)
  while (orders.Exists);
}