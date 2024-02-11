/****************************/
/* Arcade 4 - Player PacMan */
/****************************/
/*(c) 2022-2024  AssortiMens*/
/*                          */
/*    (w)  William  Senn    */
/*                          */
/*        Changed by        */
/*                          */
/*   (Complete this list)   */
/*   (as necessary under)   */
/*       (GNU GPL-3.0)      */
/****************************/

import ddf.minim.*;
import org.gamecontrolplus.*;
import processing.serial.*;

//import stuff for pathfinding
import java.util.Deque;
import java.util.Iterator;
import java.util.LinkedList;

Serial serial;
Minim minim;

AudioPlayer TitleSong;
AudioSample BonusSound;
AudioSample BigDotSound;
AudioSample SmallDotSound;
AudioSample StartTunePacman;
AudioSample GameOverSound;
AudioSample Explosion;

Tile tiles[][] = new Tile[31][56]; //note it goes y then x because of how I inserted the data
int tilesRepresentation[][] = {
  {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
  {1, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1},
  {1, 8, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 8, 1, 1, 8, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 8, 1},
  {1, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1},
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
  {1, 0, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 0, 1},
  {1, 0, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 0, 1},
  {1, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1},
  {1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 6, 1, 1, 6, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 6, 1, 1, 6, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1},
  {1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 6, 1, 1, 6, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 6, 1, 1, 6, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1},
  {1, 1, 1, 1, 1, 1, 0, 1, 1, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 1, 1, 0, 1, 1, 1, 1, 1, 1},
  {1, 1, 1, 1, 1, 1, 0, 1, 1, 6, 1, 1, 1, 6, 1, 1, 1, 1, 6, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 6, 1, 1, 1, 1, 6, 1, 1, 1, 6, 1, 1, 0, 1, 1, 1, 1, 1, 1},
  {1, 1, 1, 1, 1, 1, 0, 1, 1, 6, 1, 6, 6, 6, 6, 6, 6, 1, 6, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 6, 1, 6, 6, 6, 6, 6, 6, 1, 6, 1, 1, 0, 1, 1, 1, 1, 1, 1},
  {0, 0, 0, 0, 0, 0, 0, 6, 6, 6, 1, 6, 6, 6, 6, 6, 6, 1, 6, 6, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6, 6, 6, 1, 6, 6, 6, 6, 6, 6, 1, 6, 6, 6, 0, 0, 0, 0, 0, 0, 0},
  {1, 1, 1, 1, 1, 1, 0, 1, 1, 6, 1, 6, 6, 6, 6, 6, 6, 1, 6, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 6, 1, 6, 6, 6, 6, 6, 6, 1, 6, 1, 1, 0, 1, 1, 1, 1, 1, 1},
  {1, 1, 1, 1, 1, 1, 0, 1, 1, 6, 1, 1, 1, 1, 1, 1, 1, 1, 6, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 6, 1, 1, 1, 1, 1, 1, 1, 1, 6, 1, 1, 0, 1, 1, 1, 1, 1, 1},
  {1, 1, 1, 1, 1, 1, 0, 1, 1, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 1, 1, 0, 1, 1, 1, 1, 1, 1},
  {1, 1, 1, 1, 1, 1, 0, 1, 1, 6, 1, 1, 1, 1, 1, 1, 1, 1, 6, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 6, 1, 1, 1, 1, 1, 1, 1, 1, 6, 1, 1, 0, 1, 1, 1, 1, 1, 1},
  {1, 1, 1, 1, 1, 1, 0, 1, 1, 6, 1, 1, 1, 1, 1, 1, 1, 1, 6, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 6, 1, 1, 1, 1, 1, 1, 1, 1, 6, 1, 1, 0, 1, 1, 1, 1, 1, 1},
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
  {1, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1},
  {1, 8, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 8, 1, 1, 8, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 8, 1},
  {1, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 1},
  {1, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 1},
  {1, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 1},
  {1, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1},
  {1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1},
  {1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1},
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
  {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}};

//its not sexy but it does the job
//--------------------------------------------------------------------------------------------------------------------------------------------------

int NumKeys = 20; /* 20 voor de kast / Arduino */
int TotalNumKeys = 120; // Normal keyboard, use 20 out of 120
int TranslationConstance = 0; // 0 for no translation and kast / Arduino. 1 for PC. 11 for macosx.
int NumKeysPerPlayer = 5;

int LinksToetsen[] =  {TranslationConstance+0, TranslationConstance+5, TranslationConstance+10, TranslationConstance+15};
int VuurKnoppen[] =   {TranslationConstance+1, TranslationConstance+6, TranslationConstance+11, TranslationConstance+16};
int RechtsToetsen[] = {TranslationConstance+2, TranslationConstance+7, TranslationConstance+12, TranslationConstance+17};
int PlusToetsen[] =   {TranslationConstance+3, TranslationConstance+8, TranslationConstance+13, TranslationConstance+18};
int MinToetsen[] =    {TranslationConstance+4, TranslationConstance+9, TranslationConstance+14, TranslationConstance+19};

int Player;
int Key;
int keysPressed[] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};

boolean buttonPressed = false;
boolean HumanPlayer[] = {false, false, false, false};
int NumHumanPlayers = 0;

ControlIO control;
ControlDevice stick;

Table table = null;
int NumRows = 40;

float PFScaleX = 0;
float PFScaleY = 0;
int PFWidth = 0;
int PFHeight = 0;

void setup()
{
  //  size(996,640); //Start experimenting with these values and see what your baby can do!
    fullScreen(); //fullScreen and size can not be used simultaneously, at least one is needed!
  //  size(1512,744);
  //  size(896,496);
  noCursor(); //switch off your mouse cursor within the window being used. (clipped!)
  frameRate(100); //So, what's up Doc? Remember: High rates are clipped to a max!

  control = ControlIO.getInstance(this);

  try {
    println(control.deviceListToText(""));
    stick = control.getDevice("Arduino Leonardo"); // devicename (inside double-quotes!) or device number (without the double-quotes!) here.
  }
  catch (Exception e) {
    println("No Arduino found or no Toetsenbord/Keyboard configured!");
    System.exit(0);
  }

  try {
    minim = new Minim(this);
    TitleSong = minim.loadFile("data/Popcorn Remix [HD].mp3");
    BonusSound = minim.loadSample("data/BonusSound.wav"); // used in (Bonus) ToolTips!
    SmallDotSound = minim.loadSample("data/SmallDotSound.wav");
    BigDotSound = minim.loadSample("data/BigDotSound.wav");
    StartTunePacman = minim.loadSample("data/StartTunePacman.wav");
    GameOverSound = minim.loadSample("data/GameOverSound.wav");
    Explosion = minim.loadSample("data/BonusSound.wav");
  }
  catch (Exception e) {
    println("Can not open Sounds!");
    System.exit(0);
  }

  try {
    PacmanField = loadImage("data/PacmanField.jpg");

    PFWidth = PacmanField.width;
    PFHeight = PacmanField.height;

    //    if ((PFWidth != width/2) || (PFHeight != height))
    //      PacmanField.resize(width/2,height);

    //    PFWidth = PacmanField.width;
    //    PFHeight = PacmanField.height;

    //    PFScaleX = float(width/2) / float(PFWidth);
    //    PFScaleY = float(height) / float(PFHeight);

    if ((PFWidth != (28*int(width/56))) || (PFHeight != (31*int(height/31))))
      PacmanField.resize(28*int(width/56), 31*int(height/31));

    //    PFWidth = PacmanField.width;
    //    PFHeight = PacmanField.height;

    PFScaleX = (float(28*int(width/56)) / (float(PFWidth)));
    PFScaleY = (float(31*int(height/31)) / (float(PFHeight)));

    println(PFScaleX, PFScaleY);
    println(PFWidth, PFHeight);
    println(PFScaleX*PFWidth, PFScaleY*PFHeight);
    println(((PFScaleX*PFWidth))/( width / 56), ((PFScaleY*PFHeight))/( height / 31));
    println(width, height);
    println(width/16, height/16);
  }
  catch (Exception e) {
    println("data/PacmanField.jpg is missing!");
    System.exit(0);
  }

   // /*

   try {
   printArray(Serial.list());
   serial = new Serial(this, Serial.list()[2], 115200); // This should connect to the Arduino UNO for the lights!!
   serial.bufferUntil('\0');
   }
   catch (Exception e) {
   println("Could not open serial device!");
   System.exit(0);
   }
   
   // */

  Lampjes = 0;
  ser_Build_Msg_String_And_Send(Lampjes);

  InitialiseAllVariables();
  initGame();

  frameCounter = 0;

  loadHighscores();
  saveHighscores();

  TitleSong.loop();
}

int Lampjes = 0;

String TestBuffer = "w 255 255 255\n\r";
String TestBuffer2 = "w 255 255 255\n\r";
int OldCode = 0;

void ser_Build_Msg_String_And_Send(int tCode)
{
  char msgchars[] = {'w', ' ', '2', '5', '5', ' ', '2', '5', '5', ' ', '2', '5', '5', '\n', '\r', '\0'};
  char FastHex[] = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'};
  char header = 'w';
  char delimiter = ' ';
  int  msb = 0;
  int  hsb = 0;
  int  lsb = 0;
  char eos1 = '\n';
  char eos2 = '\r';
  char eos3 = (char)'\0';
  int numKars = 0;
  boolean msbwasgroter = false;
  boolean hsbwasgroter = false;
  boolean lsbwasgroter = false;
  int len = 0;

  if (tCode != OldCode) {
    msgchars = TestBuffer.toCharArray();
    msb = ((((tCode)&0xff0000)>>16));
    hsb = ((((tCode)&0x00ff00)>>8));
    lsb = ((((tCode)&0x0000ff)>>0));
    numKars = 0;
    msgchars[numKars++] = header;
    msgchars[numKars++] = delimiter;
    if ((msb) >= 0x64) {
      msgchars[numKars++] = FastHex[msb / 0x64];
      msbwasgroter = true;
    } else {
      msbwasgroter = false;
    }
    msb %= 0x64;
    if (((msb) >= 0x0a) || (msbwasgroter)) {
      msgchars[numKars++] = FastHex[msb / 0x0a];
    }
    msb %= 0x0a;
    msgchars[numKars++] = FastHex[msb];
    msgchars[numKars++] = delimiter;
    if ((hsb) >= 0x64) {
      msgchars[numKars++] = FastHex[hsb / 0x64];
      hsbwasgroter = true;
    } else {
      hsbwasgroter = false;
    }
    hsb %= 0x64;
    if (((hsb) >= 0x0a) || (hsbwasgroter)) {
      msgchars[numKars++] = FastHex[hsb / 0x0a];
    }
    hsb %= 0x0a;
    msgchars[numKars++] = FastHex[hsb];
    msgchars[numKars++] = delimiter;
    if ((lsb) >= 0x64) {
      msgchars[numKars++] = FastHex[lsb / 0x64];
      lsbwasgroter = true;
    } else {
      lsbwasgroter = false;
    }
    lsb %= 0x64;
    if (((lsb) >= 0x0a) || (lsbwasgroter)) {
      msgchars[numKars++] = FastHex[lsb / 0x0a];
    }
    lsb %= 0x0a;
    msgchars[numKars++] = (char)FastHex[lsb];
    msgchars[numKars++] = (char)eos1;
    msgchars[numKars++] = (char)eos2;
    msgchars[numKars] = (char)eos3;

    len = numKars;

    TestBuffer = (String.valueOf(msgchars));
    TestBuffer2 = TestBuffer.substring(0, len);
    //    print(TestBuffer2); //.substring(0,len));
    for (int i = 0; i < len; i++) {
      //      print(msgchars[i]);

       // /*

       serial.write((byte)(msgchars[i]));
       
       // */
    }
    OldCode = tCode;
  }
}

