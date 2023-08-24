import controlP5.*;
import beads.*;
//import org.jaudiolibs.beads.*;

//declare global variables at the top of your sketch
//AudioContext ac; is declared in helper_functions
ControlP5 GUI;
SamplePlayer music;
SamplePlayer reset;
SamplePlayer reverse;
SamplePlayer fastForward;
SamplePlayer play;
SamplePlayer stop;
PImage img;

Gain mainGain;
//like volume knobs
Glide gainGlide;
Glide musicRateGlide;

//CE3
double musicLength;
Bead musicEndListener;
//end global variables

//runs once when the Play button above is pressed
void setup() {
  size(550, 400); //size(width, height) must be the first line in setup()
  img = loadImage("walkman.jpg");
  ac = new AudioContext(); //AudioContext ac; is declared in helper_functions 
  
  GUI = new ControlP5(this);
    

  //CE3
  music = getSamplePlayer("mazzy.mp3"); 
  play = getSamplePlayer("start.wav");
  reset = getSamplePlayer("reset.wav");
  fastForward = getSamplePlayer("fast-forward.wav");
  reverse = getSamplePlayer("rewind.wav");
  stop = getSamplePlayer("stop.wav");
  play.pause(true);
  reset.pause(true);
  fastForward.pause(true);
  stop.pause(true);
  reverse.pause(true);
  
  musicLength = music.getSample().getLength();
  
    // create music playback rate Glide, set to 0 initially or music will play on startup
  musicRateGlide = new Glide(ac, 0, 500);
  // use rateGlide to control music playback rate
  // notice that music.pause(true) is not needed since
  // we set the initial playback rate to 0
  music.setRate(musicRateGlide);

  
  gainGlide = new Glide(ac, 0.75, 20);
  mainGain = new Gain(ac, 1, gainGlide);
  //mainGain.addInput(music);
  //ac.out.addInput(mainGain);
  mainGain.addInput(music);
  ac.out.addInput(mainGain); 
  ac.out.addInput(play);
  ac.out.addInput(stop);
  ac.out.addInput(reverse);
  ac.out.addInput(reset);
  ac.out.addInput(fastForward);
    // create all of your button sound effect SamplePlayers
  // and connect them into a UGen graph to ac.out

//CE3
  // create a reusable endListener Bead to detect end/beginning of music playback
  musicEndListener = new Bead()
  {
    public void messageReceived(Bead message)
    {
      // Get handle to the SamplePlayer which received this endListener message
      SamplePlayer sp = (SamplePlayer) message;

      // remove this endListener to prevent its firing over and over
      // due to playback position bugs in Beads
      sp.setEndListener(null);
      
      // The playback head has reached either the end or beginning of the tape.
      // Stop playing music by setting the playback rate to 0 immediately
      setPlaybackRate(0, true);
    }
  };
  
  //control p5 controls
  //gain knob
  GUI.addKnob("GainSlider")
    .setPosition(50,10)
    .setRange(0,100)
    .setSize(65,50)
    .setValue(75)
    .setLabel(" "); 
  
  GUI.addButton("Play")
    .setPosition(140,20)
    .setSize(60,50)
    .setLabel("Play")
    .activateBy(ControlP5.PRESS);
    
  GUI.addButton("Stop")
    .setPosition(220,20)
    .setSize(60,50)
    .setLabel("Stop")
    .activateBy(ControlP5.PRESS);

  GUI.addButton("FastForward")
    .setPosition(300,20)
    .setSize(60,50)
    .setLabel(">>")
    .activateBy(ControlP5.PRESS);

  GUI.addButton("Rewind")
    .setPosition(380,20)
    .setSize(60,50)
    .setLabel("<<")
    .activateBy(ControlP5.PRESS);

  GUI.addButton("Reset")
    .setPosition(460,20)
    .setSize(60,50)
    .setLabel("Reset")
    .activateBy(ControlP5.PRESS);
  
  ac.start();

}

//CE3
// Add endListener to the music SamplePlayer if one doesn't already exist
public void addEndListener() {
  if (music.getEndListener() == null) {
    music.setEndListener(musicEndListener);
  }
}

// Set music playback rate using a Glide
public void setPlaybackRate(float rate, boolean immediately) {
  // Make sure playback head position isn't past end or beginning of the sample 
  if (music.getPosition() >= musicLength) {
    println("End of tape");
    // reset playback head position to end of sample (tape)
    music.setToEnd();
  }

  if (music.getPosition() < 0) {
    println("Beggining of tape");
    // reset playback head position to beginning of sample (tape)
    music.reset();
  }
  
  if (immediately) {
    musicRateGlide.setValueImmediately(rate);
  }
  else {
    musicRateGlide.setValue(rate);
  }
}

public void GainSlider(float value){
  println("gain slider pressed");
  //make sure to normalize the value
  gainGlide.setValue(value/100.0);
}

public void Play(int value){
  // if playback head isn't at the end of tape, set rate to 1
  if (music.getPosition() < musicLength) {
    setPlaybackRate(1, false);
    addEndListener();
  }
  // always play the button sound
  play.start(0);
}

public void Stop(int value){
  stop.start(0);
  setPlaybackRate(0, true);
}

public void FastForward(int value){
  fastForward.start(0);
  setPlaybackRate(2, true);
}

public void Rewind(int value){
  reverse.start(0);
  setPlaybackRate(-2, true);
}

public void Reset(int value){
  reset.start(0);
  setPlaybackRate(0, true);
  music.reset();
}

void draw() {
  background(#a2a30d);
  //rectangle #a2a39f
  image(img, 0,80, 550,320);
}
