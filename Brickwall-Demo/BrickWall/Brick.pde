
color palette[] = {color(50,0,50),color(100,0,100),color(150,0,150),color(200,0,200),color(250,0,250)};

class Brick
{
  int x,y;
  int w,h;
  int type;
  int count;
  int HAngle;
  color kleur;
  boolean visible;
  boolean collidedWithBricks[] = {false,false,false,false,false,false,false,false,false,false};
  
  Brick(int tx,int ty,int tw,int th,color tkleur)
  {
    x=tx;
    y=ty;
    w=tw;
    h=th;
    kleur=tkleur;
    visible=true;
    type = Dirs[int(random(2))];
    count = int(random(5))+1;
    HAngle = 0;
    kleur = palette[count-1]; // color(int(255L/count)&255L,0L,int(255L/count)&255L,255L);
    for (int i=0;i<NumBalls;i++)
      collidedWithBricks[i]=false;
  }
  
  void Display()
  {
    if (visible)
    {
      pushMatrix();
      rectMode(CENTER);
      strokeJoin(BEVEL); // ROUND, MITER, BEVEL
      strokeWeight(1);
      stroke(255,0,0,100);
//      noStroke();
      fill(kleur);
      rect(x,y,w,h);
      fill(255);
      textAlign(CENTER,CENTER);
      textSize(20);
      text(count,x,y);
      popMatrix();
    }
  }
  
  void Update()
  {
    if (visible) {
//      type = count - 1;
      x += int(/*5.0*/ float(count) * float(type) * cos(radians(HAngle)));
      y += int(/*5.0*/ float(count) * float(type) * sin(radians(HAngle)));
      HAngle++;
      HAngle %= 360;
    
      for (int j=0;j<NumBalls;j++)
      {
        int balletje = j;

      int temp = balls[balletje].h;
      if (((abs(x - balls[balletje].x) * 2) < (w + temp)) && ((abs(y - balls[balletje].y) * 2) < (h + temp))) {
        if (!(collidedWithBricks[balletje]))
        {
          if (balls[balletje].kleur == bats[0].kleur)
            bats[0].Score += 100;
          else
          if (balls[balletje].kleur == bats[1].kleur)
            bats[1].Score += 100;
          else
           {
             bats[0].Score += 50;
             bats[1].Score += 50;
           }
           
          collidedWithBricks[balletje] = true;
          
          count--;
          if (count > 0)
            kleur = palette[count-1];//color(int(255L/count),0,int(255L/count),255);
          else {
            visible = false;
            count = 0;
            kleur = color(0,0,0);
          }

//          balls[j].kleur = kleur;
            int dx = abs(x - balls[balletje].x);
            if ((x<balls[balletje].x) && (balls[balletje].xDir<0)) {
              balls[balletje].xDir = -balls[balletje].xDir;
            }
            else {
            if ((x>balls[balletje].x) && (balls[balletje].xDir>0)) {
              balls[balletje].xDir = -balls[balletje].xDir;
            }}
//            balls[balletje].velX = (int((float((dx)) / float(w/2)) * float(ballSpeed)) % ballSpeed) + 1; balls[balletje].velX = int(float(balls[balletje].velX)*float(width)/float(height)); //can be 0! int(random(ballSpeed))+1;
          
            int dy = abs(y - balls[balletje].y);
            if ((y<balls[balletje].y) && (balls[balletje].yDir<0)) {
              balls[balletje].yDir = -balls[balletje].yDir;
            }
            else {
            if ((y>balls[balletje].y) && (balls[balletje].yDir>0)) {
              balls[balletje].yDir = -balls[balletje].yDir;
            }}
//            balls[balletje].velY = (int((float((dy)) / float(h/2)) * float(ballSpeed)) % ballSpeed) + 1; balls[balletje].velY = int(float(balls[balletje].velY)*1); //float(width)/float(height));

        }
//        else
//        {
//          collidedWithBricks[j] = false;
//        }

      }
      else
      {
        collidedWithBricks[balletje] = false;
      }
     } // end for loop

    } // end if visible
  } // end update
  
} // end class
