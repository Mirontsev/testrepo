/*
  This example demonstrates how to post messages and images to
  TestComplete's test log.
*/

function CorrectRGBComponent(component)
{
  component = aqConvert.VarToInt(component);
  if (component < 0)
    return 0;
  else
    if (component > 255)
	  return 255; 
	else
	  return component;  
}

function RGB(r, g, b)
{
  r = CorrectRGBComponent(r);
  g = CorrectRGBComponent(g);
  b = CorrectRGBComponent(b);
  return r | (g << 8) | (b << 16);
}

function TestLog()
{
  var nFirstFolderID, nSecondFolderID, nChildFolderID,
      oLogAttr, oImage;

  Log.Message("A message");
  Log.Checkpoint("A checkpoint");
  Log.Warning("A warning");
  Log.Error("An error");
  Log.Event("An event");

  Log.Message("A message", "An expanded message");
  Log.Checkpoint("A checkpoint", "An expanded checkpoint");
  Log.Warning("A warning", "An expanded warning");
  Log.Error("An error", "An expanded error");
  Log.Event("An event", "An expanded event");
  
  oLogAttr = Log.CreateNewAttributes();
  oLogAttr.Bold = true;
  
  nFirstFolderID = Log.CreateFolder("First folder",
    "Use folders to group similar fragments of log messages");
  nSecondFolderID = Log.CreateFolder("Second folder", "", pmLowest, oLogAttr);
  oLogAttr.Bold = false;
  oLogAttr.Italic = true;
  nChildFolderID = Log.CreateFolder("Another level folder", "",
    pmNormal, oLogAttr, nFirstFolderID);
  
  Log.PushLogFolder(nFirstFolderID);  

  Log.Picture(Sys.Desktop.Picture(0, 0, 100, 100),
    "Sys.Desktop.Picture(0, 0, 100, 100)");
  Log.Picture(Sys.Desktop.PictureUnderMouse(40, 40),
    "Sys.Desktop.PictureUnderMouse", "A rectangle with the mouse cursor in the center");
 
  Log.PushLogFolder(nChildFolderID);
  	
  Log.Message("A message", "A message with priority = pmLowest", pmLowest);
  Log.Warning("A warning", "A warning with priority = pmLower", pmLower);
  Log.Message("A message", "A message with priority = pmNormal", pmNormal);
  Log.Checkpoint("A checkpoint", "A checkpoint with priority = pmLower", pmLower);
  Log.Error("An error", "An error with priority = pmHigher", pmHigher);
  Log.Event("An event", "An event with priority = pmHighest", pmHighest);
  
  Log.PopLogFolder();
  Log.PopLogFolder();
  
  Log.Message("A message", "Priority = 9 (Can be used as a tag)", 9);

  oLogAttr.Italic = false;
  oLogAttr.FontColor = RGB(192, 0, 0);
  oLogAttr.BackColor = RGB(255, 255, 0); 
  oImage = Sys.Desktop.Picture();
  
  Log.Message("Error Count = " + Log.ErrCount.toString(),
    "", pmNormal, oLogAttr, oImage, nSecondFolderID);
  Log.Message("Warning Count = " + Log.WrnCount.toString(),
    "", pmNormal, oLogAttr, oImage, nSecondFolderID);
  Log.Message("Event Count = " + Log.EvnCount.toString(),
    "", pmNormal, oLogAttr, oImage, nSecondFolderID);
  Log.Message("Image Count = " + Log.ImgCount.toString(),
    "", pmNormal, oLogAttr, 0, nSecondFolderID); 
  Log.Message("Message Count = " + Log.MsgCount.toString(),
    "", pmNormal, oLogAttr, 0, nSecondFolderID);
}