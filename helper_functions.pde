import java.time.*;

Sample getSample(String fileName) {
 return SampleManager.sample(dataPath(fileName)); 
}

SamplePlayer getSamplePlayer(String fileName, Boolean killOnEnd) {
  SamplePlayer player = null;
  try {
    player = new SamplePlayer(ac, getSample(fileName));
    player.setKillOnEnd(killOnEnd);
    player.setName(fileName);
  }
  catch(Exception e) {
    println("Exception while attempting to load sample: " + fileName);
    e.printStackTrace();
    exit();
  }
  
  return player;
}

SamplePlayer getSamplePlayer(String fileName) {
  return getSamplePlayer(fileName, false);
}

public float hypotenuse(
  double x1, 
  double y1, 
  double x2, 
  double y2) {       
    if((x1 ==0) && (y1 == 0 ) && (x2 ==0) && (y2 == 0)){ return 0;}
    return (float) Math.sqrt((y2 - y1) * (y2 - y1) + (x2 - x1) * (x2 - x1));
}

public String getFilePath(String x){
  Instant cur = Instant.now();
    String time = cur.toString();
    time = time.replace(":", "_");
    String temp = x;
    
    temp += time;
    temp += ".txt";
    System.out.println(temp);
    return temp;
}

public void makeFile(String temp){
  // create a file object for the current location
    String filename = getFilePath(temp);
    File file = new File(filename);
    
    try {
      
      // create a new file with name specified
      // by the file object
      boolean value = file.createNewFile();
      if (value) {
        System.out.println("New Java File is created.");
        output = new FileWriter(file);
        System.out.println("New Printer is created.");
      }
      else {
        System.out.println("The file already exists.");
        output = new FileWriter(file);
      }
    }
    catch(Exception e) {
      System.out.println("crash");
      e.getStackTrace();
    }
  }
  

public void writeToPrinter(String data){
  if(testing){
       try {
       output.write(data + " @ time = " + millis() + "\n");
     }
     catch (Exception e) {
       System.out.println("didn't work" );
       e.getStackTrace();
     }
  }
}

public void closePrinter(){
       try {
       output.close();
     }
     catch (Exception e) {
       System.out.println("didn't work" );
       e.getStackTrace();
     }
}
