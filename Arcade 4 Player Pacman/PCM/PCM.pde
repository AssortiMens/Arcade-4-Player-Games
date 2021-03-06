/****************************/
/* Arcade 4 - Player PacMan */
/****************************/
/*  (c)  2022  AssortiMens  */
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

int LinksToetsen[] =  {TranslationConstance+0,TranslationConstance+5,TranslationConstance+10,TranslationConstance+15};
int VuurKnoppen[] =   {TranslationConstance+1,TranslationConstance+6,TranslationConstance+11,TranslationConstance+16};
int RechtsToetsen[] = {TranslationConstance+2,TranslationConstance+7,TranslationConstance+12,TranslationConstance+17};
int PlusToetsen[] =   {TranslationConstance+3,TranslationConstance+(int)8,TranslationConstance+13,TranslationConstance+18};
int MinToetsen[] =    {TranslationConstance+4,TranslationConstance+9,TranslationConstance+14,TranslationConstance+19};

int Player;
int Key;
int keysPressed[] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
                     0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
                     0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
                     0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
                     0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
                     0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};

boolean buttonPressed = false;
boolean HumanPlayer[] = {false,false,false,false};
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
//  size(1488,744);
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
  }
  catch (Exception e) {
    println("Can not open Sounds!");
    System.exit(0);
  }

  try {
    PacmanField = loadImage("data/PacmanField.jpg");

    PFWidth = PacmanField.width;
    PFHeight = PacmanField.height;

    if ((PFWidth != (28*int(width/56))) || (PFHeight != (31*int(height/31))))
      PacmanField.resize(28*int(width/56),31*int(height/31));

    PFScaleX = (float(28*int(width/56)) / (float(PFWidth)));
    PFScaleY = (float(31*int(height/31)) / (float(PFHeight)));
  }
  catch (Exception e) {
    println("data/PacmanField.jpg is missing!");
    System.exit(0);
  }

// /*

  try {
    printArray(Serial.list());
    serial = new Serial(this, Serial.list()[1], 115200);
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

  loadHighscores();
  saveHighscores();
  
  TitleSong.loop();
}

void InitialiseAllVariables()
{
  Opkomst = true;
  TextKleur = -1;
  TextSize = 20;
  TextAngle = 0;
  frameCounter = 0;
  Offset1 = 0;
  Offset2 = 0;
  gameover = false;
  
  for (int j=0;j<31;j++)
   {
     for (int i=0;i<56;i++)
      {
        tiles[j][i] = new Tile((i*(floor(width/(2*28))))+8,(j*(floor(height/31)))+8);
//        tiles[j][i] = new Tile((i*(1.040*(width/(2*28))))+8,(j*(1.046*(height/31)))+8);
        switch(tilesRepresentation[j][i])
         {
           case 0: tiles[j][i].dot = true;
                   break;
           case 1: tiles[j][i].wall = true;
                   break;
           case 6: tiles[j][i].eaten = true;
                   break;
           case 8: tiles[j][i].bigDot = true;
                   break;
         }
      }
   }

  joy3 = new Joystick(new PacMan(14*floor(width/(2*28))+8,23*floor(height/31)+8,30,30,color(255,255,0,255)),null,color(255));
  joy4 = new Joystick(new PacMan((14+28)*floor(width/(2*28))+8,23*floor(height/31)+8,30,30,color(255,255,0,255)),null,color(255));
  
  joy1 = new Joystick(null,new Ghost(13*floor(width/(2*28))+8,14*floor(height/31)+8,32,32,color(255,0,0,255)),color(255));
  joy2 = new Joystick(null,new Ghost(15*floor(width/(2*28))+8,14*floor(height/31)+8,32,32,color(0,255,0,255)),color(255));

  Blinky = joy1.PlayerIsGhost;
  Inky = joy2.PlayerIsGhost;

  Pinky = new Ghost((13+28)*floor(width/(2*28))+8,14*floor(height/31)+8,32,32,color(255,0,255,255));
  Clyde = new Ghost((15+28)*floor(width/(2*28))+8,14*floor(height/31)+8,32,32,color(0,255,255,255));
  
}

Ghost Pinky;
Ghost Clyde;

Ghost Blinky;
Ghost Inky;

