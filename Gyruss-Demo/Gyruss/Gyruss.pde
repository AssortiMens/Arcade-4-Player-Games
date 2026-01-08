/******************************/
/*    Gyruss Achtige Game     */
/* © 2025 - 2026 William Senn */
/******************************/

import ddf.minim.*;
import org.gamecontrolplus.*;

void setup()
{
  fullScreen();
//  size(1000,1000);

  frameRate(64);
  background(0);
  posX=width/2;
  posY=height/2;
  posX = mouseX;
  posY = mouseY;
}

int posX = 0;
int posY = 0;
int diameter = 1;
int diameter1 = 1;
int diameter2 = 1;
int Speed = 1;
int KleurIndex = 0;
boolean Opkomst = true;

color Palette[] = {color(0,0,0),color(0,0,16),color(0,0,32),color(0,0,48),color(0,0,64),color(0,0,80),color(0,0,96),color(0,0,112),color(0,0,128),color(0,0,144),color(0,0,160),color(0,0,176),color(0,0,192),color(0,0,208),color(0,0,224),color(0,0,240)};
color Kleur = Palette[KleurIndex];

void draw()
{
//  background(0);
//  fill(0);

  posX = mouseX;
  posY = mouseY;

  pushMatrix();
  if (diameter1 <= (width+height))
    {
      fill(Kleur=color(0,0,KleurIndex*16)); stroke(Kleur=color(0,0,KleurIndex*16)); // Palette[KleurIndex]);stroke(Kleur=Palette[KleurIndex]);
      diameter = diameter1;
    }
  else
  if (diameter2 <= (width+height))
    {
      fill(Kleur=color(0,0,KleurIndex*16)); stroke(color(0,0,KleurIndex*16)); //Palette[KleurIndex]);stroke(Kleur=Palette[KleurIndex]); //^127);stroke(Kleur^127);
      diameter = diameter2;
    }

  ellipse(posX,posY,diameter,diameter);

  if (diameter1 <= (width+height))
    {
      diameter1 += Speed;
      diameter = diameter1;
//      KleurIndex++;
      KleurIndex = KleurIndex % 256; KleurIndex &= 255;
    }
  else
  if (diameter2 <= (width+height))
    {
      diameter2 += Speed;
      diameter = diameter2;
//      KleurIndex--;
      KleurIndex = KleurIndex % 256; KleurIndex &= 255;
    }
  
  if (diameter2 > (width+height))
   {
     diameter = diameter1 = diameter2 = 1;
   }

  if (Opkomst) {
    KleurIndex++;
    if (KleurIndex>=15)
      Opkomst=false;
  }
  else {
    KleurIndex--;
    if (KleurIndex<=0)
      Opkomst=true;
  }

  popMatrix();
  
  println(KleurIndex,Speed);
//  Kleur = Palette[(KleurIndex)&7];
//  KleurIndex++;KleurIndex&=7;
  Speed++;
//  Speed = Speed*2;//KleurIndex * 16; //KleurIndex; //++;
  if (Speed > 255) {
    Speed = 255;
//    System.exit(0);
  }
}