void InitialiseAllVariables()
{
  Joystick Joys[] = {joy3, joy4, joy1, joy2};

  joy1 = null;
  joy2 = null;
  joy3 = null;
  joy4 = null;

  Inky = null;
  Pinky = null;
  Blinky = null;
  Clyde = null;

  ValidCombi = false;

  NumPacMans = 0;
  NumGhosts = 0;
  NumAIGhosts = 0;

  NumHumanPlayers = 0;
  for (int i=0; i<4; i++) {
    ChosenOne[i] = 0;
    HumanPlayer[i] = false;
  }

  Opkomst = true;
  TextKleur = -1;
  TextSize = 20;
  TextAngle = 0;
  //  frameCounter = 0;
  Offset1 = 0;
  Offset2 = 0;
  GameOver = false;

  for (int j=0; j<31; j++)
  {
    for (int i=0; i<56; i++)
    {
      tiles[j][i] = new Tile((i*((width/(2*28))))+((width/112)), (j*((height/31)))+((height/62)));
      //        tiles[j][i] = new Tile((i*(1.040*(width/(2*28))))+8,(j*(1.046*(height/31)))+8);
      switch(tilesRepresentation[j][i])
      {
      case 0:
        tiles[j][i].dot = true;
        break;
      case 1:
        tiles[j][i].wall = true;
        break;
      case 6:
        tiles[j][i].eaten = true;
        break;
      case 8:
        tiles[j][i].bigDot = true;
        break;
      }
    }
  }

  Joys[0] = joy3;
  Joys[1] = joy4;
  Joys[2] = joy1;
  Joys[3] = joy2;

  joy3 = Joys[0];
  joy4 = Joys[1];
  joy1 = Joys[2];
  joy2 = Joys[3];


  if (joy3 == null)
  {
    PacMan Pcmn = new PacMan((int)((14)*(width/56))+(width/112), (int)(23*(height/31))+(height/62), 30, 30, color(255, 255, 0, 255));
    joy3 = new Joystick(Pcmn, null, color(0, 0, 255, 255));
  }
  if (joy4 == null)
  {
    PacMan Pcmn = new PacMan((int)((14+28)*(width/(2*28))+((width/112))), (int)(23*(height/31)+((height/62))), 30, 30, color(255, 255, 0, 255));
    joy4 = new Joystick(Pcmn, null, color(0, 255, 0, 255));
  }

  if (joy1 == null)
  {
    Ghost Ghst = new Ghost((int)(13*(width/(2*28))+((width/112))), (int)(14*(height/31)+((height/62))), 32, 32, color(255, 0, 0, 255));
    joy1 = new Joystick(null, Ghst, color(255, 0, 255, 255));
  }
  if (joy2 == null)
  {
    Ghost Ghst = new Ghost((int)(15*(width/(2*28))+((width/112))), (int)(14*(height/31)+((height/62))), 32, 32, color(0, 255, 0, 255));
    joy2 = new Joystick(null, Ghst, color(255, 0, 0, 255));
  }

  if ((Blinky == null) && (joy1 != null))
  {
    Blinky = joy1.PlayerIsGhost; // Possible player ghost
  }
  if ((Inky == null) && (joy2 != null))
  {
    Inky = joy2.PlayerIsGhost; // Possible player ghost
  }

  if (Pinky == null)
  { // AIGhost for sure
    Pinky = new Ghost((int)((13+28)*(width/(2*28))+((width/112))), (int)(14*(height/31)+((height/62))), 32, 32, color(255, 0, 255, 255));
  }
  if (Clyde == null)
  { // AIGhost for sure
    Clyde = new Ghost((int)((15+28)*(width/(2*28))+((width/112))), (int)(14*(height/31)+((height/62))), 32, 32, color(0, 255, 255, 255));
  }
}

Ghost Pinky = null;
Ghost Clyde = null;

Ghost Blinky = null;
Ghost Inky = null;

void loadHighscores() {
  try {
    table = loadTable("data/highscores.csv", "header");
    if (table != null) {
      NumRows = table.getRowCount();
      for (int i=0; i<NumRows; i++) {
        TableRow row = table.getRow(i);
        NaamLijst[i+10] = row.getString("name");
        Highscores[i+10] = row.getInt("score");
        CrownLijst[i+10] = row.getString("crown");
      }
    } else {
      println("table was null!");
    }
  }
  catch (Exception e) {
    println("Loading data/highscores.csv failed!");
    System.exit(0);
  }
}

void saveHighscores() {
  try {
    if (table != null) {
      NumRows = 40;
      table.setRowCount(NumRows);
      for (int i=0; i<NumRows; i++) {
        TableRow row = table.getRow(i);
        row.setString("name", NaamLijst[i+10]);
        row.setInt("score", Highscores[i+10]);
        row.setString("crown", CrownLijst[i+10]);
      }
      saveTable(table, "data/highscores.csv");
    } else {
      println("table == null! Try loading first!");
    }
  }
  catch (Exception e) {
    println("Error trying to save data/highscores.csv !");
    System.exit(0);
  }
}

boolean Opkomst = true;
int TextKleur = -1;
int TextSize = 20;
int TextAngle = 0;
int frameCounter = 0;
PImage PacmanField;
//PImage PacmanSprite[][];
boolean GameOver = false;

//Ghost Inky; // = new Ghost(100,100,44,44,color(255,0,0,255));
//Ghost Blinky; // = new Ghost(100,200,44,44,color(0,255,0,255));
//Ghost Pinky; // = new Ghost(200,100,44,44,color(0,0,255,255));
//Ghost Clyde; // = new Ghost(200,200,44,44,color(0,255,255,255));

//PacMan Pacman1; // = new PacMan(width/4,((height*3)/4)+11,44,44,color(255,255,0,255));
//PacMan Pacman2; // = new PacMan(width*3/4,((height*3)/4)+11,44,44,color(255,255,0,255));

int CalcLicht() {
  int LichtCode;

  LichtCode = CyclicBuffer[(frameCounter / 4) % 80];
  //  LichtCode = int(random(1048576));
  LichtCode &= 1048575;
  return LichtCode;
}

int CyclicBuffer[] = {1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096, 8192, 16384,
  32768, 65536, 131072, 262144, 524288,
  524288, 262144, 131072, 65536, 32768, 16384, 8192, 4096, 2048, 1024,
  512, 256, 128, 64, 32, 16, 8, 4, 2, 1,
  1, 3, 7, 15, 31, 63, 127, 255, 511, 1023, 2047, 4095, 8191, 16383,
  32767, 65535, 131071, 262143, 524287, 1048575,
  -1, -2, -4, -8, -16, -32, -64, -128, -256, -512, -1024, -2048, -4096, -8192,
  -16384, -32768, -65536, -131072, -262144, -524288, -1048576};

long Masks[] = {0x000fffe0, 0x000ffc1f, 0x000f83ff, 0x00007fff};

boolean ValidCombi = false;

void draw()
{
  if (frameCounter < 10000)
    Lampjes = CalcLicht(); //int(random(1048576));
  else
  {
    if ((frameCounter >= 10000) && (frameCounter < 11000))
    {
      Lampjes = (((((frameCounter-10000)/8)%2)==1)?(0):(-1)); // int(-1 * int(((frameCounter-10000) / 4) % 2));
      Lampjes &= 1048575;
      for (int s=0; s<4; s++) {
        if (HumanPlayer[(s & 3)] == true) {
          Lampjes &= (Masks[(s & 3)]);
        }
      }
    } else
    {
      Lampjes = 0;
    }
  }

  if ((frameCounter >= 0) && (frameCounter < 1000))
    PCM_Demo1();
  if ((frameCounter >= 1000) && (frameCounter < 2000))
    PCM_Demo2();
  if ((frameCounter >= 2000) && (frameCounter < 3250))
    PCM_Demo3();
  if ((frameCounter >= 3250) && (frameCounter < 4250))
    PCM_Demo4();

  buttonPressed = false;
  if (frameCounter < 4250)
    ButtonPressed();
  if ((buttonPressed)&&(frameCounter<10000)) {
    //    initGame();
    InitialiseAllVariables();
    initGame();

    frameCounter=10000;
    buttonPressed=false;
    for (int i=0; i<4; i++) {
      HumanPlayer[i]=false;
    }
  }

  if (frameCounter>=10000) {
    if (frameCounter<11000) {
      ButtonPressed();

      background(0);
      Joystick Joys[] = {joy3, joy4, joy1, joy2};

      Joys[0] = joy3;
      Joys[1] = joy4;
      Joys[2] = joy1;
      Joys[3] = joy2;
      pushMatrix();
      translate(width/2, height/2);
      rotate(radians(TextAngle++));
      TextAngle %= 360;
      textSize(20);
      fill(255);
      textAlign(CENTER, CENTER);
      text("Players Logged in", 0, -50);
      for (int k=0; k<4; k++) {
        if (HumanPlayer[k]) {
          fill(Joys[k].Color);
          text(Naam[k], 0, (k*25)-25);
        } else {
          fill(Joys[k].Color);
          text("Hit a key to log in!", 0, (k*25)-25);
        }
      }
      popMatrix();
      for (int i = TranslationConstance; i < (NumKeys + TranslationConstance); i++) {
        Key = keysPressed[((i) % TotalNumKeys)];
        keysPressed[((i) % TotalNumKeys)] = 0;
        if (Key > 0) {
          Player = ((((Key - 1) - TranslationConstance) % TotalNumKeys) / NumKeysPerPlayer);
          Key = ((((Key - 1) - TranslationConstance) % TotalNumKeys) % NumKeysPerPlayer);

          Lampjes |= (1L << (((Player & 3) * NumKeysPerPlayer) + Key));

          HumanPlayer[(Player & 3)] = true;
          NumHumanPlayers = 0;

          for (int j=0; j<4; j++) {
            NumHumanPlayers = ((HumanPlayer[j])?(NumHumanPlayers+1):(NumHumanPlayers));
          }
        }
      }
    }
  }

  if ((frameCounter >= 10000)&&(frameCounter < 11000))
  {
    Joystick Joys[] = {joy3, joy4, joy1, joy2};

    Joys[0] = joy3;
    Joys[1] = joy4;
    Joys[2] = joy1;
    Joys[3] = joy2;
    for (int p=0; p<4; p++) {
      if ((Joys[p].Menu == null) && (HumanPlayer[p] == true))
      {
        Joys[p].Menu = new Menu(2, Joys[p].Color, Options);
      }
      if ((Joys[p].Menu != null) && (HumanPlayer[p] == true))
      {
        Joys[p].Menu.Display(p);
        Joys[p].Menu.Update(p);
        ChosenOne[p] = Joys[p].Menu.ItemSelected;
      }
    }

    NumPacMans=0;
    NumGhosts=0;

    for (int q=0; q<4; q++)
    {
      if (ChosenOne[q] == 1)
      {
        NumGhosts++;
      }
    }
    NumPacMans = ((NumHumanPlayers - NumGhosts)<=0)?0:(NumHumanPlayers-NumGhosts);
    ValidCombi = false;
    if ((NumHumanPlayers <= 4)&&(NumHumanPlayers > 0))
    {
      if (NumHumanPlayers == (NumPacMans + NumGhosts))
      {
        if ((NumPacMans == 1) || (NumPacMans == 2))
        {
          pushMatrix();
          //           background(0);
          fill(255);
          textAlign(CENTER, CENTER);
          translate(width/2, height/2);
          rotate(radians((360-TextAngle)%360));
          text("Geldige combinatie!", 0, 0);
          text(NumHumanPlayers, 0, 25);
          text(NumPacMans, 0, 50);
          text(NumGhosts, 0, 75);
          popMatrix();
          ValidCombi = true;
        }
      }
    }
  }

  if ((ValidCombi == false) && (frameCounter >= 11000))
  {
    frameCounter = 0;
    InitialiseAllVariables();
    initGame();
  }

  if ((frameCounter >= 11000) && (frameCounter < 12000) && (ValidCombi == true))
  {
    pushMatrix();
    background(0);
    fill(255);
    textAlign(CENTER, CENTER);
    translate(width/2, height/2);
    rotate(radians(TextAngle++));
    TextAngle %= 360;
    text("Player(s), get ready!", 0, 25);
    popMatrix();

    DisplayCountdown(12000-frameCounter);

    if (frameCounter == 11500)
      StartTunePacman.trigger();
  }

  if ((frameCounter == 12000) && (!GameOver) && (ValidCombi == true))
  {
    initGame();
    //    InitialiseAllVariables();
  }

  if ((frameCounter >= 12000) && (!GameOver) && (ValidCombi == true))
  {
    if (fc_now == 0) {
      background(0);
      perFrameGame();
    }

    if (GameOver)
    {
      // check highscore

      GameOverSound.trigger();

      fc_now = frameCounter;

      if (joy3.PlayerIsPacman != null)
        joy3.Highscore = new Highscore(joy3.PlayerIsPacman.score, 0, true);
      else
        if (joy3.PlayerIsGhost != null)
          joy3.Highscore = new Highscore(joy3.PlayerIsGhost.score, 0, false);
        else
          joy3.Highscore = new Highscore(joy3.AIGhost.score, 0, false);

      if (joy4.PlayerIsPacman != null)
        joy4.Highscore = new Highscore(joy4.PlayerIsPacman.score, 1, true);
      else
        if (joy4.PlayerIsGhost != null)
          joy4.Highscore = new Highscore(joy4.PlayerIsGhost.score, 1, false);
        else
          joy4.Highscore = new Highscore(joy4.AIGhost.score, 1, false);

      if (joy1.PlayerIsPacman != null)
        joy1.Highscore = new Highscore(joy1.PlayerIsPacman.score, 2, true);
      else
        if (joy1.PlayerIsGhost != null)
          joy1.Highscore = new Highscore(joy1.PlayerIsGhost.score, 2, false);
        else
          joy1.Highscore = new Highscore(joy1.AIGhost.score, 2, false);

      if (joy2.PlayerIsPacman != null)
        joy2.Highscore = new Highscore(joy2.PlayerIsPacman.score, 3, true);
      else
        if (joy2.PlayerIsGhost != null)
          joy2.Highscore = new Highscore(joy2.PlayerIsGhost.score, 3, false);
        else
          joy2.Highscore = new Highscore(joy2.AIGhost.score, 3, false);

      /*
          frameCounter = 0; // reset!!
       fc_now = frameCounter;
       GameOver = false;
       InitialiseAllVariables(); // soort reset
       initGame();
       */
    }
  }

  if ((fc_now != 0) && (frameCounter >= fc_now) && (frameCounter < (fc_now + 10000)))
  { // display GameOver or Highscores?!

    background(0);

    joy1.Highscore.Display();
    joy2.Highscore.Display();
    joy4.Highscore.Display();
    joy3.Highscore.Display();

    DisplayCountdown(10000-(frameCounter-fc_now));

    joy3.Highscore.Update();
    joy4.Highscore.Update();
    joy1.Highscore.Update();
    joy2.Highscore.Update();
  }

  if ((fc_now != 0) && (frameCounter >= (fc_now + 10000)))
  {

    saveHighscores();

    frameCounter = 0; // reset after Highscores
    fc_now = frameCounter;
    GameOver = false;
    InitialiseAllVariables();
    initGame();
  }

  ser_Build_Msg_String_And_Send(Lampjes);

  frameCounter++;
  if (frameCounter >= 4250)
    if (frameCounter >= 10000)
      ;
    else
    {
      frameCounter = 0;
      //       InitialiseAllVariables();
      //       initGame();
    }
}