void loadHighscores() {
  try {
    table = loadTable("data/highscores.csv","header");
    if (table != null) {
      NumRows = table.getRowCount();
      for (int i=0;i<NumRows;i++) {
        TableRow row = table.getRow(i);
        NaamLijst[i+10] = row.getString("name");
        Highscores[i+10] = row.getInt("score");
        CrownLijst[i+10] = row.getString("crown");
      }
    }
    else {
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
      for (int i=0;i<NumRows;i++) {
        TableRow row = table.getRow(i);
        row.setString("name", NaamLijst[i+10]);
        row.setInt("score", Highscores[i+10]);
        row.setString("crown", CrownLijst[i+10]);
       }
      saveTable(table, "data/highscores.csv");
    }
    else {
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
//PImage PacmanSprite;
boolean gameover = false;

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

int CyclicBuffer[] = {1,2,4,8,16,32,64,128,256,512,1024,2048,4096,8192,16384,
                      32768,65536,131072,262144,524288,
                      524288,262144,131072,65536,32768,16384,8192,4096,2048,1024,
                      512,256,128,64,32,16,8,4,2,1,
                      1,3,7,15,31,63,127,255,511,1023,2047,4095,8191,16383,
                      32767,65535,131071,262143,524287,1048575,
                      -1,-2,-4,-8,-16,-32,-64,-128,-256,-512,-1024,-2048,-4096,-8192,
                      -16384,-32768,-65536,-131072,-262144,-524288,-1048576};

void draw()
{
  if (frameCounter < 10000)
    Lampjes = CalcLicht(); //int(random(1048576));
  else
    Lampjes = 0;

  if ((frameCounter >= 0) && (frameCounter < 1000))
    PCM_Demo1();
  if ((frameCounter >= 1000) && (frameCounter < 2000))
    PCM_Demo2();
  if ((frameCounter >= 2000) && (frameCounter < 3250))
    PCM_Demo3();
  if ((frameCounter >= 3250) && (frameCounter < 4250))
    PCM_Demo4();

  ser_Build_Msg_String_And_Send(Lampjes);
  
  frameCounter++;
  if (frameCounter >= 4250)
    if (frameCounter >= 10000)
      ;
    else
      frameCounter = 0;
}

int Lampjes = 0;

String TestBuffer = "w 255 255 255\n\r";
String TestBuffer2 = "w 255 255 255\n\r";
int OldCode = 0;

void ser_Build_Msg_String_And_Send(int tCode)
{
  char msgchars[] = {'w',' ','2','5','5',' ','2','5','5',' ','2','5','5','\n','\r','\0'};
  char FastHex[] = {'0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'};
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
    }
    else {
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
    }
    else {
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
    }
    else {
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
    TestBuffer2 = TestBuffer.substring(0,len);
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

void PCM_Demo1()
{
  background(0);
  translate(width/2,height/2);
  rotate(radians(TextAngle++));
  TextAngle %= 360;
  textAlign(CENTER,CENTER);
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
   }
  else
   {
     TextKleur--;
     if (TextKleur < 0)
       {
         TextKleur = 0;
         Opkomst = true;
       }
   }
  fill(TextKleur);
  text("AssortiMens presents",0,-50);
  text("Four Player PacMan",0,0);
  text("?? 2022",0,50);

  fill(255);
  text("Press a key to play!",0,230-55);
  
//  println(TextKleur); // debug info
//  println(frameCounter); // debug info
}

void PCM_Demo2()
{
  background(0);
  translate(width/2,height/2);
  rotate(radians(TextAngle++));
  TextAngle %= 360;
  textAlign(CENTER,CENTER);
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
   }
  else
   {
     TextKleur--;
     if (TextKleur < 0)
       {
         TextKleur = 0;
         Opkomst = true;
       }
   }
  fill(TextKleur);

  text("Programming",0,-100);
  text("William Senn",0,-70);

  text("GFX & Graphics",0,-15);
  text("William Senn",0,15);
  
  text("SFX & Titlemusic",0,70);
  text("William Senn & DJ Mistik",0,100);
  
  fill(255);
  text("Press a key to play!",0,230-55);

//  println(TextKleur); // debug info
//  println(frameCounter); // debug info
}

void PCM_Demo3()
{
  background(0);
  translate(width/2,height/2);
  rotate(radians(TextAngle++));
  TextAngle %= 360;
  textAlign(CENTER,CENTER);
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
   }
  else
   {
     TextKleur--;
     if (TextKleur < 0)
       {
         TextKleur = 0;
         Opkomst = true;
       }
   }

  fill(TextKleur);
  text("Top 40 Best Players",0,-175);
  for (int i = 0; i < 11; i++)
  {
    if (Highscores[i+Offset1] != 0)
      {
        textAlign(LEFT,CENTER);
        text(Order[i+Offset1],-150,(i*25)-46-Offset2-55);
        text(NaamLijst[i+Offset1],-110,(i*25)-46-Offset2-55);
        textAlign(RIGHT,CENTER);
        text(Highscores[i+Offset1],120,(i*25)-46-Offset2-55);
        text(CrownLijst[i+Offset1],150,(i*25)-46-Offset2-55);
      }
  }
  textAlign(CENTER,CENTER);
  rectMode(CENTER);
  fill(0);
  noStroke();
  rect(0,-70-55,300,25);
  rect(0,205-55,300,25);
  fill(255);
  text("Press a key to play!",0,230-55);

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

  perFrameGame();

}

void perFrameGame()
{
  image(PacmanField,0,0); //test1
  image(PacmanField,28*int(width/56),0); //test2

//  image(PacmanSprite,312,550);

  if (!gameover) {
    for (int i=0;i<31;i++)
     {
       for (int j=0;j<56;j++)
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
    
    joy3.Display();
    joy4.Display();
    joy1.Display();
    joy2.Display();

    Pinky.Display();
    Clyde.Display();

// Do All Updates

    Pinky.Update();
    Clyde.Update();
  
    joy3.Update(); //Pacman1.Update();
    joy4.Update(); //Pacman2.Update();
    joy1.Update();
    joy2.Update();

//    Inky.Display();
//    Inky.Update();
  
//    Blinky.Display();
//    Blinky.Update();
  
//    Pacman1.Display();
//    Pacman2.Display();
  }
}

void keyPressed() { //controls for pacman
  PacMan Pacman1 = joy3.PlayerIsPacman;
      
  switch(key) {
  case CODED:
    switch(keyCode) {
    case UP:
      Pacman1.turnTo = new PVector(0, -1);
      Pacman1.turn = true;
      break;
    case DOWN:
      Pacman1.turnTo = new PVector(0, 1);
      Pacman1.turn = true;
      break;
    case LEFT:
      Pacman1.turnTo = new PVector(-1, 0);
      Pacman1.turn = true;
      break;
    case RIGHT:
      Pacman1.turnTo = new PVector(1, 0);
      Pacman1.turn = true;
      break;
    }
  }
}

void ButtonPressed() {
  buttonPressed = false;
  for (int z=TranslationConstance;z<(NumKeys+TranslationConstance);z++) {
    if (stick.getButton(z % TotalNumKeys).pressed()) {
      buttonPressed = true;
      keysPressed[z] = (int)(z + 1);
    }
    else
    {
      keysPressed[z] = 0;
    }
  }
}

//returns the shortest path from the start node to the finish node

Path AStar(Node start, Node finish, PVector vel)
{
  LinkedList<Path> big = new LinkedList<Path>();//stores all paths
  Path extend = new Path(); //a temp Path which is to be extended by adding another node
  Path winningPath = new Path();  //the final path
  Path extended = new Path(); //the extended path
  LinkedList<Path> sorting = new LinkedList<Path>();///used for sorting paths by their distance to the target

  //startin off with big storing a path with only the starting node
  extend.addToTail(start, finish);
  extend.velAtLast = new PVector(vel.x, vel.y); //used to prevent ghosts from doing a u turn
  big.add(extend);


  boolean winner = false; //has a path from start to finish been found  

  while (true) //repeat the process until ideal path is found or there is not path found 
  {
    extend = big.pop();//grab the front path form the big to be extended
    if (extend.path.getLast().equals(finish)) //if goal found
    {
      if (!winner) //if first goal found, set winning path
      {
        winner = true;
        winningPath = extend.clone();
      } else { //if current path found the goal in a shorter distance than the previous winner 
        if (winningPath.distance > extend.distance)
        {
          winningPath = extend.clone();//set this path as the winning path
        }
      }
      if (big.isEmpty()) //if this extend is the last path then return the winning path
      {
        return winningPath.clone();
      } else {//if not the current extend is useless to us as it cannot be extended since its finished
        extend = big.pop();//so get the next path
      }
    } 


    //if the final node in the path has already been checked and the distance to it was shorter than this path has taken to get there than this path is no good
    if (!extend.path.getLast().checked || extend.distance < extend.path.getLast().smallestDistToPoint)
    {     
      if (!winner || extend.distance + dist(extend.path.getLast().x, extend.path.getLast().y, finish.x, finish.y)  < winningPath.distance) //dont look at paths that are longer than a path which has already reached the goal
      {

        //if this is the first path to reach this node or the shortest path to reach this node then set the smallest distance to this point to the distance of this path
        extend.path.getLast().smallestDistToPoint = extend.distance;
        
        //move all paths to sorting form big then add the new paths (in the for loop)and sort them back into big.
        sorting = (LinkedList)big.clone();
        Node tempN = new Node(0, 0);//reset temp node
        if (extend.path.size() >1) {
          tempN = extend.path.get(extend.path.size() -2); //set the temp node to be the second last node in the path
        }

        for (int i = 0; i < extend.path.getLast().edges.size(); i++) //for each node incident (connected) to the final node of the path to be extended 
        {
          if (tempN != extend.path.getLast().edges.get(i)) //if not going backwards i.e. the new node is not the previous node behind it 
          {     
     
            //if the direction to the new node is in the opposite to the way the path was heading then dont count this path
            PVector directionToNode = new PVector( extend.path.getLast().edges.get(i).x -extend.path.getLast().x, extend.path.getLast().edges.get(i).y - extend.path.getLast().y );
            directionToNode.limit(vel.mag());
            if (directionToNode.x == -1* extend.velAtLast.x && directionToNode.y == -1* extend.velAtLast.y ) {
            } else {//if not turning around
              extended = extend.clone();
              extended.addToTail(extend.path.getLast().edges.get(i), finish);
              extended.velAtLast = new PVector(directionToNode.x, directionToNode.y);
              sorting.add(extended.clone());//add this extended list to the list of paths to be sorted
            }
          }
        }


        //sorting now contains all the paths form big plus the new paths which where extended
        //adding the path which has the higest distance to big first so that its at the back of big.
        //using selection sort i.e. the easiest and worst sorting algorithm
        big.clear();
        while (!sorting.isEmpty())
        {
          float max = -1;
          int iMax = 0;
          for (int i = 0; i < sorting.size(); i++)
          {
            if (max < sorting.get(i).distance + sorting.get(i).distToFinish)//A* uses the distance from the goal plus the paths length to determine the sorting order
            {
              iMax = i;
              max = sorting.get(i).distance + sorting.get(i).distToFinish;
            }
          }
          big.addFirst(sorting.remove(iMax).clone());//add it to the front so that the ones with the greatest distance end up at the back
          //and the closest ones end up at the front
        }
      }
      extend.path.getLast().checked = true;
    }
    //if no more paths avaliable
    if (big.isEmpty()) {
      if (winner == false) //there is not path from start to finish
      {
        print("FUCK!!!!!!!!!!"); //error message 
        return null;
      } else { //if winner is found then the shortest winner is stored in winning path so return that
        return winningPath.clone();
      }
    }
  }
}

//returns the nearest non wall tile to the input vector
//input is in tile coordinates

PVector getNearestNonWallTile(PVector target) {
  float min = 1000;
  int minIndexj = 0;
  int minIndexi = 0;
  for (int i = 0; i < 56; i++) { //for each tile
    for (int j = 0; j < 31; j++) {
      if (!tiles[j][i].wall) { //if its not a wall
        if (dist(i, j, target.x, target.y) < min) { //if its the current closest to target
          min = dist(i, j, target.x, target.y);
          minIndexj = j;
          minIndexi = i;
        }
      }
    }
  }
  return new PVector(minIndexi, minIndexj); //return a PVector to the tile
}

class PacMan
{
  PVector pos = new PVector(1,0); //null; //int x,y;
  int w,h;
  int score = 0;
  int lives = 10;
  color Color;
  PVector vel = new PVector(-1,0);
  PVector turnTo = new PVector(-1,0);
  boolean turn = false;
  
  PacMan(int tx, int ty, int tw, int th, color tColor)
   {
     pos = new PVector(tx,ty); //x = tx;
                               //y = ty;
     w = tw;
     h = th;
     Color = tColor;
     score = 0;
   }

  void Display()
   {
     fill(Color);
     ellipse(pos.x,pos.y,w,h);
   }

  void Update()
   {
    if ((pos.x) < (8)) {
        pos.x = (((55*floor(width/(2*28)))+8)); // - vel.x);
    }
    else if ((pos.x) > ((55*floor(width/(2*28)))+8)) {
        pos.x = (((0*floor(width/(2*28)))+8)); // - vel.x);
    }
    
    if ((pos.y) < (8)) {
        pos.y = (((30*floor(height/31))+8));
    }
    else if ((pos.y) > ((30*floor(height/31))+8)) {
        pos.y = (((0*floor(height/31))+8));
    }
    
    if (checkPosition()) {
      pos.add(vel);
    }
     
   }
   
  boolean checkPosition()
   {
    if ((((pos.x - 8) % floor(width / (2*28))) == 0) && (((pos.y - 8) % floor(height/31)) == 0)) { //if on a critical position

      PVector matrixPosition = new PVector(abs(floor(((pos.x - 8) / floor(width/(2*28)))))%56, abs(floor(((pos.y - 8) / floor(height/31))))%31); //convert position to an array position

      //reset all the paths for all the ghosts  
      Blinky.setPath();
      Pinky.setPath();
      Clyde.setPath();
      Inky.setPath(); 
      
      //check if the position has been eaten or not, note the blank spaces are initialised as already eaten
      if (!tiles[floor(matrixPosition.y)][floor(matrixPosition.x)].eaten) {
        tiles[floor(matrixPosition.y)][floor(matrixPosition.x)].eaten = true;
        score += 1; //add a point
        if (tiles[floor(matrixPosition.y)][floor(matrixPosition.x)].bigDot) { //if big dot eaten
          //set all ghosts to frightened
          Blinky.frightened = true;
          Blinky.flashCount = 0;
          Clyde.frightened = true;
          Clyde.flashCount = 0;
          Pinky.frightened = true;
          Pinky.flashCount = 0;
          Inky.frightened = true;
          Inky.flashCount = 0;
        }
      }
      
      
      PVector positionToCheck = new PVector(abs(floor(matrixPosition.x + turnTo.x))%56, abs(floor(matrixPosition.y + turnTo.y))%31); // the position in the tiles double array that the player is turning towards

      if (tiles[floor(positionToCheck.y)%31][floor(positionToCheck.x)%56].wall) { //check if there is a free space in the direction that it is going to turn
        if (tiles[abs(floor(matrixPosition.y + vel.y))%31][abs(floor(matrixPosition.x + vel.x))%56].wall) { //if not check if the path ahead is free
          return false; //if neither are free then dont move
        } else { //forward is free
          return true;
        }
      } else { //free to turn
        vel = new PVector(turnTo.x, turnTo.y);
        return true;
      }
    } else {
      if ((((pos.x+(10*vel.x) - 8) % floor(width/(2*28))) == 0) && (((pos.y + (10*vel.y) - 8) % floor(height/31)) == 0)) { //if 10 places off a critical position in the direction that pacman is moving
        PVector matrixPosition = new PVector(abs(floor(((pos.x+(10*vel.x)-8) / floor(width/(2*28)))))%56, abs(floor(((pos.y+(10*vel.y)-8) / floor(height/31))))%31); //convert that position to an array position
        if (!tiles[floor(matrixPosition.y)][floor(matrixPosition.x)].eaten ) { //if that tile has not been eaten 
          tiles[floor(matrixPosition.y)][floor(matrixPosition.x)].eaten = true; //eat it
          score += 1;
          println("Score:", score);
          if (tiles[floor(matrixPosition.y)][floor(matrixPosition.x)].bigDot) {//big dot eaten
            //set all ghosts as frightened
            Blinky.frightened = true;
            Blinky.flashCount = 0;
            Clyde.frightened = true;
            Clyde.flashCount = 0;
            Pinky.frightened = true;
            Pinky.flashCount = 0;
            Inky.frightened = true;
            Inky.flashCount = 0;
          }
        }
      }
      if ((turnTo.x + vel.x == 0) && (vel.y + turnTo.y == 0)) { //if turning chenging directions entirely i.e. 180 degree turn
        vel = new PVector(turnTo.x, turnTo.y); //turn
        return true;
      }
      return true; //if not on a critical postion then continue forward
    }
  }

  void kill()
   {
     lives--;
     if (lives == 0) {
       gameover = true;
     }
   }
   
  boolean hitPacman(PVector tpos)
   {
    if (dist(tpos.x, tpos.y, pos.x, pos.y) < 10) {
      return true;
    }
    return false;
   }
   
}

class Ghost
{
  PVector pos = new PVector(13*floor(width/(2*28))+8,14*floor(height/31)+8); //int x,y;
  int w,h;
  color Color;

  boolean returnHome = false;
  boolean chase = true;
  boolean frightened = false;
  boolean deadForABit = false;
  int deadCount = 0, chaseCount = 0, flashCount = 0;
  
  PVector vel = new PVector(1, 0);
  Path bestPath = new Path(); // the variable stores the path the ghost will be following
  ArrayList<Node> ghostNodes = new ArrayList<Node>(); //the nodes making up the path including the ghosts position and the target position
  Node start; //the ghosts position as a node
  Node end; //the ghosts target position as a node

  Ghost(int tx, int ty, int tw, int th, color tColor)
   {
     pos = new PVector(tx, ty); //pos.x = tx;
                               //pos.y = ty;
     w = tw;
     h = th;
     Color = tColor;

     returnHome = false;

     setPath();
   }
   
  void Display()
   {
//     fill(Color);
//     if (bestPath != null)
//       bestPath.show();
//     ellipse(pos.x,pos.y,w,h);

    //increments counts
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
    } else { //if not deadforabit then show the ghost
      if (!frightened) {
        if (returnHome) { //have the ghost be transparent if on its way home
          stroke(Color, 100); 
          fill(Color, 100);
        } else { // colour the ghost
          stroke(Color);
          fill(Color);
        }
        if (bestPath != null)
//          if (bestPath.size() > 0)
            bestPath.show(); //show the path the ghost is following
      } else {//if frightened
        flashCount++;
        if (flashCount > 800) { //after 8 seconds the ghosts are no longer frightened
          frightened = false;
          flashCount = 0;
        }

        if (floor(flashCount / 30) %2 ==0) { //make it flash white and blue every 30 frames
          stroke(255);
          fill(255);
        } else { //flash blue
          stroke(0, 0, 200);
          fill(0, 0, 200);
        }
      }
      ellipse(pos.x,pos.y,w,h);
    }

 
   }
   
  void Update()
   {
    float x,y;
    
    if (!deadForABit) { //dont move if dead
      pos.add(vel);

      x = (pos.x);
      y = (pos.y);
      
      if ((x) < (8)) {
        x = ((55*floor(width/(2*28)))+(8)); // - vel.x;
      }
      else {
        if ((x) > (55*floor(width/(2*28))+(8))) {
          x = ((0*floor(width/(2*28)))+(8)); // - vel.x;
        }
      }
    
      if ((y) < (8)) {
        y = ((30*floor(height/31))+(8));
      }
      else {
        if ((y) > ((30*floor(height/31))+8)) {
          y = ((0*floor(height/31))+(8));
        }
      }
      pos = new PVector(x,y);

      checkDirection(); //check if need to change direction next move
    }

   }

  //--------------------------------------------------------------------------------------------------------------------------------------------------
  
  //calculates a path from the first node in ghost nodes to the last node in ghostNodes and sets it as best path
  void setPath() {
    ghostNodes.clear();
    setNodes();
    start = ghostNodes.get(0);
    end = ghostNodes.get(ghostNodes.size()-1);
    Path temp = AStar(start, end, vel);
    if (temp!= null) { //if not path is found then dont change bestPath
      bestPath = temp.clone();
    }
  }
  //--------------------------------------------------------------------------------------------------------------------------------------------------
  //sets all the nodes and connects them with adjacent nodes 
  //also sets the target node
  void setNodes() {

    ghostNodes.add(new Node((pos.x-8) / floor(width/(2*28)), (pos.y-8) / floor(height/31))); //add the current position as a node
    for (int i = 1; i < 55; i++) {//check every position
      for (int j = 1; j < 30; j++) {
        //if there is a space up or below and a space left or right then this space is a node
        if (!tiles[j][i].wall) {
          if (!tiles[j-1][i].wall || !tiles[j+1][i].wall) { //check up for space
            if (!tiles[j][i-1].wall || !tiles[j][i+1].wall) { //check left and right for space

              ghostNodes.add(new Node(i, j));//add the nodes
            }
          }
        }
      }
    }
    if (returnHome) {//if returning home then the target is just above the ghost room thing
      ghostNodes.add(new Node(13, 14));
    } else {
      if (chase) {
        PacMan Pacman1 = joy3.PlayerIsPacman;
        
        if (Pacman1 != null) {
          if (Pacman1.pos != null) {
            ghostNodes.add(new Node((Pacman1.pos.x-8) / floor(width/(2*28)), (Pacman1.pos.y-8) / floor(height/31))); //target pacman
          }
        }
      } else {
        ghostNodes.add(new Node(13, 14));//scatter to corner, nope, to their homebase
      }
    }
    
    for (int i = 0; i < ghostNodes.size(); i++) { //connect all the nodes together
      ghostNodes.get(i).addEdges(ghostNodes);
    }
  }
  //--------------------------------------------------------------------------------------------------------------------------------------------------
  //check if the ghost needs to change direction as well as other stuff
  void checkDirection() {
    PacMan Pacman1 = joy3.PlayerIsPacman;
    
    if (Pacman1.hitPacman(pos)) { //if hit pacman
      if (frightened) { //eaten by pacman
        returnHome = true;
        frightened = false;
      } else if (!returnHome) { //killPacman
        Pacman1.kill();
      }
    }


    // check if reached home yet
    if (returnHome) {
      if (dist(floor((pos.x-8) / floor(width/(2*28))), floor((pos.y-8) / floor(height/31)), 13, 14) < 1) {
        //set the ghost as dead for a bit
        returnHome = false;
        deadForABit = true;
        deadCount = 0;
      }
    }

    if (((pos.x-8) % floor(width/(2*28)) == 0) && ((pos.y - 8) % floor(height/31) == 0)) { //if on a critical position 

      PVector matrixPosition = new PVector(abs(floor(((pos.x-8) / floor(width/(2*28)))))%56, abs(floor(((pos.y-8) / floor(height/31))))%31); //convert position to an array position

      if (frightened) { //no path needs to generated by the ghost if frightened
        boolean isNode = false;
        for (int j = 0; j < ghostNodes.size(); j++) {
          if (matrixPosition.x ==  ghostNodes.get(j).x && matrixPosition.y == ghostNodes.get(j).y) {
            isNode = true;
          }
        }
        if (!isNode) {//if not on a node then no need to do anything
          return;
        } else { //if on a node, set a random direction
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
          }
          while((tiles[abs(floor(matrixPosition.y + newVel.y))%31][abs(floor(matrixPosition.x))%56].wall) || ((newVel.x + (2*vel.x) == 0) && (newVel.y + (2*vel.y) == 0)));
          //if the random velocity is into a wall or in the opposite direction then choose another one

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
          
          vel = new PVector(newVel.x/2, newVel.y/2);//halve the speed
        }
      } else { //not frightened

        setPath();

        if (bestPath != null) {
          if (bestPath.path != null) {
            
            for (int i = 0; i < (bestPath.path.size()-1); i++) { //if currently on a node turn towards the direction of the next node in the path 
              if ((matrixPosition.x == bestPath.path.get(i).x) && (matrixPosition.y == bestPath.path.get(i).y)) {
            
                vel = new PVector(bestPath.path.get(i+1).x - matrixPosition.x, bestPath.path.get(i+1).y - matrixPosition.y);
                vel.limit(1);

                return;
              }
            }
          }
        }
      }
    }
  }
}

