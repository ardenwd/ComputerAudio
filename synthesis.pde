import controlP5.*;
import beads.*;
import java.util.Arrays;
import java.io.File;
import java.io.FileWriter;

FileWriter output;
String currFile;
boolean testing = false;

AudioContext ac;
ControlP5 GUI;
Gain mainGain;
Panner p[] = new Panner[5];
Boat boat = new Boat();
Wind wind = new Wind();
int timer;
int fadeTimer;
int radioCount = 0;
int windCount = 0;
int crewCount = 0;
int incomingBoatCount = 0;
IncomingBoat ic = new IncomingBoat();
String currMessage = " ";

//sample players and tts for radio
TextToSpeechMaker ttsMaker; 
BiquadFilter radioFilter;
WaveShaper ws;
SamplePlayer beep;
Gain beepGain;

//name of a file to load from the data directory
String mainTestFile = "sailing_tests.json";
String crewTestFile = "crew_test.json";

NotificationServer notificationServer;
ArrayList<Notification> notifications;

MyNotificationListener myNotificationListener;

int numHarmonics = 9;
float baseFrequency = 220.0;
Buffer CosineBuffer = new CosineBuffer().getDefault();
boolean count = false;

BiquadFilter lowPass;
Glide lowFilterGlide;

BiquadFilter highPass;
Glide highFilterGlide;


//wave players and such for the Wind
WavePlayer windModulator;
Glide windModulatorFrequency;
WavePlayer windCarrier;
Glide windCarrierFrequency;
Gain windRingGain;

//for crew wave
WavePlayer crewWave;
Glide crewWaveGlide;
Gain crewWaveGain;
BiquadFilter crewWaveFilter;
WaveShaper crewWaveShaper;
Glide [] crewWaveShapeGlide = new Glide [2];

//Sample players for oncoming boat
SamplePlayer song;
BiquadFilter icLowPass;
Glide icLowPassGlide;
Gain icGain;

//Sample players for crew voices
SamplePlayer [] crew = new SamplePlayer[4];
Gain crewMainGain;
Gain [] crewGain =new Gain [4];

