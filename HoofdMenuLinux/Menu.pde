class Menu {
  int    NumItems,ItemSelected = 0;
  color  Color;
  color  ColorSelected;
  String[] MenuItems;
  int textAngle[] = {0,270,180,90};
  int PlayerX = 0;
  
  Menu(int tNumItems, color tColor, String[] tMenu)
  {
    NumItems = tNumItems;
    ColorSelected = tColor;
    MenuItems = tMenu;
    Color = color(255,255,255);
    PlayerX = Player&3;
  }

  void Display(int PlayerC)
  { // Draw the menu here
    PlayerX = (PlayerC & 3);
    pushMatrix();
    textAlign(CENTER,CENTER);
    fill(255);
    textSize(24);
    translate((width/2)-((width/4)*sin(radians(textAngle[PlayerX]))),(height/2)+((height/4)*cos(radians(textAngle[PlayerX]))));
    rotate(radians(textAngle[PlayerX]));
    text("Choose (Color!):",0,-25); // Menu header
    for (int i=0;i<NumItems;i++)
     {
      fill(Color);
      if (i == ItemSelected)
        fill(ColorSelected);
      text(MenuItems[i],0,25*i);
     }
    popMatrix();
  }
  
  void Update(int PlayerZ)
  {
    // Update or Change the menu here
    // read keys
    // change menu according to keys

   PlayerX = (PlayerZ & 3);
   
   if ((HumanPlayer[PlayerX])&&(stick.getButton(LinksToetsen[PlayerX]).pressed() == true))
   {
     if (!(tweeDeler[(5*PlayerX)+0]))
     {
       ItemSelected--;
       tweeDeler[(5*PlayerX)+0] = true;
     }
   }
   else
   {
     tweeDeler[(5*PlayerX)+0] = false;
   }
   
   if ((HumanPlayer[PlayerX])&&(stick.getButton(RechtsToetsen[PlayerX]).pressed() == true))
   {
     if (!(tweeDeler[(5*PlayerX)+2]))
     {
       ItemSelected++;
       tweeDeler[(5*PlayerX)+2] = true;
     }
   }
   else
   {
     tweeDeler[(5*PlayerX)+2] = false;
   }
   
   if ((HumanPlayer[PlayerX])&&(stick.getButton(PlusToetsen[PlayerX]).pressed() == true))
   {
     if (!(tweeDeler[(5*PlayerX)+3]))
     {
       ItemSelected--;
       tweeDeler[(5*PlayerX)+3] = true;
     }
   }
   else
   {
     tweeDeler[(5*PlayerX)+3] = false;
   }
   
   if ((HumanPlayer[PlayerX])&&(stick.getButton(MinToetsen[PlayerX]).pressed() == true))
   {
     if (!(tweeDeler[(5*PlayerX)+4]))
       {
        ItemSelected++;
        tweeDeler[(5*PlayerX)+4] = true;
       }
   }
   else
   {
     tweeDeler[(5*PlayerX)+4] = false;
   }
      
   if (ItemSelected < 0)
      ItemSelected = NumItems-1;
   if (ItemSelected > NumItems-1)
      ItemSelected = 0;
   ItemSelected %= NumItems;
  }
  
}

boolean tweeDeler[] = {false,false,false,false,false,
                       false,false,false,false,false,
                       false,false,false,false,false,
                       false,false,false,false,false};

Menu Menu = null;

String Options[] = {"Arcade 4 Player Pacman", "Arcade 4 Player Pong"};
