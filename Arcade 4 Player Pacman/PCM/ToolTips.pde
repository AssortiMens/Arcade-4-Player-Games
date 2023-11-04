// File:    ToolTips.pde
// Author:  William Senn
// Purpose: To have a Round About Bonus Score show animated as a rotating Bonus Score with fade out on Opacity.

class BonusToolTip {
  color Color;
  float x,y;
  int   BonusScore;
//  int   Angle;
  int   Opacity;
  int   Angles[] = {0,270,180,90};
  int   PlayerX=0;
  int   PacManIndex1 = 0, PacManIndex2 = 0;
  
  BonusToolTip(color tColor, int tBonusScore, float tx, float ty)
  {
    Color = tColor;
    BonusScore = tBonusScore;
    x = tx; y = ty;
    Opacity = 255;
    PlayerX = 0;
    Joystick Joys[] = {joy3,joy4,joy1,joy2};
    
    Joys[0] = joy3;
    Joys[1] = joy4;
    Joys[2] = joy1;
    Joys[3] = joy2;
    
    if ((Joys[0].PlayerIsPacman != null)) {
      PlayerX = 0;
//      y--;
//      if (y<0)
//        y=0;
    }
    else
    if ((Joys[1].PlayerIsPacman != null)) {
      PlayerX = 1;
//      x--;
//      if (x<0)
//        x=0;
    }
    else
    if ((Joys[2].PlayerIsPacman != null)){
      PlayerX = 2;
//      y++;
//      if (y>height)
//        y = height;
    }
    else
    if ((Joys[3].PlayerIsPacman != null)){
      PlayerX = 3;
//      x++;
//      if (x>width)
//        x=width;
    }

//    Angle = Angles[n&3];
    PacManIndex1 = PlayerX & 3;
    PacManIndex2 = PlayerX & 3;

    if ((NumPacMans == 2)) {
      // continue from n+1 till n==3
      PacManIndex2 = (PlayerX + 1);
      for (int i = (PlayerX + 1); i < 4;i++) {
        if (Joys[i].PlayerIsPacman != null) {
          PacManIndex2 = i;
          continue;
        }
      }
    }
// second pacman = PacManIndex2 !!

// Onderstaande code is nog ambigu !!!
//   Display moet rechtstreeks uit de angles array lezen !!

    if ((PacManIndex1 == PacManIndex2) && (NumPacMans == 1)) {
      Joys[PacManIndex1 & 3].Angle = Angles[PacManIndex1 & 3]; // rmw-cycle
      Angles[PacManIndex1 & 3] = Joys[PacManIndex1 & 3].Angle;
    }
    else {
      if ((PacManIndex1 != PacManIndex2) && (NumPacMans == 2)) {
        Joys[PacManIndex1 & 3].Angle = Angles[PacManIndex1 & 3]; // rmw-cycles
        Angles[PacManIndex1 & 3] = Joys[PacManIndex1 & 3].Angle;
        
        Joys[PacManIndex2 & 3].Angle = Angles[PacManIndex2 & 3]; // rmw-cycles
        Angles[PacManIndex2 & 3] = Joys[PacManIndex2 & 3].Angle;
      }
      else {
      // Error Inconsequent Indexes or NumPacMans is wrong, should never be executed!
        println("Constructor code incorrect or ambiguity not solved!");
      }
    }
  } // End of Constructor

  void Display()
  {
    Joystick Joys[] = {joy3,joy4,joy1,joy2};
    
    Joys[0] = joy3;
    Joys[1] = joy4;
    Joys[2] = joy1;
    Joys[3] = joy2;
    pushMatrix();
    fill(Color,Opacity);
    translate(x,y); // ghost.x, ghost.y
    if (NumPacMans == 1) {
      Joys[PacManIndex1 & 3].Angle = Angles[PacManIndex1 & 3];
      rotate(radians(Joys[PacManIndex1 & 3].Angle));
    }
    else {
      if (NumPacMans == 2) {
        Joys[PacManIndex1 & 3].Angle = Angles[PacManIndex1 & 3];
        rotate(radians(Joys[PacManIndex1 & 3].Angle));
        
        Joys[PacManIndex2 & 3].Angle = Angles[PacManIndex2 & 3];
        rotate(radians(Joys[PacManIndex2 & 3].Angle));
      }
      else {
        // should never be executed!
        println("Fatal ERROR in BonusToolTip.Display()");
      }
    }

    textAlign(CENTER,CENTER);
    textSize(20);
    text(BonusScore,0,0);
    popMatrix();
  } // End of Display()
  
  void Update()
  {
    Joystick Joys[] = {joy3,joy4,joy1,joy2};
    
    Joys[0] = joy3;
    Joys[1] = joy4;
    Joys[2] = joy1;
    Joys[3] = joy2;
    
    if ((Joys[0].PlayerIsPacman != null)) {
      PlayerX = 0;
//      y--;
      if (y<0)
        y=0;
    }
    else
    if ((Joys[1].PlayerIsPacman != null)) {
      PlayerX = 1;
//      x--;
      if (x<0)
        x=0;
    }
    else
    if ((Joys[2].PlayerIsPacman != null)){
      PlayerX = 2;
//      y++;
      if (y>height)
        y = height;
    }
    else
    if ((Joys[3].PlayerIsPacman != null)){
      PlayerX = 3;
//      x++;
      if (x>width)
        x=width;
    }

    if ((PacManIndex1 == PacManIndex2)&&(NumPacMans == 1)) {
      Joys[PlayerX & 3].Angle = Angles[PacManIndex1 & 3];
      Joys[PlayerX & 3].Angle += 6;
      Joys[PlayerX & 3].Angle %= 360;
      Angles[PacManIndex1 & 3] = Joys[PlayerX].Angle;
    }
    else {
      if ((PacManIndex1 != PacManIndex2)&&(NumPacMans == 2)) {
        Joys[PacManIndex1 & 3].Angle = Angles[PacManIndex1 & 3];
        Joys[PacManIndex1 & 3].Angle += 6;
        Joys[PacManIndex1 & 3].Angle %= 360;
        Angles[PacManIndex1 & 3] = Joys[PacManIndex1 & 3].Angle;

        Joys[PacManIndex2 & 3].Angle = Angles[PacManIndex2 & 3];
        Joys[PacManIndex2 & 3].Angle += 6;
        Joys[PacManIndex2 & 3].Angle %= 360;
        Angles[PacManIndex2 & 3] = Joys[PacManIndex2 & 3].Angle;
      }
      else {
        // Should never be executed !!
        println("Fatal error in BonusToolTip.Update(), should never be executed!");
      }
    }
    
    if (Opacity==255)
      BonusSound.trigger(); // trigger bonus sound once
    Opacity--;
    if (Opacity<0)
      Opacity=0;
  } // End of Update()

} // End of class BonusToolTip