void setup() {
  size(450, 600);
  background(random(255));
  
  //currFile = "temp.txt";
  makeFile("C:\\Users\\arden\\Desktop\\CM\\COMPUTER AUDIO\\DavisArden_pd4\\output\\temp_");
  writeToPrinter("tezt lol");

  ac = new AudioContext();
  mainGain = new Gain(ac, 1, 0);
  ac.out.addInput(mainGain);
  
    ttsMaker = new TextToSpeechMaker();
  
  //String exampleSpeech = "Text to speech is okay, I guess.";
  
  //ttsExamplePlayback(exampleSpeech); //see ttsExamplePlayback below for usage

  //START NotificationServer setup
  notificationServer = new NotificationServer();

  ////instantiating a custom class (seen below) and registering it as a listener to the server
  myNotificationListener = new MyNotificationListener();
  notificationServer.addListener(myNotificationListener);

  ////END NotificationServer setup

  GUI = new ControlP5(this);


  for ( int i =0; i< 5; i++) {
    p[i] = new Panner(ac);
  }

  lowFilterGlide = new Glide(ac, 400, 100);
  lowPass = new BiquadFilter(ac, BiquadFilter.LP, lowFilterGlide, .5);
  highFilterGlide = new Glide(ac, 0, 100);
  highPass = new BiquadFilter(ac, BiquadFilter.HP, highFilterGlide, .5);


  GUI.addButton("pauseEventStream").setPosition(60, 375).setSize(100, 60).setLabel("Pause");
  GUI.addButton("stopEventStream").setPosition(60, 450).setSize(100, 60).setLabel("Stop");
  GUI.addButton("windTestButton").setPosition(40, 20).setSize(180, 30).setLabel("Wind Test");
  GUI.addButton("radioTestButton").setPosition(40, 60).setSize(180, 30).setLabel("Radio Test");
  GUI.addButton("crewTestButton").setPosition(40, 100).setSize(180, 30).setLabel("Crew Test");
  GUI.addButton("incomingBoatTestButton").setPosition(40, 140).setSize(180, 30).setLabel("Incoming Boat Test");
  GUI.addButton("endButton").setPosition(40, 180).setSize(180, 30).setLabel("End");
  GUI.addButton("Test1Button").setPosition(270, 60).setSize(140, 30).setLabel("Test 1");
  GUI.addButton("Test2Button").setPosition(270, 100).setSize(140, 30).setLabel("Test 2");
  GUI.addButton("Test3Button").setPosition(270, 140).setSize(140, 30).setLabel("Test 3");
  GUI.addButton("repeatMessageButton").setPosition(325, 400).setSize(100, 60).setLabel("Repeat");


  //wind modulator
  windModulatorFrequency = new Glide(ac, baseFrequency, 200);
  windModulator = new WavePlayer(ac, windModulatorFrequency, Buffer.SINE);
  // create the carrier
  windCarrierFrequency = new Glide(ac, 0.5, 200);
  windCarrier = new WavePlayer(ac, windCarrierFrequency, Buffer.SINE);


  Function windModulation = new Function(windCarrier, windModulator)
  {
    public float calculate() {
      // multiply the value of modulator by
      // the value of the carrier
      return x[0] * x[1];
    }
  };


  windRingGain = new Gain(ac, 1, 0.7);
  windRingGain.addInput(windModulation);
  //connect to the Panner object
  p[3].addInput(windRingGain);
  // connect the Gain output to the AudioContext
  mainGain.addInput(p[3]);

  //make the incoming boat sounds
  song = getSamplePlayer("callmemaybe.mp3");
  
  icLowPassGlide = new Glide(ac, 0, 100);
  icLowPass = new BiquadFilter(ac, BiquadFilter.LP, icLowPassGlide, 0.5);
  icLowPass.addInput(song);
  icGain = new Gain(ac, 1, 0.5);
  icGain.addInput(icLowPass);
  //p[2].addInput(song);
  p[2].addInput(icGain);
  mainGain.addInput(p[2]);

  beep = getSamplePlayer("beep.mp3", false);
  beep.pause(true);
  beepGain = new Gain(ac, 1 , 0.1);
  beepGain.addInput(beep);
  mainGain.addInput(beepGain);
  
  crewMainGain = new Gain(ac, 1, 0.5);
  //make the crew sounds
  for (int i = 0; i< 4; i++) {
    crew[i] = getSamplePlayer("ready-w.wav");
    crew[i].pause(true);
    crew[i].setRate(new Glide(ac, ((i/12.0)+0.75)));
    crewGain[i] =  new Gain(ac, 1, 0.5);
    crewGain[i].addInput(crew[i]);
    crewMainGain.addInput(crewGain[i]);
  }
  mainGain.addInput(crewMainGain);

  ac.start();
}

void repeatMessageButton(){
  if(!(currMessage.equals(" "))){
    String m = "I repeat " + currMessage;
    ttsExamplePlayback(m);
  }
}

void radioTestButton() {
  stopEventStream(1);
  String radioTestFile = "radio_test.json";
  switch (radioCount){
    case 0 :
      radioTestFile = "radio_test.json";
      break;
    case 1 :
      radioTestFile = "radio_test2.json";
      break;
    case 2 :
      radioTestFile = "radio_test3.json";
      radioCount = -1;
      break;
  }
  radioCount++;  
  startEventStream(radioTestFile);
}

void crewTestButton() {
  stopEventStream(1);
  String crewTestFile = "crew_test.json";
  switch (crewCount){
    case 0 :
      crewTestFile = "crew_test.json";
      break;
    case 1 :
      crewTestFile = "crew_test2.json";
      break;
    case 2 :
      crewTestFile = "crew_test3.json";
      crewCount = -1;
      break;
  }
  crewCount++;  
  startEventStream(crewTestFile);
}

void incomingBoatTestButton() {
  stopEventStream(1);
  String incomingBoatTestFile = "incomingboat_test.json";
  switch (incomingBoatCount){
    case 0 :
      incomingBoatTestFile = "incomingboat_test.json";
      break;
    case 1 :
      incomingBoatTestFile = "incomingboat_test2.json";
      break;
    case 2 :
      incomingBoatTestFile = "incomingboat_test3.json";
      incomingBoatCount = -1;
      break;
  }
  incomingBoatCount++;  
  startEventStream(incomingBoatTestFile);
}


void windTestButton() {
  stopEventStream(1);
  String windTestFile = "wind_test.json";
  switch (windCount){
    case 0 :
      windTestFile = "wind_test.json";
      break;
    case 1 :
      windTestFile = "wind_test2.json";
      break;
    case 2 :
      windTestFile = "wind_test3.json";
      windCount = -1;
      break;
  }
  windCount++;  
  startEventStream(windTestFile);
}

