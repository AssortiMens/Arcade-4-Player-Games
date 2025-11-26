/***********************/
/*      Brickwall      */
/*      A game by      */
/*    William  Senn    */
/* © 2025 William Senn */
/***********************/

import ddf.minim.*;
import org.gamecontrolplus.*;

int NumBricks = 200;
int NumBalls = 10;
int NumBats = 2;

int ballSpeed = 10;

Bat bats[] = {null,null};

Ball balls[] = {null,null,null,null,null,null,null,null,null,null};

Brick bricks[] = { null,null,null,null,null,null,null,null,null,null,
                   null,null,null,null,null,null,null,null,null,null,
                   null,null,null,null,null,null,null,null,null,null,
                   null,null,null,null,null,null,null,null,null,null,
                   null,null,null,null,null,null,null,null,null,null,
                   null,null,null,null,null,null,null,null,null,null,
                   null,null,null,null,null,null,null,null,null,null,
                   null,null,null,null,null,null,null,null,null,null,
                   null,null,null,null,null,null,null,null,null,null,
                   null,null,null,null,null,null,null,null,null,null,
                   null,null,null,null,null,null,null,null,null,null,
                   null,null,null,null,null,null,null,null,null,null,
                   null,null,null,null,null,null,null,null,null,null,
                   null,null,null,null,null,null,null,null,null,null,
                   null,null,null,null,null,null,null,null,null,null,
                   null,null,null,null,null,null,null,null,null,null,
                   null,null,null,null,null,null,null,null,null,null,
                   null,null,null,null,null,null,null,null,null,null,
                   null,null,null,null,null,null,null,null,null,null,
                   null,null,null,null,null,null,null,null,null,null
                 };

void setup()
{
  fullScreen();
  noCursor();
  frameRate(100);

  InitialiseGame();
}

void InitialiseGame()
{
  rectMode(CENTER);
  ellipseMode(CENTER);

  for (int i=0;i<NumBricks;i++)
   {
     bricks[i] = new Brick(int(((i%25)*(floor(width/25))+(floor(width/50)))), int(25*(((floor(i/25)))+(floor(height/50))-4)), int(floor(width/25)), 25, color(255,255,255)); // int(random(128)+128),0,int(random(128)+128)));
   }
  
  for (int i=0;i<NumBalls;i++)
  {
    balls[i] = new Ball(int(width/2),int(height/2),int(float(10)),int(float(10)),color(255,255,255));
  }
  
  for (int i=0;i<NumBats;i++)
  {
    bats[i] = new Bat(int(float(i*100)+(width/2)-50),int(float((height-50))),int(float(100)),int(float(20)),color((random(64)+192)*(i&1),0,(random(64)+192)*((i&1)^1)));
  }
  
}

void draw()
{
  background(0);
  DisplayAll();
  UpdateAll();
}

int Invisiblebricks;

void DisplayAll()
{
  Invisiblebricks=0;
  
  for(int i=0;i<NumBricks;i++)
  {
    if (bricks[i].visible)
     {
       bricks[i].Display();
     }
    else
      Invisiblebricks++;
  }

  for(int i=0;i<NumBalls;i++)
  {
    if (balls[i].visible)
     {
       balls[i].Display();
     }
  }

  for(int i=0;i<NumBats;i++)
  {
    if (bats[i].visible)
     {
       bats[i].Display();
     }
  }
  
}

void UpdateAll()
{
  for(int brick=0;brick<NumBricks;brick++) {
    if(bricks[brick].visible)
      bricks[brick].Update();
  }
    
  for(int ball=0;ball<NumBalls;ball++)
  {
    if (balls[ball].visible)
     {
       balls[ball].Update();
     }
  }

  for(int bat=0;bat<NumBats;bat++) {
    if (bats[bat].visible)
      bats[bat].Update();
  }

  if (Invisiblebricks==NumBricks)
   {
     println(bats[0].Score);
     println(bats[1].Score);
     System.exit(0);
   }
    
}
