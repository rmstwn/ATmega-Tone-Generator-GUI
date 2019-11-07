import processing.serial.*;
import ddf.minim.analysis.*;
import ddf.minim.*;
import ddf.minim.signals.*;

Minim minim;
AudioOutput out;
int spazio = 50;
int value;
Serial myPort;  // Create object from Serial class
String val;     // Data received from the serial port

void setup()
{
  String portName = "COM4"; //change the 0 to a 1 or 2 etc. to match your port
  myPort = new Serial(this, portName, 9600);
  size(400, 400);

  minim = new Minim(this);
  out = minim.getLineOut(Minim.STEREO);
}

void draw()
{
  background(0);
  stroke(0);
  for (int x = 0; x <= width; x = x + spazio ) {
    fill(255);
    rect(x - 50, 0, x, height);
  }
  fill(0);
  rect(35, 0, 30, 250);
  rect(85, 0, 30, 250);
  rect(185, 0, 30, 250);
  rect(235, 0, 30, 250);
  rect(285, 0, 30, 250);
  rect(385, 0, 30, 250);
}
void mouseReleased() {
  myPort.write('#');
  myPort.write('2');
  myPort.write('9');
  myPort.write('!');
}
void mousePressed() {
  SineWave mySine;
  MyNote newNote;
  float pitch = 0;

  // do
  if (mouseX < 35 && mouseY < 250 || mouseX < 50 && mouseY > 250) {
    //song = minim.loadFile("Do1.mp3");
    //song.play();
    pitch = 262;
    value = 0;
    myPort.write('#');
    myPort.write('2');
    myPort.write('1');
    myPort.write('!');
  }
  //re
  if (mouseX > 65 && mouseX < 85 && mouseY < 250) {
    //song = minim.loadFile("Re1.mp3");
    //song.play();
    pitch = 294;
    value = 1;
  }
  if (mouseY > 250 && mouseX > 50 && mouseX < 100 || value == 1) {
    //song = minim.loadFile("Re1.mp3");
    //song.play();
    pitch = 294;
    value = 0;
    myPort.write('#');
    myPort.write('2');
    myPort.write('2');
    myPort.write('!');
  }
  //mi
  if (mouseX > 115 && mouseX < 150 && mouseY < 250) {
    //song = minim.loadFile("Mi1.mp3");
    //song.play();
    pitch = 330;
    value = 2;
  }
  if ( mouseY > 250 && mouseX > 100 && mouseX < 150 || value == 2) {
    //song = minim.loadFile("Mi1.mp3");
    //song.play();
    pitch = 330;
    value = 0;
    myPort.write('#');
    myPort.write('2');
    myPort.write('3');
    myPort.write('!');
  } 
  //fa
  if (mouseX > 150 && mouseX < 185 && mouseY < 250) {
    //song = minim.loadFile("Fa1.mp3");
    //song.play();
    pitch = 349;
    value = 3;
  }
  if (mouseY > 250 && mouseX > 150 && mouseX < 200 || value == 3) {
    //song = minim.loadFile("Fa1.mp3");
    //song.play();
    pitch = 349;
    value = 0;
    myPort.write('#');
    myPort.write('2');
    myPort.write('4');
    myPort.write('!');
  }
  //sol
  if (mouseX > 215 && mouseX < 235 && mouseY < 250) {
    //song = minim.loadFile("Sol1.mp3");
    //song.play();
    pitch = 392;
    value = 4;
  }
  if (mouseY > 250 && mouseX > 200 && mouseX < 250 || value == 4) {
    //song = minim.loadFile("Sol1.mp3");
    //song.play();
    pitch = 392;
    value = 0;
    myPort.write('#');
    myPort.write('2');
    myPort.write('5');
    myPort.write('!');
  }

  //la
  if (mouseX > 265 && mouseX < 285 && mouseY < 250) {
    //song = minim.loadFile("La1.mp3");
    //song.play();
    pitch = 440;
    value = 5;
  }
  if (mouseY > 250 && mouseX > 250 && mouseX < 300 || value == 5) {
    //song = minim.loadFile("La1.mp3");
    //song.play();
    pitch = 440;
    value = 0;
    myPort.write('#');
    myPort.write('2');
    myPort.write('6');
    myPort.write('!');
  }

  //si 
  if (mouseX > 315 && mouseX < 350 && mouseY < 250) {
    //song = minim.loadFile("Si1.mp3");
    //song.play();
    pitch = 494;
    value = 6;
  }
  if (mouseY > 250 && mouseX > 300 && mouseX < 350 || value == 6) {
    //song = minim.loadFile("Si1.mp3");
    //song.play();
    pitch = 494;
    value = 0;
    myPort.write('#');
    myPort.write('2');
    myPort.write('7');
    myPort.write('!');
  }

  //do2
  if (mouseX > 350 && mouseX < 385 && mouseY < 250) {
    //song = minim.loadFile("Do2.mp3");
    //song.play();
    pitch = 523;
    value = 7;
  }
  if (mouseY > 250 && mouseX > 350 && mouseX < 400 || value == 7) {
    //song = minim.loadFile("Do2.mp3");
    //song.play();
    pitch = 523;
    value = 0;
    myPort.write('#');
    myPort.write('2');
    myPort.write('8');
    myPort.write('!');
  }

  // I bemolli
  //do#
  if ( mouseX > 35 && mouseX < 65 && mouseY < 250) {
    //song = minim.loadFile("Do#1.mp3");
    //song.play();
    pitch = 277;
    myPort.write('#');
    myPort.write('1');
    myPort.write('1');
    myPort.write('!');
  }
  //re#
  if ( mouseX > 85 && mouseX < 115 && mouseY < 250) {
    //song = minim.loadFile("Re#1.mp3");
    //song.play();
    pitch = 311;
    myPort.write('#');
    myPort.write('1');
    myPort.write('2');
    myPort.write('!');
  }
  // fa#
  if ( mouseX > 185 && mouseX < 215 && mouseY < 250) {
    //song = minim.loadFile("Fa#1.mp3");
    //song.play();
    pitch = 370;
    myPort.write('#');
    myPort.write('1');
    myPort.write('3');
    myPort.write('!');
  }
  // sol#
  if ( mouseX > 235 && mouseX < 265 && mouseY < 250) {
    //song = minim.loadFile("Sol#1.mp3");
    //song.play();
    pitch = 415;
    myPort.write('#');
    myPort.write('1');
    myPort.write('4');
    myPort.write('!');
  }
  //la#
  if ( mouseX > 285 && mouseX < 315 && mouseY < 250) {
    //song = minim.loadFile("La#1.mp3");
    //song.play();
    pitch = 466;
  }
  if (pitch > 0) {
    newNote = new MyNote(pitch, 0.2);
  }
}


void stop()
{
  out.close();
  minim.stop();

  super.stop();
}

class MyNote implements AudioSignal
{
  private float freq;
  private float level;
  private float alph;
  private SineWave sine;

  MyNote(float pitch, float amplitude)
  {
    freq = pitch;
    level = amplitude;
    sine = new SineWave(freq, level, out.sampleRate());
    alph = 0.9;
    out.addSignal(this);
  }

  void updateLevel()
  {
    level = level * alph;
    sine.setAmp(level);

    if (level < 0.01) {
      out.removeSignal(this);
    }
  }

  void generate(float [] samp)
  {
    sine.generate(samp);
    updateLevel();
  }

  void generate(float [] sampL, float [] sampR)
  {
    sine.generate(sampL, sampR);
    updateLevel();
  }
}