class Joystick {
  PacMan    PlayerIsPacman = null;
  Ghost     PlayerIsGhost = null;
  Highscore Highscore = null;
  int       xOrient,yOrient;
  color     Color = color(255);

  Joystick(PacMan tPacMan,Ghost tGhost,color tColor) {
    PlayerIsPacman = tPacMan;
    PlayerIsGhost = tGhost;
    Color = tColor;
    Highscore = null;
    xOrient = 0;
    yOrient = 0;
  }

  void Display() {
    if (PlayerIsPacman != null) {
      PlayerIsPacman.Display();
    }
    else if (PlayerIsGhost != null) {
      PlayerIsGhost.Display();
    }
    else {
      println("Initialisatiefout Display!");
    }
  }

  void Update() {
    if (PlayerIsPacman != null) {
      PlayerIsPacman.Update();
    }
    else if (PlayerIsGhost != null) {
      PlayerIsGhost.Update();
    }
    else {
      println("Initialisatiefout Update!");
    }
  }
}

Joystick joy1 = null;
Joystick joy2 = null;
Joystick joy3 = null;
Joystick joy4 = null;

// Highscores below

String Order[] = {
                  "   ","   ","   ","   ","   ","   ","   ","   ","   ","   ",
                  "1.","2.","3.","4.","5.","6.","7.","8.","9.","10.",
                  "11.","12.","13.","14.","15.","16.","17.","18.","19.","20.",
                  "21.","22.","23.","24.","25.","26.","27.","28.","29.","30.",
                  "31.","32.","33.","34.","35.","36.","37.","38.","39.","40.",
                  "   ","   ","   ","   ","   ","   ","   ","   ","   ","   "
                };

