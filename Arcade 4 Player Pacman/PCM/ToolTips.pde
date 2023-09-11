// File:    ToolTips.pde
// Author:  William Senn
// Purpose: To have a Round About Bonus Score show animated as a rotating Bonus Score with fade out on Opacity.

class BonusToolTip {
  color Color;
  float x,y;
  int   BonusScore;
  int   Angle;
  int   Opacity;
  
  BonusToolTip(color tColor, int tBonusScore, float tx, float ty)
  {
    Color = tColor;
    BonusScore = tBonusScore;
    x = tx; y = ty;
    Opacity = 255;
    Angle = 0;
  }

  void Display()
  {
    pushMatrix();
    fill(Color,Opacity);
    translate(x,y); // ghost.x, ghost.y
    rotate(radians(Angle));
    textAlign(CENTER,CENTER);
    textSize(20);
    text(BonusScore,0,0);
    popMatrix();
  }
  
  void Update()
  {
    Angle += 10;
    Angle %= 360;
    
    y--;
    if (y<0)
      y=0;

    if (Opacity==255)
      BonusSound.trigger(); // trigger bonus sound once
    Opacity--;
    if (Opacity<0)
      Opacity=0;
  }

}
