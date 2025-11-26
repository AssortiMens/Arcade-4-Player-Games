
int Dirs[] = {-1,1};

class Ball
{
  int x,y;
  int w,h;
  int xDir = Dirs[int(random(2))];
  int yDir = Dirs[int(random(2))];
  int velX = int(random(10)+1);
  int velY = int(random(10)+1);
  boolean visible;
  color kleur;
  
  Ball(int tx,int ty,int tw,int th,color tkleur)
  {
    x=tx;
    y=ty;
    w=tw;
    h=th;
    visible = true;
    xDir=Dirs[int(random(2))];
    yDir=Dirs[int(random(2))];
    velX=int(random(ballSpeed)+1);
    velY=int(random(ballSpeed)+1);
    kleur = tkleur;
  }
  
  void Display()
  {
    if (visible)
     {
       pushMatrix();
       rectMode(CENTER);
       ellipseMode(CENTER);
       strokeJoin(BEVEL);
       strokeWeight(0);
       noStroke();
       fill(kleur);
       ellipse(x,y,w,h);
//       rect(x,y,w,h);
       popMatrix();
     }
  }
  
  void Update()
  {
    x += (xDir*velX);
    y += (yDir*velY);
    
    if ((x) < (w/2))
     {
       x=w/2;
       xDir = -xDir;
     }
    if ((x) > (width-(w/2)))
     {
       x=width-(w/2);
       xDir = -xDir;
     }
      
    if ((y) < (h/2))
     {
       y=h/2;
       yDir = -yDir;
     }
    if ((y) > (height-(h/2)))
     {
       y=height-(h/2);
       yDir = -yDir;
     }

  }

}