String NaamLijst[] = {"          ","          ","          ","          ",
                      "          ","          ","          ","          ",
                      "          ","          ","William S.","William S.",
                      "William S.","William S.",
                      "William S.","William S.","William S.","William S.",
                      "William S.","William S.","William S.","William S.",
                      "William S.","William S.","William S.","William S.",
                      "William S.","William S.","William S.","William S.",
                      "William S.","William S.","William S.","William S.",
                      "William S.","William S.","William S.","William S.",
                      "William S.","William S.","William S.","William S.",
                      "William S.","William S.","William S.","William S.",
                      "William S.","William S.","William S.","William S.",
                      "          ","          ","          ","          ",
                      "          ","          ","          ","          ",
                      "          ","          "};
                      
int Highscores[] = {0,0,0,0,0,0,0,0,0,0,
                    400,390,380,370,360,350,340,330,320,310,
                    300,290,280,270,260,250,240,230,220,210,
                    200,190,180,170,160,150,140,130,120,110,
                    100,90,80,70,60,50,40,30,20,10,
                    0,0,0,0,0,0,0,0,0,0};

String CrownLijst[] = {" "," "," "," "," "," "," "," "," "," ",
                       "P","P","P","P","P","P","P","P","P","P",
                       "P","P","P","P","P","P","P","P","P","P",
                       "P","P","P","P","P","P","P","P","P","P",
                       "P","P","P","P","P","P","P","P","P","P",
                       " "," "," "," "," "," "," "," "," "," "};