int fc_now = 0;

int CountdownHoek = 0;

void DisplayCountdown(int CountDown)
{
  pushMatrix();
  translate(width/2, height/2);
  rotate(radians(CountdownHoek));
  CountdownHoek--; // TextAngle++;
  CountdownHoek %= 360; // TextAngle %= 360;
  textAlign(CENTER, CENTER);
  textSize(20);
  fill(255);
  text(CountDown, 0, 0);
  popMatrix();
}

int ChosenOne[] = { 0, 0, 0, 0 };
int NumPacMans = 0;
int NumGhosts = 0;
int NumAIGhosts = 0;

void initGame() {
  //  InitialiseAllVariables();
  Joystick Joys[] = {joy3, joy4, joy1, joy2};

  Joys[0] = joy3;
  Joys[1] = joy4;
  Joys[2] = joy1;
  Joys[3] = joy2;

  BonusMultiplier = 1;

  for (int i=0; i<4; i++)
  {
    if (Joys[i] != null)
    {
      if ((HumanPlayer[i] == true) && (ValidCombi == true))
      {
        if (ChosenOne[i] == 0) // if (ChosenOne[i] == 0) // Joys[i] = pacman
        {
          Joys[i].PlayerIsPacman = new PacMan((int)((14+(28*(i&1)))*(width/(2*28))+((width/112))), (int)(23*(height/31)+((height/62))), 30, 30, Joys[i].Color);
          Joys[i].PlayerIsGhost = null;
          Joys[i].AIGhost = null;
          Joys[i].AIPacman = null;
          Joys[i].PlayerIsPacman.score = 0;
        } else // Joys[i] = Ghost
        {
          Joys[i].PlayerIsGhost = new Ghost((int)((13+(i&2)+(28*(i&1)))*(width/(2*28))+((width/112))), (int)(14*(height/31)+((height/62))), 32, 32, Joys[i].Color);
          Joys[i].PlayerIsPacman = null;
          Joys[i].AIGhost = null;
          Joys[i].AIPacman = null;
          Joys[i].PlayerIsGhost.score = 0;
        }
      } else // AI Ghost or AI Pacman
      {
        if ((!HumanPlayer[i])&&(!ValidCombi)&&((i&3)==0)) { // default pacman = AIPacman
          Joys[i].AIPacman = new PacMan((int)((14+(28*(i&1)))*(width/(2*28))+((width/112))), (int)(23*(height/31)+((height/62))), 30, 30, Joys[i].Color);
          Joys[i].AIGhost = null;
          Joys[i].PlayerIsPacman = null;
          Joys[i].PlayerIsGhost = null;
          Joys[i].AIPacman.score = 0;
        } else {
          Joys[i].AIGhost = new Ghost((int)((13+(1*(i&2))+(28*(i&1)))*(width/56)+((width/112))), (int)(14*(height/31)+((height/62))), 32, 32, Joys[i].Color);
          //        Blinky = new Ghost((int)((13+(28*(i&1)))*(width/56)+((width/112))),(int)(14*(height/31)+((height/62))),34,34,color(random(256),random(256),random(256),255));
          //        Inky = new Ghost((int)((15+(28*(i&1)))*(width/56)+((width/112))),(int)(14*(height/31)+((height/62))),34,34,color(random(256),random(256),random(256),255));
          Joys[i].PlayerIsPacman = null;
          Joys[i].PlayerIsGhost = null;
          Joys[i].AIPacman = null;
          Joys[i].AIGhost.score = 0;
        }
      }
    } else
    {
      println("Error Joys[i] == null!!");
    }
  }

  NumAIGhosts = 0;
  for (int i=0; i<4; i++)
  {
    if (Joys[i].AIGhost != null)
    {
      if (NumAIGhosts == 0)
        Blinky = Joys[i].AIGhost; //new Ghost((int)((13+(28*(i&1)))*(width/56)+((width/112))),(int)(14*(height/31)+((height/62))),34,34,color(random(256),random(256),random(256),255));
      if (NumAIGhosts == 1)
        Inky = Joys[i].AIGhost; //  Inky = new Ghost((int)((15+(28*(i&1)))*(width/56)+((width/112))),(int)(14*(height/31)+((height/62))),34,34,color(random(256),random(256),random(256),255));
      if (NumAIGhosts == 2)
        Pinky = Joys[i].AIGhost;
      if (NumAIGhosts == 3)
        Clyde = Joys[i].AIGhost;
      NumAIGhosts++;
    }
  }

  if (Blinky == null)
    Blinky = new Ghost((int)((13)*(width/56)+((width/112))), (int)(14*(height/31)+((height/62))), 34, 34, color(255, 0, 0, 255));
  if (Inky == null)
    Inky = new Ghost((int)((15)*(width/56)+((width/112))), (int)(14*(height/31)+((height/62))), 34, 34, color(0, 0, 255, 255));
  if (Pinky == null)
    Pinky = new Ghost((int)((13+28)*(width/56)+((width/112))), (int)(14*(height/31)+((height/62))), 34, 34, color(255, 128, 128, 255));
  if (Clyde == null)
    Clyde = new Ghost((int)((15+28)*(width/56)+((width/112))), (int)(14*(height/31)+((height/62))), 34, 34, color(0, 255, 255, 255));

  //  Pinky = new Ghost((int)((13)*(width/56)+((width/112))),(int)(14*(height/31)+((height/62))),34,34,color(0,255,255,255));
  //  Clyde = new Ghost((int)((15+28)*(width/56)+((width/112))),(int)(14*(height/31)+((height/62))),34,34,color(0,0,255,255));
} // End of initGame()

void PCM_Demo1()
{
  background(0);
  translate(width/2, height/2);
  rotate(radians(TextAngle++));
  TextAngle %= 360;
  textAlign(CENTER, CENTER);
  textSize(20); //TextSize++);
  //  if (TextSize > 20)
  //    TextSize = 20;

  if (Opkomst)
  {
    TextKleur++;
    if (TextKleur > 255) {
      TextKleur = 255;
      if ((frameCounter % 1000) == (1000-255))
        Opkomst = false;
    }
  } else
  {
    TextKleur--;
    if (TextKleur < 0)
    {
      TextKleur = 0;
      Opkomst = true;
    }
  }
  fill(TextKleur);
  text("AssortiMens presents", 0, -50);
  text("Four Player PacMan", 0, 0);
  text("© 2022-2024", 0, 50);

  fill(255);
  text("Press a key to play!", 0, 230-55);

  //  println(TextKleur); // debug info
  //  println(frameCounter); // debug info
}

void PCM_Demo2()
{
  background(0);
  translate(width/2, height/2);
  rotate(radians(TextAngle++));
  TextAngle %= 360;
  textAlign(CENTER, CENTER);
  textSize(20); //TextSize++);
  //  if (TextSize > 20)
  //    TextSize = 20;

  if (Opkomst)
  {
    TextKleur++;
    if (TextKleur > 255) {
      TextKleur = 255;
      if ((frameCounter % 1000) == (1000-255))
        Opkomst = false;
    }
  } else
  {
    TextKleur--;
    if (TextKleur < 0)
    {
      TextKleur = 0;
      Opkomst = true;
    }
  }
  fill(TextKleur);

  text("Programming", 0, -100);
  text("William Senn", 0, -70);

  text("GFX & Graphics", 0, -15);
  text("William Senn", 0, 15);

  text("SFX & Titlemusic", 0, 70);
  text("William Senn & DJ Mystik", 0, 100);

  fill(255);
  text("Press a key to play!", 0, 230-55);

  //  println(TextKleur); // debug info
  //  println(frameCounter); // debug info
}

void PCM_Demo3()
{
  background(0);
  translate(width/2, height/2);
  rotate(radians(TextAngle++));
  TextAngle %= 360;
  textAlign(CENTER, CENTER);
  textSize(20); // textSize(TextSize); TextSize++;
  // if (TextSize > 20)
  //   TextSize = 20;
  if (Opkomst)
  {
    TextKleur++;
    if (TextKleur > 255) {
      TextKleur = 255;
      if ((frameCounter % 1000) == (1250-255))
        Opkomst = false;
    }
  } else
  {
    TextKleur--;
    if (TextKleur < 0)
    {
      TextKleur = 0;
      Opkomst = true;
    }
  }

  fill(TextKleur);
  text("Top 40 Best Players", 0, -175);
  for (int i = 0; i < 11; i++)
  {
    if (Highscores[i+Offset1] != 0)
    {
      textAlign(LEFT, CENTER);
      text(Order[i+Offset1], -150, (i*25)-46-Offset2-55);
      text(NaamLijst[i+Offset1], -110, (i*25)-46-Offset2-55);
      textAlign(RIGHT, CENTER);
      text(Highscores[i+Offset1], 120, (i*25)-46-Offset2-55);
      text(CrownLijst[i+Offset1], 150, (i*25)-46-Offset2-55);
    }
  }
  textAlign(CENTER, CENTER);
  rectMode(CENTER);
  fill(0);
  noStroke();
  rect(0, -70-55, 300, 25);
  rect(0, 205-55, 300, 25);
  fill(255);
  text("Press a key to play!", 0, 230-55);

  Offset2++;
  if (Offset2 > 24)
  {
    Offset2 = 0;
    Offset1++;
    if (Offset1 > 49)
      Offset1 = 0;
  }

  //  println(TextKleur); // debug info
  //  println(frameCounter); // debug info
}