void endButton(){
  closePrinter();
}

void Test1Button() {
  testing = true;
  closePrinter();
 makeFile("C:\\Users\\arden\\Desktop\\CM\\COMPUTER AUDIO\\DavisArden_pd4\\output\\test1_");
 writeToPrinter("test1");
  String filename = "test1.json";
  //loading the event stream, which also starts the timer serving events
  startEventStream(filename);
}

void Test2Button() {
  testing = true;
  closePrinter();
 makeFile("C:\\Users\\arden\\Desktop\\CM\\COMPUTER AUDIO\\DavisArden_pd4\\output\\test2_");
  writeToPrinter("test2");
  String filename = "test2.json";
  //loading the event stream, which also starts the timer serving events
  startEventStream(filename);
}

void Test3Button() {
  testing = true;
  closePrinter();
  makeFile("C:\\Users\\arden\\Desktop\\CM\\COMPUTER AUDIO\\DavisArden_pd4\\output\\test3_");
 writeToPrinter("test3");
  String filename = "test3.json";
  //loading the event stream, which also starts the timer serving events
  startEventStream(filename);
}

void startEventStream(String filename) {
  //loading the event stream, which also starts the timer serving events
  notificationServer.loadEventStream(filename);
  mainGain.setGain(1);
}

void pauseEventStream(int value) {
  //loading the event stream, which also starts the timer serving events
  notificationServer.pauseEventStream();
  mainGain.setGain(0);
}

void stopEventStream(int value) {
  //loading the event stream, which also starts the timer serving events
  notificationServer.stopEventStream();
  mainGain.setGain(0);
  boat = new Boat(0, 0, 0);
  ic.setData(100, 100, 0, boat);
  wind.setData(0, 0, 0, boat);
  currMessage =" ";
}

//in your own custom class, you will implement the NotificationListener interface
//(with the notificationReceived() method) to receive Notification events as they come in
class MyNotificationListener implements NotificationListener {

  public MyNotificationListener() {
    //setup here
  }

  //this method must be implemented to receive notifications
  public void notificationReceived(Notification notification) {
      float x = notification.getXPos();
      float y = notification.getYPos();
      float speed = notification.getSpeed();
   // println("<Example> " + notification.getID().toString() + " notification received at "
    //  + Integer.toString(notification.getTimestamp()) + " ms");

    String debugOutput = ">>> ";
    switch (notification.getID()) {
    case Boat:
      debugOutput += "Boat: ";
      boat = new Boat(x, y, speed);
      updateSounds();
      writeToPrinter("Initial info. \nBoat direction: " + boat.direction);
      break;
    case IncomingBoat:
      debugOutput += "Incoming Boat: ";
      ic.setData(x, y, speed, boat);
      updateSounds();
      writeToPrinter("Incoming boat: ICB distance: " + ic.distance + " , ICB direction: " + ic.relDirection);
      break;
    case Wind:
      debugOutput += "Wind: ";
      wind.setData(x, y, speed, boat);
      updateSounds();
      writeToPrinter("Wind direction: " + wind.relDirection);
      //updateWindSounds();
      break;
    case Puff:
      debugOutput += "Puff: ";
      break;
    case Crew:
      debugOutput += "Crew: ";
      boat.setCrewReadiness(x,y);
      break;
    case Warning:
      debugOutput += "New warning: ";
      break;
    case Message:
      debugOutput += "New message: ";
      break;
    }
    currMessage = notification.getMessage();
    if (currMessage.equals("Final Event") || currMessage.equals("Last Event") || currMessage.equals("Last event")|| currMessage.equals("Final event") || currMessage.equals("last") ){
      stopEventStream(1);
    }
    else if(!(currMessage.equals(""))){
      ttsExamplePlayback(currMessage);
    }
    debugOutput += notification.toString();

    println(debugOutput);
  }
}

