/******************************/
/*    HoofdMenu / MainMenu    */
/*  © 2024-2025  AssortiMens  */
/* (w) 2024-2025 William Senn */
/******************************/

import ddf.minim.*;
import org.gamecontrolplus.*;
import java.*;
import processing.serial.*;

Serial serial           = null;
Minim  minim            = null;

AudioPlayer   titlesong = null;

ControlIO     control   = null;
ControlDevice stick     = null;

int Lampjes             = 0;
int frameCounter        = 0;

int NumKeys              = 20; /* 20 voor de kast / Arduino */
int TotalNumKeys         = 120; // Normal keyboard, use 20 out of 120
int TranslationConstance = 0; // 0 for no translation and kast / Arduino. 1 for PC. 11 for macosx.
int NumKeysPerPlayer     = 5;

int LinksToetsen[] =  {TranslationConstance+0, TranslationConstance+5, TranslationConstance+10, TranslationConstance+15};
int VuurKnoppen[] =   {TranslationConstance+1, TranslationConstance+6, TranslationConstance+11, TranslationConstance+16};
int RechtsToetsen[] = {TranslationConstance+2, TranslationConstance+7, TranslationConstance+12, TranslationConstance+17};
int PlusToetsen[] =   {TranslationConstance+3, TranslationConstance+8, TranslationConstance+13, TranslationConstance+18};
int MinToetsen[] =    {TranslationConstance+4, TranslationConstance+9, TranslationConstance+14, TranslationConstance+19};

int Player              = 0;
int Key                 = 0;

int keysPressed[] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};

boolean buttonPressed = false;
boolean HumanPlayer[] = {false, false, false, false};

int NumHumanPlayers   = 0;

void setup()
{
  fullScreen();
  //size(800,600);
  noCursor();
  frameRate(100);

  try {
    control = ControlIO.getInstance(this);
    if (control != null)
      {
        println(control.deviceListToText(""));
        stick = control.getDevice("Arduino Leonardo"); // devicename (inside double-quotes!) or device number (without the double-quotes!) here.
      }
    else
      {
        if ((control == null)||(stick == null))
          {
            println("Could not get device! (control or stick == null)");
          }
      }
  }
  catch (Exception e) {
    println("No Arduino found or no Toetsenbord/Keyboard configured!");
    System.exit(0);
  }
  try {
    minim = null;
    minim = new Minim(this);
    if (minim != null) {
      titlesong = null;
      titlesong = minim.loadFile("data/12-dreams.mp3");
      if ((titlesong == null)) {
        println("Music / SFX failed to load!");
        System.exit(0);
      }
    }
    else {
      println("minim == null !!");
      System.exit(0);
    }
  }
  catch (Exception e) {
    println("No sounds found!");
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

  titlesong.loop();

  Lampjes = 0;
  ser_Build_Msg_String_And_Send(Lampjes);
  
  frameCounter = 0;
}

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

int TextAngle = 0;
int ChosenOne[] = {0,0,0,0}; // num items should reflect the number of players.

void draw()
{
  Lampjes = 0;

  background(0);
  
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
    }
   else
    {
      Lampjes = 0;
    }
  }

  if ((frameCounter>=0)&&(frameCounter<1000))
    HM_Demo1();
  if ((frameCounter>=1000)&&(frameCounter<2000))
    HM_Demo2();
  if ((frameCounter>=2000)&&(frameCounter<3000))
    HM_Demo3();
  if ((frameCounter>=3000)&&(frameCounter<4000))
    HM_Demo4();

  buttonPressed = false;
  if (frameCounter < 4000)
    ButtonPressed();
  if ((buttonPressed)&&(frameCounter<10000)) {
    //    initGame();
//    InitialiseAllVariables();
//    initGame();
    if (joy1 == null)
      joy1 = new Joystick(color(255,0,255));
    if (joy2 == null)
      joy2 = new Joystick(color(255,0,0));
    if (joy3 == null)
      joy3 = new Joystick(color(0,0,255));
    if (joy4 == null)
      joy4 = new Joystick(color(0,255,0));
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
  }

  if (frameCounter == 10999)
   {
      int ChosenFour = (ChosenOne[0] | ChosenOne[1] | ChosenOne[2] | ChosenOne[3]);
      int exitVal = 1;      
//      try {
//        try {
        String cmdString[] = {"sudo processing-4.3.1/processing-java --sketch=\"Arcade-4-Player-Games-kopie/Arcade-4-Player-Pacman/PCM\" --run",
                              "sudo processing-4.3.1/processing-java --sketch=\"Arcade-4-Player-Games-kopie/Arcade-4-Player-Pong/FPP\" --run"};
//        Runtime rt = Runtime.getRuntime();
        Process pr = null;
//        int exitVal = 1; //pr.waitFor();

        switch(ChosenFour & 1)
         {
           case 0:
            {
             println(cmdString[0]);
             exitVal = 1;
             System.exit(0);

            try{
              pr = Runtime.getRuntime().exec(cmdString[0],null,null);
            }
            catch(IOException e) {
              println(e.toString());
              e.printStackTrace();
              System.exit(0);
            }
            try {
               if (pr != null) {
                 while((pr.waitFor() == 1) && (exitVal != 0))
                  {
                   exitVal = pr.exitValue();
                  }
//             exitVal = pr.exitValue();
               }
             }
             catch(InterruptedException e) {
               println(e.toString());
               e.printStackTrace();
               System.exit(0);
             }
             
             break;
            }
           case 1:
            {
             println(cmdString[1]);
             exitVal = 1;
             System.exit(1);

             try{
               pr = Runtime.getRuntime().exec(cmdString[1],null,null); // "processing-java","--sketch=\"../Arcade 4 Player Pong/FPP\"","--run");
             }
             catch(IOException e) {
               println(e.toString());
               e.printStackTrace();
               System.exit(1);
             }

             try{
               if (pr != null) {
                 while((pr.waitFor() == 1) && (exitVal != 0))
                  {
                    exitVal = pr.exitValue();
                  }
//               exitVal = pr.exitValue();
               }
             }
             catch(InterruptedException e) {
               println(e.toString());
               e.printStackTrace();
               System.exit(1);
             }
             break;
            }
        }
//       println(exitVal);
//      }
//      catch(InterruptedException e) {
//        println(e.toString());
//        e.printStackTrace();
//        System.exit(-1);
//      }
//      }
//      catch(IOException e) {
//        println(e.toString());
//        e.printStackTrace();
//        System.exit(-1);
//      }
      
//      System.exit(exitVal);
//    }
   }

  ser_Build_Msg_String_And_Send(Lampjes);

  frameCounter++;
  if (frameCounter >= 4000)
    if (frameCounter >= 10000)
      if (frameCounter < 11000)
        ;
      else
        frameCounter = 0;
    else
      frameCounter = 0;