int Offset1 = 0;
int Offset2 = 0;

int PlayerAngle[] = {0,270,180,90};

String Naam[] = {"Player 1  ","Player 2  ","Player 3  ","Player 4  "};
char KarakterSet[] = {'A','B','C','D','E','F','G','H','I','J','K','L','M',
                      'N','O','P','Q','R','S','T','U','V','W','X','Y','Z',
                      'a','b','c','d','e','f','g','h','i','j','k','l','m',
                      'n','o','p','q','r','s','t','u','v','w','x','y','z',
                      '0','1','2','3','4','5','6','7','8','9','-','+','_',
                      '=','.','(',',',')',';',':','<','>','?',' ','@','!'};

boolean Once[] = {false,false,false,false};
boolean CollectedFireButtons[] = {false,false,false,false};
int NumCollectedFireButtons = 0;

boolean XRepKeys[] = {false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,
                      false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,
                      false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,
                      false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,
                      false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,
                      false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false};

boolean resetGame = false;

class Highscore {
  int Score = 0;
  int playerX = 0;
  int CursorX = 0;
  int CursorY = 0;
  int KarCount = 64;
  char Cursor = '_';
  char chars[] = {' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '};
  boolean Crown = false;
  boolean RepKey[] = {false,false,false,false,false};
  