void PCM_Demo4() {
  background(0); //exampletest
  if (Opkomst)
  {
    TextKleur++;
    if (TextKleur > 255) {
      TextKleur = 255;
      if ((frameCounter % 1000) == (1250-255))
        Opkomst = false;
    }
  } else
  {
    TextKleur--;
    if (TextKleur < 0)
    {
      TextKleur = 0;
      Opkomst = true;
    }
  }


  perFrameGame();

  pushMatrix();
  translate(width/2, height/2);
  rotate(radians(TextAngle++));
  TextAngle %= 360;
  textAlign(CENTER, CENTER);
  textSize(20); // textSize(TextSize); TextSize++;
  // if (TextSize > 20)
  //   TextSize = 20;
  fill(TextKleur);
  text("DEMO", 0, 0);
  fill(255);
  text("Press a key to play!", 0, 230-55);
  popMatrix();
}

void perFrameGame()
{
  image(PacmanField, 0, 0); //test1
  //  image(PacmanField,28*int(width/56),0); //test2
  image(PacmanField, PacmanField.width, 0);

  //  image(PacmanSprite,312,550);

  if (!GameOver) {
    for (int i=0; i<31; i++)
    {
      for (int j=0; j<56; j++)
      {
        tiles[i][j].show();
      }
    }

    //    if (frameCounter == 3250) { // Does job of old constructor
    //      Inky.setPath();
    //      Blinky.setPath();
    //      Pinky.setPath();
    //      Clyde.setPath();
    //    }

    // Do All Displays

    if (joy3 != null)
      joy3.Display();
    if (joy4 != null)
      joy4.Display();
    if (joy1 != null)
      joy1.Display();
    if (joy2 != null)
      joy2.Display();

    /*

     if (Pinky != null)
     Pinky.Display();
     if (Clyde != null)
     Clyde.Display();
     
     // Do All Updates
     
     if (Pinky != null)
     Pinky.Update();
     if (Clyde != null)
     Clyde.Update();
     
     */

    if (joy3 != null)
      joy3.Update(); //Pacman1.Update();
    if (joy4 != null)
      joy4.Update(); //Pacman2.Update();
    if (joy1 != null)
      joy1.Update();
    if (joy2 != null)
      joy2.Update();

    /*

     if (Inky != null) {
     Inky.Display();
     Inky.Update();
     }
     
     if (Blinky != null) {
     Blinky.Display();
     Blinky.Update();
     }
     
     */

    //    Pacman1.Display();
    //    Pacman2.Display();
  }
}

void ButtonPressed() {
  buttonPressed = false;
  for (int z=TranslationConstance; z<(NumKeys+TranslationConstance); z++) {
    if (stick.getButton(z % TotalNumKeys).pressed()) {
      buttonPressed = true;
      keysPressed[z] = (int)(z + 1);
    } else
    {
      keysPressed[z] = 0;
    }
  }
}

//returns the shortest path from the start node to the finish node

Path AStar(Node start, Node finish, PVector vel)
{
  LinkedList<Path> big = new LinkedList<Path>(); // stores all paths
  Path extend = new Path(); // a temp Path which is to be extended by adding another node
  Path winningPath = new Path();  // the final path
  Path extended = new Path(); // the extended path
  LinkedList<Path> sorting = new LinkedList<Path>(); // used for sorting paths by their distance to the target

  // startin off with big storing a path with only the starting node

  extend.addToTail(start, finish);
  extend.velAtLast = new PVector(vel.x, vel.y); // used to prevent ghosts from doing a u turn
  big.add(extend);


  boolean winner = false; // has a path from start to finish been found

  while (true) {
    extend = big.pop(); // grab the front path form the big to be extended
    if (extend.path.getLast().equals(finish)) // if goal found
    {
      if (!winner) // if first goal found, set winning path
      {
        winner = true;
        winningPath = extend.clone();
      } else { // if current path found the goal in a shorter distance than the previous winner
        if (winningPath.distance > extend.distance)
        {
          winningPath = extend.clone(); // set this path as the winning path
        }
      }
      if (big.isEmpty()) // if this extend is the last path then return the winning path
      {
        return winningPath.clone();
      } else { // if not the current extend is useless to us as it cannot be extended since its finished
        extend = big.pop(); // so get the next path
      }
    }


    // if the final node in the path has already been checked and the distance to it was shorter than this path has taken to get there than this path is no good
    if (!extend.path.getLast().checked || extend.distance < extend.path.getLast().smallestDistToPoint)
    {
      if (!winner || extend.distance + dist(extend.path.getLast().x, extend.path.getLast().y, finish.x, finish.y)  < winningPath.distance) // dont look at paths that are longer than a path which has already reached the goal
      {
        // if this is the first path to reach this node or the shortest path to reach this node then set the smallest distance to this point to the distance of this path
        extend.path.getLast().smallestDistToPoint = extend.distance;

        // move all paths to sorting form big then add the new paths (in the for loop)and sort them back into big.
        sorting = (LinkedList)big.clone();
        Node tempN = new Node(0, 0); // reset temp node
        if (extend.path.size() > 1) {
          tempN = extend.path.get(extend.path.size() - 2); // set the temp node to be the second last node in the path
        }

        for (int i = 0; i < extend.path.getLast().edges.size(); i++) // for each node incident (connected) to the final node of the path to be extended
        {
          if (tempN != extend.path.getLast().edges.get(i)) // if not going backwards i.e. the new node is not the previous node behind it
          {
            // if the direction to the new node is in the opposite to the way the path was heading then dont count this path
            PVector directionToNode = new PVector( extend.path.getLast().edges.get(i).x - extend.path.getLast().x, extend.path.getLast().edges.get(i).y - extend.path.getLast().y );
            directionToNode.limit(vel.mag());
            if (directionToNode.x == -1* extend.velAtLast.x && directionToNode.y == -1* extend.velAtLast.y ) {
            } else { // if not turning around
              extended = extend.clone();
              extended.addToTail(extend.path.getLast().edges.get(i), finish);
              extended.velAtLast = new PVector(directionToNode.x, directionToNode.y);
              sorting.add(extended.clone()); // add this extended list to the list of paths to be sorted
            }
          }
        }


        // sorting now contains all the paths form big plus the new paths which where extended
        // adding the path which has the higest distance to big first so that its at the back of big.
        // using selection sort i.e. the easiest and worst sorting algorithm

        big.clear();
        while (!sorting.isEmpty())
        {
          float max = -1;
          int iMax = 0;
          for (int i = 0; i < sorting.size(); i++)
          {
            if (max < sorting.get(i).distance + sorting.get(i).distToFinish) // A* uses the distance from the goal plus the paths length to determine the sorting order
            {
              iMax = i;
              max = sorting.get(i).distance + sorting.get(i).distToFinish;
            }
          }
          //          big.addFirst(sorting.remove(iMax).clone()); // add it to the front so that the ones with the greatest distance end up at the back
          big.addFirst(sorting.get(iMax));
          sorting.remove(iMax);
          // and the closest ones end up at the front
        }
      }
      extend.path.getLast().checked = true;
    }
    // if no more paths avaliable
    if (big.isEmpty()) {
      if (winner == false) // there is not path from start to finish
      {
        print("FUCK!!!!!!!!!!"); // error message
        return null;
      } else { // if winner is found then the shortest winner is stored in winning path so return that
        return winningPath.clone();
      }
    }
  } // End while(true)
} // End of AStar()

// returns the nearest non wall tile to the input vector
// input is in tile coordinates

PVector getNearestNonWallTile(PVector target) {
  float min = 1000;
  int minIndexj = 0;
  int minIndexi = 0;

  for (int i = 0; i < 56; i++) { // for each tile
    for (int j = 0; j < 31; j++) {
      if (!tiles[j][i].wall) { // if its not a wall
        if (dist(i, j, target.x, target.y) < min) { // if its the current closest to target
          min = dist(i, j, target.x, target.y);
          minIndexj = j;
          minIndexi = i;
        }
      }
    }
  }
  return new PVector(minIndexi, minIndexj); // return a PVector to the tile
}

class PacMan
{
  PVector pos = new PVector(1, 0); // null; // int x,y;
  int w, h;
  int score; // int score = 0;
  int lives = 1;
  color Color;
  PVector vel = new PVector(-1, 0);
  PVector turnTo = new PVector(-1, 0);
  boolean turn = false;
  boolean gameover = false;
  boolean JustEaten = false;
  Shooting shootKa = null;
  
  PacMan(int tx, int ty, int tw, int th, color tColor)
  {
    pos = new PVector(tx, ty); // x = tx;
    // y = ty;
    w = tw;
    h = th;
    Color = tColor;
    score = 0;
    shootKa = null;
    gameover = false;
  }

  void Display()
  {
    if (shootKa != null)
      shootKa.Display();
    fill(Color);
    if (((JustEaten)&&((frameCounter & 1) == 0)) || (!JustEaten)) {
      //     println(int(atan2(vel.y,vel.x)/HALF_PI)+1);
      switch(int(atan2(vel.y, vel.x)/HALF_PI)+1)
      {
      case 2: // going down?!
        pushMatrix();
        translate(pos.x, pos.y);
        rotate(-HALF_PI);
        arc(0, 0, w*PFScaleX, h*PFScaleY, radians(-150), radians(150), 0);
        popMatrix();
        println("down"); // debug info
        break;
      case 3: // going to the left?!
        pushMatrix();
        translate(pos.x, pos.y);
        rotate(0);
        arc(0, 0, w*PFScaleX, h*PFScaleY, radians(-150), radians(150), 0);
        popMatrix();
        println("left"); // debug info
        break;
      case 0: // going up?!
        pushMatrix();
        translate(pos.x, pos.y);
        rotate(HALF_PI);
        arc(0, 0, w*PFScaleX, h*PFScaleY, radians(-150), radians(150), 0);
        popMatrix();
        println("up"); // debug info
        break;
      case 1: // going right?!
        pushMatrix();
        translate(pos.x, pos.y);
        rotate(PI);
        arc(0, 0, w*PFScaleX, h*PFScaleY, radians(-150), radians(150), 0);
        popMatrix();
        println("right"); // debug info
        break;
      }
    }
    else { //if (JustEaten) {
      if ((JustEaten)&&(frameCounter & 1) == 1)
        ellipse(pos.x, pos.y, w*PFScaleX, h*PFScaleY);
      if ((JustEaten)&&(frameCounter & 15) == 7)
        JustEaten = false;
    }
  }