//  else
//    frameCounter = 0;
}

boolean Opkomst = true;
int TextKleur = -1;
int TextSize = 20;

void HM_Demo1()
{
  pushMatrix();
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
  text("AssortiMens presents", 0, -50);
  text("4-Player Games", 0, -12);
  text("Main Menu", 0, 12);
  text("© 2024-2025", 0, 50);

  fill(255);
  text("Press a key to play!", 0, 230-55);

  //  println(TextKleur); // debug info
  //  println(frameCounter); // debug info

  popMatrix();
}

void HM_Demo2()
{
  pushMatrix();
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
  text("Programming", 0, -50);
  text("William Senn", 0, 0);
  text("© 2024-2025", 0, 50);

  fill(255);
  text("Press a key to play!", 0, 230-55);

  //  println(TextKleur); // debug info
  //  println(frameCounter); // debug info

  popMatrix();
}

void HM_Demo3()
{
  pushMatrix();
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
  text("Graphics & GFX", 0, -50);
  text("William Senn", 0, 0);
  text("© 2024-2025", 0, 50);

  fill(255);
  text("Press a key to play!", 0, 230-55);

  //  println(TextKleur); // debug info
  //  println(frameCounter); // debug info

  popMatrix();
}

void HM_Demo4()
{
  pushMatrix();
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
  text("Music & SFX", 0, -50);
  text("Longzijun & William Senn", 0, 0);
  text("© 2024-2025", 0, 50);

  fill(255);
  text("Press a key to play!", 0, 230-55);

  //  println(TextKleur); // debug info
  //  println(frameCounter); // debug info

  popMatrix();
}

void ButtonPressed() {
  buttonPressed = false;
  for (int z=TranslationConstance; z<(NumKeys+TranslationConstance); z++) {
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

class Joystick {
  Menu      Menu = null;
  int       Angle = 0;
  int       Angles[] = {0,270,180,90};
  color     Color = color(255);

  Joystick(color tColor) {
    Color = tColor;
    Menu = null;
  }

  void Display() {
  } // End of Joystick.Display()

  void Update() {
  } // End of Joystick.Update

} // End of class Joystick

Joystick joy1 = null;
Joystick joy2 = null;
Joystick joy3 = null;
Joystick joy4 = null;

String Naam[] = {"Player 1  ", "Player 2  ", "Player 3  ", "Player 4  "};