  Highscore(int tScore, int tplayerX, boolean tCrown) {

   Score = tScore;
   playerX = tplayerX;
   CursorX = 0;
   CursorY = 0;
   KarCount = 0;
   Crown = tCrown;
   Cursor = KarakterSet[KarCount];

   for (int i=0;i<NumKeysPerPlayer;i++) {
     RepKey[i] = XRepKeys[((NumKeysPerPlayer * playerX) + i)];
   }
   Once[playerX] = false;
   CollectedFireButtons[playerX] = false;
   chars = Naam[playerX].toCharArray();
   Cursor = chars[CursorX];
   for (int j=0;j<78;j++) {
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
    Joystick Joys[] = {joy3,joy4,joy1,joy2};
    
    Joys[0]=joy3;
    Joys[1]=joy4;
    Joys[2]=joy1;
    Joys[3]=joy2;
    for (int i=0;i<40;i++) { // 8;i++) {
      if (Score > Highscores[i]) {
        for(int j=38;j>=i;j--) { // 6;j>=i;j--) {
          CrownLijst[j+1]=CrownLijst[j];
          Highscores[j+1]=Highscores[j];
          NaamLijst[j+1]=NaamLijst[j];
        }
        CrownLijst[i]=((Crown)?"P":"G");
        Highscores[i]=Score;
        NaamLijst[i]=Naam[playerX];
        CursorY = i;
        for (int k=0;k<playerX;k++) {
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
  int i;
  Joystick Joys[] = {joy3,joy4,joy1,joy2};
  
  Joys[0] = joy3;
  Joys[1] = joy4;
  Joys[2] = joy1;
  Joys[3] = joy2;
  for (i=0;i<8;i++) {
    pushMatrix();
    translate(((width/2)-(((width-320)/2)*(Joys[playerX].yOrient))),((height/2)-(((height-320)/2)*(Joys[playerX].xOrient))));
    rotate(radians(PlayerAngle[playerX]));

    fill(((HumanPlayer[playerX] == true)&&(Joys[playerX].Highscore != null)&&((CursorY) == i))?(Joys[playerX].Color):(color(255,255,255)));

    textSize(20);
    textAlign(LEFT,CENTER);
    text(Order[i],-120,20*i);
    textAlign(LEFT,CENTER);
    text(NaamLijst[i],-90,20*i);
    textAlign(RIGHT,CENTER);
    text(Highscores[i],120,20*i);
    textAlign(CENTER,CENTER);
    text(CrownLijst[i],140,20*i);
    popMatrix();
  }
 }

 void Update()
 {
  int      i,j,k;
  Joystick Joys[] = {joy3,joy4,joy1,joy2};

  Joys[0] = joy3;
  Joys[1] = joy4;
  Joys[2] = joy1;
  Joys[3] = joy2;
  if ((CursorY < 40)&&(Joys[playerX].Highscore != null)&&(HumanPlayer[playerX] == true)) {
   for (j=0;j<NumKeysPerPlayer;j++)
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
         for (i=0;i<78;i++) {
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
     }
   else
     {
       RepKey[3] = false;
     }

   if (stick.getButton(MinToetsen[playerX]%TotalNumKeys).pressed())
     {
       Lampjes |= (1L<<(MinToetsen[playerX]-TranslationConstance));
       if (!(RepKey[4])) {
         for (i=0;i<78;i++) {
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
     }
   else
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
         
         for (i=0;i<78;i++) {
           if (Cursor == KarakterSet[i]) {
             KarCount = i;
             continue;
           }
         }
         
         RepKey[0] = true;
       }
     }
   else
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

         for (i=0;i<78;i++) {
           if (Cursor == KarakterSet[i]) {
             KarCount = i;
             continue;
           }
         }
         
         RepKey[2] = true;
       }
     }
   else
     {
       RepKey[2] = false;
     }

   if (stick.getButton(VuurKnoppen[playerX]%TotalNumKeys).pressed())
     {
       Lampjes |= (1L<<(VuurKnoppen[playerX]-TranslationConstance));
       if (!(RepKey[1])) {
         for (i=(0+TranslationConstance);i<(NumKeys+TranslationConstance);i++) {
           keysPressed[i]=0;
          }
         buttonPressed = false;
         CollectedFireButtons[playerX] = HumanPlayer[playerX];  // true;
         NumCollectedFireButtons = 0;

         for (j=0;j<4;j++) {
           NumCollectedFireButtons = ((CollectedFireButtons[j])?(NumCollectedFireButtons + 1):(NumCollectedFireButtons));
          }
         if (NumCollectedFireButtons == NumHumanPlayers) {
           resetGame = true;
          }
         RepKey[1] = true;
       }
     }
   else
     {
       RepKey[1] = false;
     }

   CursorX %= 10;
   playerX %= 4;
   KarCount %= 78;
   Cursor = KarakterSet[KarCount];
   chars[CursorX] = Cursor;
   Naam[playerX] = String.valueOf(chars);

   for (k=0;k<NumKeysPerPlayer;k++)
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
      println(Naam[playerX],", you dropped off the highscorelist!");
      Once[playerX] = true;
    }
  }
  else {
    NaamLijst[CursorY] = String.valueOf(chars);
  }
 }
}