  void Update()
  {
    if (shootKa != null)
      shootKa.Update();
    
    if ((pos.x) < (floor(width/112))) {
      pos.x = (((55*floor(width/(2*28)))+floor(width/112))); // - vel.x);
    } else if ((pos.x) > ((55*floor(width/(2*28)))+floor(width/112))) {
      pos.x = (((0*floor(width/(2*28)))+floor(width/112))); // - vel.x);
    }

    if ((pos.y) < (floor(height/62))) {
      pos.y = (((30*floor(height/31))+floor(height/62)));
    } else if ((pos.y) > ((30*floor(height/31))+floor(height/62))) {
      pos.y = (((0*floor(height/31))+floor(height/62)));
    }

    if ((HumanPlayer[0]) && (joy3.PlayerIsPacman == this)) {
      if (stick.getButton(LinksToetsen[0]).pressed()) {
        Lampjes |= (1L<<(LinksToetsen[0]-TranslationConstance));
        turnTo.x = -1;
        turnTo.y = 0;
      }
      if (stick.getButton(VuurKnoppen[0]).pressed()) {
        Lampjes |= (1L<<(VuurKnoppen[0]-TranslationConstance));
        if (shootKa == null)
          shootKa = new Shooting(pos.x,pos.y,10,10,2*vel.x,2*vel.y);
        else
          {
            if ((shootKa.x < 0)||(shootKa.x > width)||(shootKa.y < 0)||(shootKa.y > height))
              shootKa = null;
          }
      }
      if (stick.getButton(RechtsToetsen[0]).pressed()) {
        Lampjes |= (1L<<(RechtsToetsen[0]-TranslationConstance));
        turnTo.x = 1;
        turnTo.y = 0;
      }
      if (stick.getButton(PlusToetsen[0]).pressed()) {
        Lampjes |= (1L<<(PlusToetsen[0]-TranslationConstance));
        turnTo.x = 0;
        turnTo.y = -1;
      }
      if (stick.getButton(MinToetsen[0]).pressed()) {
        Lampjes |= (1L<<(MinToetsen[0]-TranslationConstance));
        turnTo.x = 0;
        turnTo.y = 1;
      }
    }

    if ((HumanPlayer[1]) && (joy4.PlayerIsPacman == this)) {
      if (stick.getButton(LinksToetsen[1]).pressed()) {
        Lampjes |= (1L<<(LinksToetsen[1]-TranslationConstance));
        turnTo.x = 0;
        turnTo.y = 1;
      }
      if (stick.getButton(VuurKnoppen[1]).pressed()) {
        Lampjes |= (1L<<(VuurKnoppen[1]-TranslationConstance));
        if (shootKa == null)
          shootKa = new Shooting(pos.x,pos.y,10,10,2*vel.x,2*vel.y);
        else
          {
            if ((shootKa.x < 0)||(shootKa.x > width)||(shootKa.y < 0)||(shootKa.y > height))
              shootKa = null;
          }
      }
      if (stick.getButton(RechtsToetsen[1]).pressed()) {
        Lampjes |= (1L<<(RechtsToetsen[1]-TranslationConstance));
        turnTo.x = 0;
        turnTo.y = -1;
      }
      if (stick.getButton(PlusToetsen[1]).pressed()) {
        Lampjes |= (1L<<(PlusToetsen[1]-TranslationConstance));
        turnTo.x = -1;
        turnTo.y = 0;
      }
      if (stick.getButton(MinToetsen[1]).pressed()) {
        Lampjes |= (1L<<(MinToetsen[1]-TranslationConstance));
        turnTo.x = 1;
        turnTo.y = 0;
      }
    }

    if ((HumanPlayer[2]) && (joy1.PlayerIsPacman == this)) {
      if (stick.getButton(LinksToetsen[2]).pressed()) {
        Lampjes |= (1L<<(LinksToetsen[2]-TranslationConstance));
        turnTo.x = 1;
        turnTo.y = 0;
      }
      if (stick.getButton(VuurKnoppen[2]).pressed()) {
        Lampjes |= (1L<<(VuurKnoppen[2]-TranslationConstance));
        if (shootKa == null)
          shootKa = new Shooting(pos.x,pos.y,10,10,2*vel.x,2*vel.y);
        else
          {
            if ((shootKa.x < 0)||(shootKa.x > width)||(shootKa.y < 0)||(shootKa.y > height))
              shootKa = null;
          }
      }
      if (stick.getButton(RechtsToetsen[2]).pressed()) {
        Lampjes |= (1L<<(RechtsToetsen[2]-TranslationConstance));
        turnTo.x = -1;
        turnTo.y = 0;
      }
      if (stick.getButton(PlusToetsen[2]).pressed()) {
        Lampjes |= (1L<<(PlusToetsen[2]-TranslationConstance));
        turnTo.x = 0;
        turnTo.y = 1;
      }
      if (stick.getButton(MinToetsen[2]).pressed()) {
        Lampjes |= (1L<<(MinToetsen[2]-TranslationConstance));
        turnTo.x = 0;
        turnTo.y = -1;
      }
    }

    if ((HumanPlayer[3]) && (joy2.PlayerIsPacman == this)) {
      if (stick.getButton(LinksToetsen[3]).pressed()) {
        Lampjes |= (1L<<(LinksToetsen[3]-TranslationConstance));
        turnTo.x = 0;
        turnTo.y = -1;
      }
      if (stick.getButton(VuurKnoppen[3]).pressed()) {
        Lampjes |= (1L<<(VuurKnoppen[3]-TranslationConstance));
        if (shootKa == null)
          shootKa = new Shooting(pos.x,pos.y,10,10,2*vel.x,2*vel.y);
        else
          {
            if ((shootKa.x < 0)||(shootKa.x > width)||(shootKa.y < 0)||(shootKa.y > height))
              shootKa = null;
          }
      }
      if (stick.getButton(RechtsToetsen[3]).pressed()) {
        Lampjes |= (1L<<(RechtsToetsen[3]-TranslationConstance));
        turnTo.x = 0;
        turnTo.y = 1;
      }
      if (stick.getButton(PlusToetsen[3]).pressed()) {
        Lampjes |= (1L<<(PlusToetsen[3]-TranslationConstance));
        turnTo.x = 1;
        turnTo.y = 0;
      }
      if (stick.getButton(MinToetsen[3]).pressed()) {
        Lampjes |= (1L<<(MinToetsen[3]-TranslationConstance));
        turnTo.x = -1;
        turnTo.y = 0;
      }
    }

    if (checkPosition()) {
      pos.add(vel);
    }
  } // end of Pacman.Update()

  boolean checkPosition()
  {
    if ((((pos.x - floor(width/112)) % floor(width / (2*28))) == 0) && (((pos.y - floor(height/62)) % floor(height/31)) == 0)) { // if on a critical position

      PVector matrixPosition = new PVector(abs(floor(((pos.x - floor(width/112)) / floor(width/(2*28)))))%56, abs(floor(((pos.y - floor(height/62)) / floor(height/31))))%31); // convert position to an array position

      // reset all the paths for all the ghosts

      //      Blinky.setPath();
      //      Pinky.setPath();
      //      Clyde.setPath();
      //      Inky.setPath();
      Joystick Joys[] = {joy3, joy4, joy1, joy2};
      Joys[0] = joy3;
      Joys[1] = joy4;
      Joys[2] = joy1;
      Joys[3] = joy2;
      for (int i=0; i<4; i++) {
        if (Joys[i].PlayerIsGhost != null) {
          Joys[i].PlayerIsGhost.setPath();
        }
        if (Joys[i].AIGhost != null)
          Joys[i].AIGhost.setPath();
      }

      // check if the position has been eaten or not, note the blank spaces are initialised as already eaten

      if (!tiles[floor(matrixPosition.y)][floor(matrixPosition.x)].eaten) {
        tiles[floor(matrixPosition.y)][floor(matrixPosition.x)].eaten = true;
        score += 1; //add a point
        JustEaten = true;
        println(this, " Score: ", score);
        if (tiles[floor(matrixPosition.y)][floor(matrixPosition.x)].bigDot) { // if big dot eaten
          // set all ghosts to frightened
          score += 9; // should be 9
          BigDotSound.trigger(); // power-up sound
          Blinky.frightened = true;
          Blinky.flashCount = 0;
          Clyde.frightened = true;
          Clyde.flashCount = 0;
          Pinky.frightened = true;
          Pinky.flashCount = 0;
          Inky.frightened = true;
          Inky.flashCount = 0;
          //          Joystick Joys[] = {joy3,joy4,joy1,joy2};
          Joys[0] = joy3;
          Joys[1] = joy4;
          Joys[2] = joy1;
          Joys[3] = joy2;
          for (int i=0; i<4; i++) {
            if (Joys[i].PlayerIsGhost != null) {
              Joys[i].PlayerIsGhost.frightened = true;
              Joys[i].PlayerIsGhost.flashCount = 0;
            }
            if (Joys[i].AIGhost != null) {
              Joys[i].AIGhost.frightened = true;
              Joys[i].AIGhost.flashCount = 0;
            }
          }
        } else
          SmallDotSound.trigger();
      }


      PVector positionToCheck = new PVector(abs(floor(matrixPosition.x + turnTo.x))%56, abs(floor(matrixPosition.y + turnTo.y))%31); // the position in the tiles double array that the player is turning towards

      if (tiles[floor(positionToCheck.y)%31][floor(positionToCheck.x)%56].wall) { // check if there is a free space in the direction that it is going to turn
        if (tiles[abs(floor(matrixPosition.y + vel.y))%31][abs(floor(matrixPosition.x + vel.x))%56].wall) { // if not check if the path ahead is free
          return false; // if neither are free then dont move
        } else { // forward is free
          return true;
        }
      } else { // free to turn
        vel = new PVector(turnTo.x, turnTo.y);
        return true;
      }
    } else {
      if ((((pos.x+(10*vel.x) - floor(width/112)) % floor(width/(2*28))) == 0) && (((pos.y + (10*vel.y) - floor(height/62)) % floor(height/31)) == 0)) { // if 10 places off a critical position in the direction that pacman is moving
        PVector matrixPosition = new PVector(abs(floor(((pos.x+(10*vel.x)-floor(width/112)) / floor(width/(2*28)))))%56, abs(floor(((pos.y+(10*vel.y)-floor(height/62)) / floor(height/31))))%31); // convert that position to an array position
        if (!tiles[floor(matrixPosition.y)][floor(matrixPosition.x)].eaten ) { // if that tile has not been eaten
          tiles[floor(matrixPosition.y)][floor(matrixPosition.x)].eaten = true; // eat it
          score += 1;
          JustEaten = true;
          println(this, " Score: ", score);
          if (tiles[floor(matrixPosition.y)][floor(matrixPosition.x)].bigDot) { // big dot eaten
            // set all ghosts as frightened
            score += 9;
            BigDotSound.trigger();
            Blinky.frightened = true;
            Blinky.flashCount = 0;
            Clyde.frightened = true;
            Clyde.flashCount = 0;
            Pinky.frightened = true;
            Pinky.flashCount = 0;
            Inky.frightened = true;
            Inky.flashCount = 0;
            Joystick Joys[] = {joy3, joy4, joy1, joy2};
            Joys[0] = joy3;
            Joys[1] = joy4;
            Joys[2] = joy1;
            Joys[3] = joy2;
            for (int i=0; i<4; i++) {
              if (Joys[i].PlayerIsGhost != null) {
                Joys[i].PlayerIsGhost.frightened = true;
                Joys[i].PlayerIsGhost.flashCount = 0;
              }
              if (Joys[i].AIGhost != null) {
                Joys[i].AIGhost.frightened = true;
                Joys[i].AIGhost.flashCount = 0;
              }
            }
          } else
            SmallDotSound.trigger();
        }
      }
      if ((turnTo.x + vel.x == 0) && (vel.y + turnTo.y == 0)) { // if turning chenging directions entirely i.e. 180 degree turn
        vel = new PVector(turnTo.x, turnTo.y); // turn
        return true;
      }
      return true; // if not on a critical postion then continue forward
    }
  }

  void kill()
  {
    lives--; // respond with pos reset?!
    if (lives == 0) {
      gameover = true;
      GameOver = true;
    }
  }

  boolean hitPacman(PVector tpos)
  {
    if (dist(tpos.x, tpos.y, pos.x, pos.y) < 10) {
      return true;
    }
    return false;
  }
} // End of class Pacman

int BonusMultiplier = 1;

class Ghost
{
  PVector pos = new PVector(13*floor(width/(2*28))+floor(width/112), 14*floor(height/31)+floor(height/62)); // int x,y;
  int w, h;
  color Color;
  int score = 0;

  boolean returnHome = false;
  boolean chase = true;
  boolean frightened = false;
  boolean deadForABit = false;
  boolean GhostExploded = false;
  int deadCount = 0, chaseCount = 0, flashCount = 0;

  PVector vel = new PVector(-1, 0);
  PVector turnTo = new PVector(0, 0);
  Path bestPath = new Path(); // the variable stores the path the ghost will be following
  ArrayList<Node> ghostNodes = new ArrayList<Node>(); // the nodes making up the path including the ghosts position and the target position
  Node start; // the ghosts position as a node
  Node end; // the ghosts target position as a node

  Ghost(int tx, int ty, int tw, int th, color tColor)
  {
    pos = new PVector(tx, ty); // pos.x = tx;
    // pos.y = ty;
    w = tw;
    h = th;
    Color = tColor;

    GhostExploded = false;

    returnHome = false;

    setPath();
  }

  BonusToolTip bonus = null;

