
class Bat
{
  int x,y;
  int w,h;
  int xDir = -1;
  int yDir = 0;
  int velX = 1;
  int velY = 0;
  boolean visible;
  int Score = 0;
  color kleur;
  boolean collidedWithBalls[] = {false,false,false,false,false,false,false,false,false,false};
  
  Bat(int tx,int ty,int tw,int th,color tkleur)
  {
    x=tx;
    y=ty;
    w=tw;
    h=th;
    visible=true;
    Score = 0;
    kleur=tkleur;
    velX=1;
    velY=0;
    xDir = -1;
    yDir = 0;
    for (int i=0;i<NumBalls;i++)
      collidedWithBalls[i] = false;
  }
  
  void Display()
  {
    if (visible)
    {
      pushMatrix();
      rectMode(CENTER);
      strokeJoin(BEVEL);
      strokeWeight(0);
      noStroke();
      fill(kleur);
      rect(x,y,w,h);

      fill(255);
      textSize(20);
      textAlign(LEFT);
      text(bats[0].Score,(width/2)-100,height-20);
      textAlign(RIGHT);
      text(bats[1].Score,(width/2)+100,height-20);
      popMatrix();
    }
  }
  
  void Update()
  {
    x += (xDir*velX);
    y += (yDir*velY);
    
    bats[1].xDir = -bats[0].xDir; // 2-Player mode?!

    for (int j=0;j<NumBalls;j++)
    {
      int temp = balls[j].h;
      if (((abs(x - balls[j].x) * 2) < (w + temp)) && ((abs(y - balls[j].y) * 2) < (h + temp))) {
        if (!(collidedWithBalls[j]))
        {
          Score++;
//          balls[j].yDir = -balls[j].yDir;
          collidedWithBalls[j] = true;
          balls[j].kleur = kleur;
          
            balls[j].yDir = -balls[j].yDir;
//            balls[j].velY = int(random(ballSpeed))+1;
            
            int dx = abs(x - balls[j].x);
            if ((x<balls[j].x) && (balls[j].xDir<0)) {
              balls[j].xDir = -balls[j].xDir;
            }
            else {
            if ((x>balls[j].x) && (balls[j].xDir>0)) {
              balls[j].xDir = -balls[j].xDir;
            }}
            balls[j].velX = (int((float((dx)) / float(w/2)) * float(ballSpeed)) % ballSpeed) + 1; balls[j].velX = int(float(balls[j].velX)*float(width)/float(height)); //can be 0! int(random(ballSpeed))+1;
          
            int dy = abs(y - balls[j].y);
            if ((y<balls[j].y) && (balls[j].yDir<0)) {
              balls[j].yDir = -balls[j].yDir;
            }
            else {
            if ((y>balls[j].y) && (balls[j].yDir>0)) {
              balls[j].yDir = -balls[j].yDir;
            }}
            balls[j].velY = (int((float((dy)) / float(h/2)) * float(ballSpeed)) % ballSpeed) + 1; balls[j].velY = int(float(balls[j].velY)*1); //float(width)/float(height));
        }
//        else
//        {
//          collidedWithBalls[j]=false;
//        }
      }
      else
      {
        collidedWithBalls[j]=false;
      }
    }

    if (x < (w/2))
    {
      x=w/2;
      xDir = -xDir;
    }
    if (x > (width-(w/2)))
    {
      x=width-(w/2);
      xDir = -xDir;
    }

  }
  
}
