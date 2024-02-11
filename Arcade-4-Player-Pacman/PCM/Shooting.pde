class Shooting
{
  float x,y;
  int w,h;
  float velx, vely;
  color Kleurtje;
  
  Shooting(float tx, float ty, int tw, int th, float tvelx, float tvely)
  {
    x = tx; y = ty; w = tw; h = th;
    velx = tvelx; vely = tvely;
    Kleurtje = color(255,255,255,255);
  }
  
  void Display()
  {
    pushMatrix();
    rectMode(CENTER);
    fill(Kleurtje);
    rect(x,y,w,h);
    popMatrix();
  }
  
  void Update()
  {
    x += velx;
    y += vely;

    Joystick Joys[] = {joy3,joy4,joy1,joy2};

    Joys[0] = joy3;
    Joys[1] = joy4;
    Joys[2] = joy1;
    Joys[3] = joy2;

    for (int i=0;i<4;i++) {
      if (Joys[i].PlayerIsGhost != null)
        if (dist(x,y,Joys[i].PlayerIsGhost.pos.x,Joys[i].PlayerIsGhost.pos.y) < 10) {
          Explosion.trigger(); // ghost explodes!
          Joys[i].PlayerIsGhost.GhostExploded = true;
        }
      if (Joys[i].AIGhost != null)
        if (dist(x,y,Joys[i].AIGhost.pos.x,Joys[i].AIGhost.pos.y) < 10) {
          Explosion.trigger(); // ghost explodes!
          Joys[i].AIGhost.GhostExploded = true;
        }
    }
  }

}