  void Display()
  {
    //     fill(Color);
    //     if (bestPath != null)
    //       bestPath.show();
    //     ellipse(pos.x,pos.y,w,h);

    // increments counts
    chaseCount++;
    if (chase) {
      if (chaseCount > 2000) {
        chase = false;
        chaseCount = 0;
      }
    } else {
      if (chaseCount > 700) {
        chase = true;
        chaseCount = 0;
      }
    }

    if (deadForABit) {
      deadCount++;
      if (deadCount > 300) {
        deadForABit = false;
      }
    } else { // if not deadforabit then show the ghost
      if (!frightened) {
        if (returnHome) { // have the ghost be transparent if on its way home
          stroke(Color, 100);
          fill(Color, 100);
          if (bonus == null)
          {
            bonus = new BonusToolTip(Color, (BonusMultiplier * 200), pos.x, pos.y);
            score = (BonusMultiplier * 200); // was score += (BonusMultiplier * 200);
            println(this, " Ghost Score: ", score);
            Joystick Joys[] = {joy3, joy4, joy1, joy2};
            Joys[0]=joy3;
            Joys[1]=joy4;
            Joys[2]=joy1;
            Joys[3]=joy2;
            for (int i=0; i<4; i++) {
              if (Joys[i] != null) {
                if (Joys[i].PlayerIsPacman != null) {
                  if (NumPacMans == 1) {
                    Joys[i].PlayerIsPacman.score += score;
                    continue;
                  } else {
                    if (NumPacMans == 2) { // which pacman has the bonus?
                      if ((dist(pos.x, pos.y, Joys[i].PlayerIsPacman.pos.x, Joys[i].PlayerIsPacman.pos.y) < 10)) // pos.x == Joys[i].PlayerIsPacman.pos.x) && (pos.y == Joys[i].PlayerIsPacman.pos.y))
                      { // Perhaps we should find a solution which uses hitpacman() ?!
                        Joys[i].PlayerIsPacman.score += score;
                        continue;
                      } else {
                        ; // do nothing here, but we do need an error margin
                      }
                    }
                  }
                }
              }
            }
            BonusMultiplier++;
          }
          if (bonus != null)
          {
            bonus.Display();
            bonus.Update();
            fill(Color, 100);
          }
        } else { // colour the ghost
          stroke(Color);
          fill(Color);
        }
        if (bestPath != null)
          if (bestPath.path.size() > 0)
            bestPath.show(); // show the path the ghost is following
      } else { // if frightened
        flashCount++;
        if (flashCount > 800) { // after 8 seconds the ghosts are no longer frightened
          frightened = false;
          flashCount = 0;
        }

        if (floor(flashCount / 30) % 2 == 0) { // make it flash white and blue every 30 frames
          stroke(255);
          fill(255);
        } else { // flash blue
          stroke(0, 0, 200);
          fill(0, 0, 200);
        }
      }
      if (GhostExploded == false) {
        ellipse(pos.x, pos.y, w*PFScaleX, h*PFScaleY);
      }
      if (GhostExploded == true) {
        frightened = true;
        flashCount = 0;
        strokeWeight(3);
        noFill();
        ellipse(pos.x,pos.y,w*PFScaleX,h*PFScaleY);
        w++;h++;
        if ((w > 255) || (h > 255)) {
          w=32;h=32;frightened = false;GhostExploded = false;flashCount = 0;
          stroke(Color,255);fill(Color,255);
        }
      }
    }
  } // End of Ghost.Display()

  void Update()
  {
    float x, y;

    /*
    
     if ((HumanPlayer[0]) && (joy3.PlayerIsGhost == this)) {
     if (stick.getButton(LinksToetsen[0]).pressed()) {
     vel.x = -1;
     vel.y = 0;
     }
     if (stick.getButton(RechtsToetsen[0]).pressed()) {
     vel.x = 1;
     vel.y = 0;
     }
     if (stick.getButton(PlusToetsen[0]).pressed()) {
     vel.x = 0;
     vel.y = -1;
     }
     if (stick.getButton(MinToetsen[0]).pressed()) {
     vel.x = 0;
     vel.y = 1;
     }
     }
     
     if ((HumanPlayer[1]) && (joy4.PlayerIsGhost == this)) {
     if (stick.getButton(LinksToetsen[1]).pressed()) {
     vel.x = -1;
     vel.y = 0;
     }
     if (stick.getButton(RechtsToetsen[1]).pressed()) {
     vel.x = 1;
     vel.y = 0;
     }
     if (stick.getButton(PlusToetsen[1]).pressed()) {
     vel.x = 0;
     vel.y = -1;
     }
     if (stick.getButton(MinToetsen[1]).pressed()) {
     vel.x = 0;
     vel.y = 1;
     }
     }
     
     if ((HumanPlayer[2]) && (joy1.PlayerIsGhost == this)) {
     if (stick.getButton(LinksToetsen[2]).pressed()) {
     vel.x = -1;
     vel.y = 0;
     }
     if (stick.getButton(RechtsToetsen[2]).pressed()) {
     vel.x = 1;
     vel.y = 0;
     }
     if (stick.getButton(PlusToetsen[2]).pressed()) {
     vel.x = 0;
     vel.y = -1;
     }
     if (stick.getButton(MinToetsen[2]).pressed()) {
     vel.x = 0;
     vel.y = 1;
     }
     }
     
     if ((HumanPlayer[3]) && (joy2.PlayerIsGhost == this)) {
     if (stick.getButton(LinksToetsen[3]).pressed()) {
     vel.x = -1;
     vel.y = 0;
     }
     if (stick.getButton(RechtsToetsen[3]).pressed()) {
     vel.x = 1;
     vel.y = 0;
     }
     if (stick.getButton(PlusToetsen[3]).pressed()) {
     vel.x = 0;
     vel.y = -1;
     }
     if (stick.getButton(MinToetsen[3]).pressed()) {
     vel.x = 0;
     vel.y = 1;
     }
     }
     
     */

    if (!deadForABit) { //dont move if dead
      //      pos.add(vel);

      x = (pos.x);
      y = (pos.y);

      if ((x) < (floor(width/112))) {
        x = ((55*floor(width/(2*28)))+(floor(width/112))); // - vel.x;
      } else {
        if ((x) > (55*floor(width/(2*28))+(floor(width/112)))) {
          x = ((0*floor(width/(2*28)))+(floor(width/112))); // - vel.x;
        }
      }

      if ((y) < (floor(height/62))) {
        y = ((30*floor(height/31))+(floor(height/62)));
      } else {
        if ((y) > ((30*floor(height/31))+floor(height/62))) {
          y = ((0*floor(height/31))+(floor(height/62)));
        }
      }
      pos = new PVector(x, y);

      //    turnTo = new PVector(0,0);

      if ((HumanPlayer[0]) && (joy3.PlayerIsGhost == this)) {
        if (stick.getButton(LinksToetsen[0]).pressed()) {
          //        newVel.x = -1;
          //        newVel.y = 0;
          turnTo = new PVector(-1, 0);
          Lampjes |= (1L<<(LinksToetsen[0]-TranslationConstance));
          //        vel = new PVector(-1,0);
          //        pos.add(vel);
          if (checkDir())
            pos.add(vel);
        }
        if (stick.getButton(RechtsToetsen[0]).pressed()) {
          //        newVel.x = 1;
          //        newVel.y = 0;
          turnTo = new PVector(1, 0);
          Lampjes |= (1L<<(RechtsToetsen[0]-TranslationConstance));
          //        vel = new PVector(1,0);
          //        pos.add(vel);
          if (checkDir())
            pos.add(vel);
        }
        if (stick.getButton(PlusToetsen[0]).pressed()) {
          //        newVel.x = 0;
          //        newVel.y = -1;
          turnTo = new PVector(0, -1);
          Lampjes |= (1L<<(PlusToetsen[0]-TranslationConstance));
          //        vel = new PVector(0,-1);
          //        pos.add(vel);
          if (checkDir())
            pos.add(vel);
        }
        if (stick.getButton(MinToetsen[0]).pressed()) {
          //        newVel.x = 0;
          //        newVel.y = 1;
          turnTo = new PVector(0, 1);
          Lampjes |= (1L<<(MinToetsen[0]-TranslationConstance));
          //        vel = new PVector(0,1);
          //        pos.add(vel);
          if (checkDir())
            pos.add(vel);
        }
        checkDirection();
      }
      //    else {
      if ((HumanPlayer[1]) && (joy4.PlayerIsGhost == this)) {
        if (stick.getButton(LinksToetsen[1]).pressed()) {
          //        newVel.x = -1;
          //        newVel.y = 0;
          turnTo = new PVector(0, 1);
          Lampjes |= (1L<<(LinksToetsen[1]-TranslationConstance));
          //        vel = new PVector(0,1);
          //        pos.add(vel);
          if (checkDir())
            pos.add(vel);
        }
        if (stick.getButton(RechtsToetsen[1]).pressed()) {
          //        newVel.x = 1;
          //        newVel.y = 0;
          turnTo = new PVector(0, -1);
          Lampjes |= (1L<<(RechtsToetsen[1]-TranslationConstance));
          //        vel = new PVector(0,-1);
          //        pos.add(vel);
          if (checkDir())
            pos.add(vel);
        }
        if (stick.getButton(PlusToetsen[1]).pressed()) {
          //        newVel.x = 0;
          //        newVel.y = -1;
          turnTo = new PVector(-1, 0);
          Lampjes |= (1L<<(PlusToetsen[1]-TranslationConstance));
          //        vel = new PVector(-1,0);
          //        pos.add(vel);
          if (checkDir())
            pos.add(vel);
        }
        if (stick.getButton(MinToetsen[1]).pressed()) {
          //        newVel.x = 0;
          //        newVel.y = 1;
          turnTo = new PVector(1, 0);
          Lampjes |= (1L<<(MinToetsen[1]-TranslationConstance));
          //        vel = new PVector(1,0);
          //        pos.add(vel);
          if (checkDir())
            pos.add(vel);
        }
        checkDirection();
      }
      //    else {
      if ((HumanPlayer[2]) && (joy1.PlayerIsGhost == this)) {
        if (stick.getButton(LinksToetsen[2]).pressed()) {
          //        newVel.x = -1;
          //        newVel.y = 0;
          turnTo = new PVector(1, 0);
          Lampjes |= (1L<<(LinksToetsen[2]-TranslationConstance));
          //        vel = new PVector(1,0);
          //        pos.add(vel);
          if (checkDir())
            pos.add(vel);
        }
        if (stick.getButton(RechtsToetsen[2]).pressed()) {
          //        newVel.x = 1;
          //        newVel.y = 0;
          turnTo = new PVector(-1, 0);
          Lampjes |= (1L<<(RechtsToetsen[2]-TranslationConstance));
          //        vel = new PVector(-1,0);
          //        pos.add(vel);
          if (checkDir())
            pos.add(vel);
        }
        if (stick.getButton(PlusToetsen[2]).pressed()) {
          //        newVel.x = 0;
          //        newVel.y = -1;
          turnTo = new PVector(0, 1);
          Lampjes |= (1L<<(PlusToetsen[2]-TranslationConstance));
          //        vel = new PVector(0,1);
          //        pos.add(vel);
          if (checkDir())
            pos.add(vel);
        }
        if (stick.getButton(MinToetsen[2]).pressed()) {
          //        newVel.x = 0;
          //        newVel.y = 1;
          turnTo = new PVector(0, -1);
          Lampjes |= (1L<<(MinToetsen[2]-TranslationConstance));
          //        vel = new PVector(0,-1);
          //        pos.add(vel);
          if (checkDir())
            pos.add(vel);
        }
        checkDirection();
      }
      //    else {
      if ((HumanPlayer[3]) && (joy2.PlayerIsGhost == this)) {
        if (stick.getButton(LinksToetsen[3]).pressed()) {
          //        newVel.x = -1;
          //        newVel.y = 0;
          turnTo = new PVector(0, -1);
          Lampjes |= (1L<<(LinksToetsen[3]-TranslationConstance));
          //        vel = new PVector(0,-1);
          //        pos.add(vel);
          if (checkDir())
            pos.add(vel);
        }
        if (stick.getButton(RechtsToetsen[3]).pressed()) {
          //        newVel.x = 1;
          //        newVel.y = 0;
          turnTo = new PVector(0, 1);
          Lampjes |= (1L<<(RechtsToetsen[3]-TranslationConstance));
          //        vel = new PVector(0,1);
          //        pos.add(vel);
          if (checkDir())
            pos.add(vel);
        }
        if (stick.getButton(PlusToetsen[3]).pressed()) {
          //        newVel.x = 0;
          //        newVel.y = -1;
          turnTo = new PVector(1, 0);
          Lampjes |= (1L<<(PlusToetsen[3]-TranslationConstance));
          //        vel = new PVector(1,0);
          //        pos.add(vel);
          if (checkDir())
            pos.add(vel);
        }
        if (stick.getButton(MinToetsen[3]).pressed()) {
          //        newVel.x = 0;
          //        newVel.y = 1;
          turnTo = new PVector(-1, 0);
          Lampjes |= (1L<<(MinToetsen[3]-TranslationConstance));
          //        vel = new PVector(-1,0);
          //        pos.add(vel);
          if (checkDir())
            pos.add(vel);
        }
        checkDirection();
      }
      //    else {
      //      pos.add(vel);
      //      if (checkDir())
      if (((!HumanPlayer[0])&&(joy3.AIGhost==this))||((!HumanPlayer[1])&&(joy4.AIGhost==this))||((!HumanPlayer[2])&&(joy1.AIGhost==this))||((!HumanPlayer[3])&&(joy2.AIGhost==this)))
        pos.add(vel); // Add AI movement
      checkDirection();
      //    }}}}
      //     if (checkDir()) { // check if need to change direction next move
      //       pos.add(vel);
      //     }
      //     checkDirection();
    }
  }  // End of Ghost.Update()