void keyPressed() {
  if ( key == 'f' || key == 'f' ) {
    boat.turn((float)1/12 * (float)PI, wind);
    updateWindSounds();
    //System.out.println("hi");
    background(0);
    fill(255, 200, 200);
    rect(190, 375, 40, 120);
    fadeTimer = millis();
    updateSounds();
    writeToPrinter("Turn left was made. Wind direction: " + wind.relDirection + ", Boat direction: " + boat.direction + " Boat speed: " + boat.speed);
    if(ic.active){
      writeToPrinter("Incoming boat: ICB distance: " + ic.distance + " , ICB direction: " + ic.relDirection);
    }
  }
  if ( key == 'j' || key == 'J' ) {
    boat.turn((float)23/12 * (float)PI, wind);
    updateWindSounds();
    background(0);
    fill(255, 200, 200);
    rect(255, 375, 40, 120);
    fadeTimer = millis();
    updateSounds();
    writeToPrinter("Turn right was made. Wind direction: " + wind.relDirection + ", Boat direction: " + boat.direction + " Boat speed: " + boat.speed);
    if(ic.active){
      writeToPrinter("Incoming boat: ICB distance: " + ic.distance + " , ICB direction: " + ic.relDirection);
    }
  }
  if ( key == ' ') {
    writeToPrinter("Call to the crew. Ready: " + boat.crewReadiness);
    callCrew();
  }
}

void callCrew() {
  for ( int i = 0; i< 4; i++) {
    crewMainGain = new Gain(ac, 1, 0.5);
    if(boat.crewReadiness){
      crewGain[i].setGain((0.1*i)+0.7);
    }
    else{
      crewGain[i].setGain((0.1*i)+0.1);
      //make them ready
     }
      crew[i].setToLoopStart();
      crew[i].start();
  }
  if(!(boat.crewReadiness)){
   boat.setCrewReadiness(0,1);
  }
  mainGain.addInput(crewMainGain);
}

void updateSounds() {

  boat.move(wind);
  //System.out.println(ic.active);
  //System.out.println(timer);
  if (ic.active) {
      ic.move(boat);
    updateIncomingBoatSounds();
  } else {
    //if the boat is not active, then set the low pass to 0 so you don't hear it at all.
    icLowPassGlide.setValue(0);
  }
  updateWindSounds();
}

void updateWindSounds() {
  //takes the windSpeed and sets the frequency of the ring wind wave to a scaled version of it. Max should be about 300Hz
  windCarrierFrequency.setValue((boat.speed * 22.0)+ 0.5);
  

  if(wind.normalizedDirection > 0.92){
    wind.normalizedDirection = 0.92;
  }
    p[3].setPos(wind.normalizedDirection);
// System.out.println("wind norm -------- " + wind.normalizedDirection);
}

void updateIncomingBoatSounds() {
  //icLowPassGlide.setValue(1000);
  if (ic.distance == 0) {
   icLowPassGlide.setValue(10000);
   } else {
     // icLowPassGlide.setValue(10000 - (ic.distance * 100));
   icLowPassGlide.setValue(((1/ic.distance)*10000.0)+800);
 }

 float panVal = (ic.distance * ic.normalizedDirection) / 50.0;
  p[2].setPos(panVal);
  // System.out.println("ic pan -------- " + panVal);
}

void ttsExamplePlayback(String inputSpeech) {
  //create TTS file and play it back immediately
  //the SamplePlayer will remove itself when it is finished in this case
  
  String ttsFilePath = ttsMaker.createTTSWavFile(inputSpeech);
  println("File created at " + ttsFilePath);
    radioFilter = new BiquadFilter(ac, BiquadFilter.BP_SKIRT, 3000.0f, wind.speed + 1.0f);
    float[] WaveShape1 = {0.0, 0.9, 0.1, 0.9, -0.7, 0.8, -0.9, 0.9};
  //createTTSWavFile makes a new WAV file of name ttsX.wav, where X is a unique integer
  //it returns the path relative to the sketch's data directory to the wav file
  
  //see helper_functions.pde for actual loading of the WAV file into a SamplePlayer
  beep.setToLoopStart();
  beep.start();
  SamplePlayer sp = getSamplePlayer(ttsFilePath, true); 
  //true means it will delete itself when it is finished playing
  //you may or may not want this behavior!
  ws = new WaveShaper(ac, WaveShape1);
// connect the gain to the WaveShaper
  ws.addInput(sp);
  radioFilter.addInput(ws);
  mainGain.addInput(radioFilter);
  sp.setToLoopStart();
  sp.start();
  writeToPrinter("Message spoken: " + inputSpeech);
 // println("TTS: " + inputSpeech);
}

void draw() {

  if (millis() - timer >= 300) {
    timer = millis();
    updateSounds();
  }
  if (millis() - fadeTimer >= 300) {
    background(0);
  }
}