  //--------------------------------------------------------------------------------------------------------------------------------------------------

  boolean checkDir() {
    if (((((int)(pos.x-floor(width/112))+(int)0)%floor(width/56)) == 0) && (((int)(pos.y-floor(height/62))+(int)0)%floor(height/31)) == 0)
    {
      PVector matrixPosition = new PVector(abs(floor(pos.x-floor(width/112))/floor(width/56))%56, abs(floor(pos.y-floor(height/62))/floor(height/31))%31);

      if (tiles[(abs((int)matrixPosition.y+(int)turnTo.y))%31][(abs((int)matrixPosition.x+(int)turnTo.x))%56].wall) {
        if (tiles[(abs((int)matrixPosition.y+(int)vel.y))%31][(abs((int)matrixPosition.x+(int)vel.x))%56].wall) {
          return(false); // mag niet worden uitgevoerd
        } else {
          return(true);
        }
      } else {
        vel = new PVector(turnTo.x, turnTo.y);
        return(true);
      }
    } else {
      //      vel = new PVector(turnTo.x,turnTo.y);
      if (((turnTo.x + vel.x) == 0) && ((turnTo.y + vel.y) == 0)) {
        if ((turnTo.x == 0) && (turnTo.y == 0)) {
          vel = new PVector(turnTo.x, turnTo.y);
          return(true);
        } else {
          vel = new PVector(turnTo.x, turnTo.y);
        }
        return(true);
      } else {
        if ((turnTo.x == 0)&&(turnTo.y == 0)) {
          vel = new PVector(turnTo.x, turnTo.y);
        }
        return(true);
      }
    }
  } // End of Ghost.checkDir()

  // calculates a path from the first node in ghost nodes to the last node in ghostNodes and sets it as best path

  void setPath() {
    ghostNodes.clear();
    setNodes();
    start = ghostNodes.get(0);
    end = ghostNodes.get(ghostNodes.size()-1);
    Path temp = AStar(start, end, vel);
    if (temp != null) { // if not path is found then dont change bestPath
      bestPath = temp.clone();
    }
  } // End of Ghost.setPath()

  //--------------------------------------------------------------------------------------------------------------------------------------------------
  // sets all the nodes and connects them with adjacent nodes
  // also sets the target node

  void setNodes() {
    ghostNodes.add(new Node((pos.x-floor(width/112)) / floor(width/(2*28)), (pos.y-floor(height/62)) / floor(height/31))); // add the current position as a node
    for (int i = 1; i < 55; i++) { // check every position
      for (int j = 1; j < 30; j++) {
        // if there is a space up or below and a space left or right then this space is a node
        if (!tiles[j][i].wall) {
          if (!tiles[j-1][i].wall || !tiles[j+1][i].wall) { // check up for space
            if (!tiles[j][i-1].wall || !tiles[j][i+1].wall) { // check left and right for space

              ghostNodes.add(new Node(i, j)); // add the nodes
            }
          }
        }
      }
    }
    if (returnHome) { // if returning home then the target is just above the ghost room thing
      ghostNodes.add(new Node(13, 14));
    } else {
      if (chase) {
        Joystick Joys[] = {joy3, joy4, joy1, joy2};

        Joys[0] = joy3;
        Joys[1] = joy4;
        Joys[2] = joy1;
        Joys[3] = joy2;

        for (int i=0; i<4; i++) {
          PacMan Pacman = null;

          if (Joys[i] != null)
          {
            //          if (joy3!=null) {
            //            Pacman = joy3.PlayerIsPacman;
            Pacman = Joys[i].PlayerIsPacman; // = joy3.PlayerIsPacman;

            if (Pacman != null) {
              if (Pacman.pos != null) {
                ghostNodes.add(new Node((Pacman.pos.x-floor(width/112)) / floor(width/(2*28)), (Pacman.pos.y-floor(height/62)) / floor(height/31))); // target pacman
              }
            } else {
              Pacman = Joys[i].AIPacman;
              if (Pacman != null) {
                if (Pacman.pos != null) {
                  ghostNodes.add(new Node((Pacman.pos.x-floor(width/112)) / floor(width/(2*28)), (Pacman.pos.y-floor(height/62)) / floor(height/31))); // target pacman
                }
              }
            }
          }
          //           }
        }
      } else {
        ghostNodes.add(new Node(13, 14)); // scatter to corner, nope, to their homebase
      }
    }

    for (int i = 0; i < ghostNodes.size(); i++) { // connect all the nodes together
      ghostNodes.get(i).addEdges(ghostNodes);
    }
  } // End of Ghost.setNodes()

  //--------------------------------------------------------------------------------------------------------------------------------------------------
  // check if the ghost needs to change direction as well as other stuff

  void checkDirection() {
    //    PacMan Pacman1 = joy3.PlayerIsPacman;
    Joystick Joys[] = {joy3, joy4, joy1, joy2};

    Joys[0] = joy3;
    Joys[1] = joy4;
    Joys[2] = joy1;
    Joys[3] = joy2;
    for (int i=0; i<4; i++)
    {
      PacMan Pacman = null;
      if (Joys[i] != null) {
        Pacman = Joys[i].PlayerIsPacman;

        if (Pacman != null)
        {
          if (Pacman.hitPacman(pos)) { // if hit pacman
            //          if (Joys[i].PlayerIsGhost != null) {
            if (frightened) { // eaten by pacman
              returnHome = true;
              frightened = false;
            } else if (!returnHome) { // killPacman
              Pacman.kill();
            }
          }
          //        }
        } else {
          Pacman = Joys[i].AIPacman;
          if (Pacman != null)
          {
            if (Pacman.hitPacman(pos)) { // if hit pacman
              //            if (Joys[i].PlayerIsGhost != null) {
              if (frightened) { // eaten by pacman
                returnHome = true;
                frightened = false;
              } else if (!returnHome) { // killPacman
                Pacman.kill();
              }
            }
            //          }
          }
        }
      }
    }

    // check if reached home yet

    if (returnHome) {
      if (dist(floor((pos.x-floor(width/112)) / floor(width/(2*28))), floor((pos.y-floor(height/62)) / floor(height/31)), 13, 14) < 1) {
        // set the ghost as dead for a bit
        returnHome = false;
        deadForABit = true;
        deadCount = 0;
        bonus = null;
      }
    }

    if (((pos.x-floor(width/112)) % floor(width/(2*28)) == 0) && ((pos.y - floor(height/62)) % floor(height/31) == 0)) { // if on a critical position

      PVector matrixPosition = new PVector(abs(floor(((pos.x-floor(width/112)) / floor(width/(2*28)))))%56, abs(floor(((pos.y-floor(height/62)) / floor(height/31))))%31); // convert position to an array position

      if (frightened) { // no path needs to generated by the ghost if frightened
        boolean isNode = false;
        for (int j = 0; j < ghostNodes.size(); j++) {
          if ((matrixPosition.x == ghostNodes.get(j).x) && (matrixPosition.y == ghostNodes.get(j).y)) {
            isNode = true;
          }
        }
        if (!isNode) { // if not on a node then no need to do anything
          return;
        } else { // if on a node, set a random direction
          PVector newVel = new PVector();
          //          int rand = floor(random(4));
          do {
            switch(floor(random(4))) {
            case 0:
              newVel = new PVector(1, 0);
              break;
            case 1:
              newVel = new PVector(0, 1);
              break;
            case 2:
              newVel = new PVector(-1, 0);
              break;
            case 3:
              newVel = new PVector(0, -1);
              break;
            }
          } while ((tiles[abs(floor(matrixPosition.y + newVel.y))%31][abs(floor(matrixPosition.x + newVel.x))%56].wall) || ((newVel.x + (2*vel.x) == 0) && (newVel.y + (2*vel.y) == 0)));
          // if the random velocity is into a wall or in the opposite direction then choose another one

          /*
          
           while ((tiles[abs(floor(matrixPosition.y + newVel.y))%31][abs(floor(matrixPosition.x + newVel.x))%56].wall) || ((newVel.x +2*vel.x == 0) && (newVel.y + 2*vel.y == 0))) {
           rand = floor(random(4));
           switch(rand) {
           case 0:
           newVel = new PVector(1, 0);
           break;
           case 1:
           newVel = new PVector(0, 1);
           break;
           case 2:
           newVel = new PVector(-1, 0);
           break;
           case 3:
           newVel = new PVector(0, -1);
           break;
           }
           }
           
           */

          vel = new PVector(newVel.x/2, newVel.y/2); // halve the speed
          return;
        }
      } else { // not frightened

        setPath();

        if (bestPath != null) {
          if (bestPath.path != null) {

            for (int i = 0; i < (bestPath.path.size()-1); i++) { // if currently on a node turn towards the direction of the next node in the path
              if ((matrixPosition.x == bestPath.path.get(i).x) && (matrixPosition.y == bestPath.path.get(i).y)) {

                vel = new PVector(bestPath.path.get(i+1).x - matrixPosition.x, bestPath.path.get(i+1).y - matrixPosition.y);

                vel.limit(1);

                return;
              }
              //              return(true);
            }
            //            return(false);
          }
          //          return(false);
        }
        //        return(false);
      }
      //      return(false);
    }
    //    return(true);
  }
}  // End of class Ghost

int GlobPlayerX = 0;

class Joystick {
  PacMan    PlayerIsPacman = null;
  PacMan    AIPacman = null;
  Ghost     PlayerIsGhost = null;
  Ghost     AIGhost = null;
  Highscore Highscore = null;
  Menu      Menu = null;
  int       Angle = 0;
  int       Angles[] = {0,270,180,90};
//  int       xOrient, yOrient;
  color     Color = color(255);
  int       Score = 0;

  Joystick(PacMan tPacMan, Ghost tGhost, color tColor) {
    PlayerIsPacman = tPacMan;
    PlayerIsGhost = tGhost;
    AIGhost = null;
    AIPacman = null;
    Color = tColor;
    Highscore = null;
    Menu = null;
//    xOrient = 0;
//    yOrient = 0;
  }

  void Display() {
    if (PlayerIsPacman != null) {
      PlayerIsPacman.Display();
      Score = PlayerIsPacman.score;
    } else {
      if (PlayerIsGhost != null) {
        PlayerIsGhost.Display();
        Score = PlayerIsGhost.score;
      } else {
        if (AIGhost != null) {
          AIGhost.Display();
          Score = AIGhost.score;
        } else {
          if (AIPacman != null) {
            AIPacman.Display();
            Score = AIPacman.score;
          } else {
            println("Initialisatiefout Display!");
          }
        }
      }
    }
    pushMatrix();
    translate((width/2)-((width/2)*sin(radians(Angles[GlobPlayerX]))),(height/2)+((height/2)*cos(radians(Angles[GlobPlayerX]))));
    rotate(radians(Angles[GlobPlayerX]));
    fill(255);
    textSize(20);
    textAlign(LEFT,CENTER);
    text(Naam[GlobPlayerX],-100,-15);
    textAlign(RIGHT,CENTER);
    text(Score,100,-15);
    GlobPlayerX++;
    GlobPlayerX &= 3;
    popMatrix();
  } // End of Joystick.Display()

  void Update() {
    if (PlayerIsPacman != null) {
      PlayerIsPacman.Update();
    } else {
      if (PlayerIsGhost != null) {
        PlayerIsGhost.Update();
      } else {
        if (AIGhost != null) {
          AIGhost.Update();
        } else {
          if (AIPacman != null) {
            AIPacman.Update();
          } else {
            println("Initialisatiefout Update!");
          }
        }
      }
    }
  }
} // End of class Joystick

Joystick joy1 = null;
Joystick joy2 = null;
Joystick joy3 = null;
Joystick joy4 = null;

// Highscores below

String Order[] = {
  "   ", "   ", "   ", "   ", "   ", "   ", "   ", "   ", "   ", "   ",
  "1.", "2.", "3.", "4.", "5.", "6.", "7.", "8.", "9.", "10.",
  "11.", "12.", "13.", "14.", "15.", "16.", "17.", "18.", "19.", "20.",
  "21.", "22.", "23.", "24.", "25.", "26.", "27.", "28.", "29.", "30.",
  "31.", "32.", "33.", "34.", "35.", "36.", "37.", "38.", "39.", "40.",
  "   ", "   ", "   ", "   ", "   ", "   ", "   ", "   ", "   ", "   "
};

String NaamLijst[] = {"          ", "          ", "          ", "          ",
  "          ", "          ", "          ", "          ",
  "          ", "          ", "William S.", "William S.",
  "William S.", "William S.",
  "William S.", "William S.", "William S.", "William S.",
  "William S.", "William S.", "William S.", "William S.",
  "William S.", "William S.", "William S.", "William S.",
  "William S.", "William S.", "William S.", "William S.",
  "William S.", "William S.", "William S.", "William S.",
  "William S.", "William S.", "William S.", "William S.",
  "William S.", "William S.", "William S.", "William S.",
  "William S.", "William S.", "William S.", "William S.",
  "William S.", "William S.", "William S.", "William S.",
  "          ", "          ", "          ", "          ",
  "          ", "          ", "          ", "          ",
  "          ", "          "};

int Highscores[] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  400, 390, 380, 370, 360, 350, 340, 330, 320, 310,
  300, 290, 280, 270, 260, 250, 240, 230, 220, 210,
  200, 190, 180, 170, 160, 150, 140, 130, 120, 110,
  100, 90, 80, 70, 60, 50, 40, 30, 20, 10,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0};

String CrownLijst[] = {" ", " ", " ", " ", " ", " ", " ", " ", " ", " ",
  "P", "P", "P", "P", "P", "P", "P", "P", "P", "P",
  "P", "P", "P", "P", "P", "P", "P", "P", "P", "P",
  "P", "P", "P", "P", "P", "P", "P", "P", "P", "P",
  "P", "P", "P", "P", "P", "P", "P", "P", "P", "P",
  " ", " ", " ", " ", " ", " ", " ", " ", " ", " "};

int Offset1 = 0;
int Offset2 = 0;

String Naam[] = {"Player 1  ", "Player 2  ", "Player 3  ", "Player 4  "};
char KarakterSet[] = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
  'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',
  'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm',
  'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
  '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '-', '+', '_',
  '=', '.', '(', ',', ')', ';', ':', '<', '>', '?', ' ', '@', '!'};

int PlayerAngle[] = { 0, 270, 180, 90 };

boolean Once[] = {false, false, false, false};
boolean CollectedFireButtons[] = {false, false, false, false};
int NumCollectedFireButtons = 0;

boolean XRepKeys[] = {false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false,
  false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false,
  false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false,
  false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false,
  false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false,
  false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false};

boolean resetGame = false;

class Highscore {
  int Score = 0;
  int playerX = 0;
  int CursorX = 0;
  int CursorY = 0;
  int KarCount = 64;
  char Cursor = '_';
  char chars[] = {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '};
  boolean Crown = false;
  boolean RepKey[] = {false, false, false, false, false};

  Highscore(int tScore, int tPlayerX, boolean tCrown) {

    Score = tScore;
    playerX = tPlayerX;
    CursorX = 0;
    CursorY = 0;
    KarCount = 0;
    Crown = tCrown;
    Cursor = KarakterSet[KarCount];

    for (int i=0; i<NumKeysPerPlayer; i++) {
      RepKey[i] = XRepKeys[((NumKeysPerPlayer * playerX) + i)];
    }
    Once[playerX] = false;
    CollectedFireButtons[playerX] = false;
    chars = Naam[playerX].toCharArray();
    Cursor = chars[CursorX];
    for (int j=0; j<78; j++) {
      if (Cursor == KarakterSet[j]) {
        KarCount = j;
        continue;
      }
    }
    KarCount %= 78;
    Cursor = KarakterSet[KarCount];
    chars[CursorX] = Cursor;
    Naam[playerX] = String.valueOf(chars);
    insert();
  }

  void insert() {
    Joystick Joys[] = {joy3, joy4, joy1, joy2};

    Joys[0]=joy3;
    Joys[1]=joy4;
    Joys[2]=joy1;
    Joys[3]=joy2;
    for (int i=0; i<40; i++) { // 8;i++) {
      if (Score > Highscores[i+10]) {
        for (int j=38; j>=i; j--) { // 6;j>=i;j--) {
          CrownLijst[j+11]=CrownLijst[j+10];
          Highscores[j+11]=Highscores[j+10];
          NaamLijst[j+11]=NaamLijst[j+10];
        }
        CrownLijst[i+10]=((Crown)?"P":"G");
        Highscores[i+10]=Score;
        NaamLijst[i+10]=Naam[playerX];
        CursorY = i;
        for (int k=0; k<playerX; k++) {
          if ((Joys[k].Highscore != null)&&((CursorY) <= (Joys[k].Highscore.CursorY))) {
            Joys[k].Highscore.CursorY += 1;
          }
        }
        return; // early out!
      }
    }
    CursorY = 40; // force to 40 if below the lowest highscore!
  }

  void Display() {
    Joystick Joys[] = {joy3, joy4, joy1, joy2};

    Joys[0] = joy3;
    Joys[1] = joy4;
    Joys[2] = joy1;
    Joys[3] = joy2;

    pushMatrix();
    textAlign(CENTER, CENTER);
    translate(((width / 2) - (( width / 4) * (sin(radians(PlayerAngle[playerX]))))), (( height / 2) + (( height / 4) * (cos(radians(PlayerAngle[playerX]))))));
    rotate(radians(PlayerAngle[playerX]));
    for (int i=(CursorY-4); i<(CursorY-4+8); i++) {

      fill(((HumanPlayer[playerX] == true)&&(Joys[playerX].Highscore != null)&&((CursorY) == i))?(Joys[playerX].Color):(color(255, 255, 255)));

      textSize(20);
      if (Highscores[i+10] != 0)
      {
        textAlign(LEFT, CENTER);
        text(Order[i+10], -120, 20*((i-CursorY+4)));
        textAlign(LEFT, CENTER);
        text(NaamLijst[i+10], -90, 20*((i-CursorY+4)));
        textAlign(RIGHT, CENTER);
        text(Highscores[i+10], 120, 20*((i-CursorY+4)));
        textAlign(CENTER, CENTER);
        text(CrownLijst[i+10], 140, 20*((i-CursorY+4)));
      }
    }
    popMatrix();
  }

  void Update()
  {
    int      i, j, k;
    Joystick Joys[] = {joy3, joy4, joy1, joy2};

    Joys[0] = joy3;
    Joys[1] = joy4;
    Joys[2] = joy1;
    Joys[3] = joy2;
    if ((CursorY < 40)&&(Joys[playerX].Highscore != null)&&(HumanPlayer[playerX] == true)) {
      for (j=0; j<NumKeysPerPlayer; j++)
      {
        RepKey[j] = XRepKeys[((playerX * NumKeysPerPlayer) + j)];
      }

      playerX %= 4;
      chars = Naam[playerX].toCharArray();
      CursorX %= 10;
      Cursor = chars[CursorX];

      if (stick.getButton(PlusToetsen[playerX]%TotalNumKeys).pressed())
      {
        Lampjes |= (1L<<(PlusToetsen[playerX]-TranslationConstance));
        if (!(RepKey[3])) {
          for (i=0; i<78; i++) {
            if (Cursor == KarakterSet[i]) {
              KarCount = i;
              continue;
            }
          }

          KarCount++;

          if (KarCount > 77)
            KarCount = 0;
          if (KarCount < 0)
            KarCount = 77;
          KarCount %= 78;

          Cursor = KarakterSet[KarCount];

          RepKey[3] = true;
        }
      } else
      {
        RepKey[3] = false;
      }

      if (stick.getButton(MinToetsen[playerX]%TotalNumKeys).pressed())
      {
        Lampjes |= (1L<<(MinToetsen[playerX]-TranslationConstance));
        if (!(RepKey[4])) {
          for (i=0; i<78; i++) {
            if (Cursor == KarakterSet[i]) {
              KarCount = i;
              continue;
            }
          }

          KarCount--;

          if (KarCount > 77)
            KarCount = 0;
          if (KarCount < 0)
            KarCount = 77;
          KarCount %= 78;

          Cursor = KarakterSet[KarCount];

          RepKey[4] = true;
        }
      } else
      {
        RepKey[4] = false;
      }

      if (stick.getButton(LinksToetsen[playerX]%TotalNumKeys).pressed())
      {
        Lampjes |= (1L<<(LinksToetsen[playerX]-TranslationConstance));
        if (!(RepKey[0])) {
          CursorX--;

          if (CursorX < 0)
            CursorX = 0;
          if (CursorX > 9)
            CursorX = 9;
          CursorX %= 10;

          Cursor = chars[CursorX];

          for (i=0; i<78; i++) {
            if (Cursor == KarakterSet[i]) {
              KarCount = i;
              continue;
            }
          }

          RepKey[0] = true;
        }
      } else
      {
        RepKey[0] = false;
      }

      if (stick.getButton(RechtsToetsen[playerX]%TotalNumKeys).pressed())
      {
        Lampjes |= (1L<<(RechtsToetsen[playerX]-TranslationConstance));
        if (!(RepKey[2])) {
          CursorX++;

          if (CursorX < 0)
            CursorX = 0;
          if (CursorX > 9)
            CursorX = 9;
          CursorX %= 10;

          Cursor = chars[CursorX];

          for (i=0; i<78; i++) {
            if (Cursor == KarakterSet[i]) {
              KarCount = i;
              continue;
            }
          }

          RepKey[2] = true;
        }
      } else
      {
        RepKey[2] = false;
      }

      if (stick.getButton(VuurKnoppen[playerX]%TotalNumKeys).pressed())
      {
        Lampjes |= (1L<<(VuurKnoppen[playerX]-TranslationConstance));
        if (!(RepKey[1])) {
          for (i=(0+TranslationConstance); i<(NumKeys+TranslationConstance); i++) {
            keysPressed[i]=0;
          }
          buttonPressed = false;
          CollectedFireButtons[playerX] = HumanPlayer[playerX];  // true;
          NumCollectedFireButtons = 0;

          for (j=0; j<4; j++) {
            NumCollectedFireButtons = ((CollectedFireButtons[j])?(NumCollectedFireButtons+1):(NumCollectedFireButtons));
          }
          if (NumCollectedFireButtons == (NumHumanPlayers-NumGhosts)) { // remove -NumGhosts when ready, please!!! Formula incorrect!
            resetGame = true;
            if (resetGame==true) {
              do {
                ButtonPressed();
              } while (buttonPressed==true);
              saveHighscores(); // Might be a timebomb?!
              frameCounter=0;
              fc_now=frameCounter;
              resetGame=false;
            }
          }
          RepKey[1] = true;
        }
      } else
      {
        RepKey[1] = false;
      }

      CursorX %= 10;
      playerX %= 4;
      KarCount %= 78;
      Cursor = KarakterSet[KarCount];
      chars[CursorX] = Cursor;
      Naam[playerX] = String.valueOf(chars);

      for (k=0; k<NumKeysPerPlayer; k++)
      {
        XRepKeys[((NumKeysPerPlayer * playerX) + k)] = RepKey[k];
      }
    }

    // Do strcpy(NaamLijst[CursorY],Naam[playerX]); here!
    //    memcpy(NaamLijst[CursorY],Naam[playerX],10);
    // This is your double buffering!

    chars = Naam[playerX].toCharArray();
    if (CursorY > 39) {
      if (!(Once[playerX])) {
        println(Naam[playerX], ", you dropped off the highscorelist!");
        Once[playerX] = true;
      }
    } else {
      NaamLijst[CursorY+10] = String.valueOf(chars);
    }
  }
}
