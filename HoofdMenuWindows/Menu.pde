boolean buttonPressedMenu[] = {false,false,false,false};


class Menu {
  int    NumItems;
  int    ItemSelected;
  color  Color;
  color  ColorSelected;
  int textAngle[] = {0,270,180,90};
  int PlayerX = 0;
  String[] MenuItems;
  
  Menu(int tNumItems, color tColor, String tMenu[])
  {
    NumItems = tNumItems;
    ColorSelected = tColor;
    MenuItems = tMenu;
    Color = color(255,255,255);
    PlayerX = Player&3;
    ItemSelected = 0;
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
    for (int i = 0; i < NumItems; i++)
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
   buttonPressed=false;
   ButtonPressed();

//   if (buttonPressedMenu[PlayerX] == true) {
   if ( (tweeDeler[(5*PlayerX)+0]==false) && (((HumanPlayer[PlayerX])&&(stick!=null)&&(stick.getButton(LinksToetsen[PlayerX]).pressed()==true))||((HumanPlayer[PlayerX])&&(stick==null)&&(keyPressed)&&((keysPressed[(5*PlayerX)+0]) == LinksToetsen2[PlayerX]))))
   {
     if ((tweeDeler[(5*PlayerX)+0]) == false)
     {
       ItemSelected--;
       if (ItemSelected < 0)
         ItemSelected = (NumItems - 1);
       tweeDeler[(5*PlayerX)+0] = true;
//       keysPressed[(5*PlayerX)+0] = 0;
     }
//     else
//       tweeDeler[(5*PlayerX)+0] = false;
   }
   else
   {
     if (!keyPressed) {
       tweeDeler[(5*PlayerX)+0] = false;
     }
   }
   
   if ((tweeDeler[(5*PlayerX)+1]==false)&&(((HumanPlayer[PlayerX])&&(stick!=null)&&(stick.getButton(VuurKnoppen[PlayerX]).pressed()==true))||((HumanPlayer[PlayerX])&&(stick==null)&&(keyPressed)&&((keysPressed[(5*PlayerX)+1]) == VuurKnoppen2[PlayerX])))) // keysPressed[(5*PlayerX)+1]==((VuurKnoppen2[PlayerX])))))
   {
     if ((tweeDeler[(5*PlayerX)+1]) == false)
     {
       frameCounter = 10999; // push/force early out!
       tweeDeler[(5*PlayerX)+1] = true;
//       keysPressed[(5*PlayerX)+1] = 0;
     }
//     else
//       tweeDeler[(5*PlayerX)+1] = false;
   }
   else
   {
     if (!keyPressed)
       tweeDeler[(5*PlayerX)+1] = false;
   }
   
   if ((tweeDeler[(5*PlayerX)+2]==false)&&(((HumanPlayer[PlayerX])&&(stick!=null)&&(stick.getButton(RechtsToetsen[PlayerX]).pressed()==true))||((HumanPlayer[PlayerX])&&(stick==null)&&(keyPressed)&&((keysPressed[(5*PlayerX)+2]) == RechtsToetsen2[PlayerX])))) // keysPressed[(5*PlayerX)+2]==((RechtsToetsen2[PlayerX])))))
   {
     if ((tweeDeler[(5*PlayerX)+2]) == false)
     {
       ItemSelected++;
       if (ItemSelected >= NumItems)
         ItemSelected = 0;
       tweeDeler[(5*PlayerX)+2] = true;
//       keysPressed[(5*PlayerX)+2] = 0;
     }
//     else
//       tweeDeler[(5*PlayerX)+2] = false;
   }
   else
   {
     if (!keyPressed)
       tweeDeler[(5*PlayerX)+2] = false;
   }
   
   if ((tweeDeler[(5*PlayerX)+3]==false)&&(((HumanPlayer[PlayerX])&&(stick!=null)&&(stick.getButton(PlusToetsen[PlayerX]).pressed()==true))||((HumanPlayer[PlayerX])&&(stick==null)&&(keyPressed)&&((keysPressed[(5*PlayerX)+3]) == PlusToetsen2[PlayerX])))) // keysPressed[(5*PlayerX)+3]==((PlusToetsen2[PlayerX])))))
   {
     if ((tweeDeler[(5*PlayerX)+3]) == false)
     {
       ItemSelected--;
       if (ItemSelected < 0)
         ItemSelected = (NumItems - 1);
       tweeDeler[(5*PlayerX)+3] = true;
//       keysPressed[(5*PlayerX)+3] = 0;
     }
//     else
//       tweeDeler[(5*PlayerX)+3] = false;
   }
   else
   {
     if (!keyPressed)
       tweeDeler[(5*PlayerX)+3] = false;
   }
   
   if ((tweeDeler[(5*PlayerX)+4]==false)&&(((HumanPlayer[PlayerX])&&(stick!=null)&&(stick.getButton(MinToetsen[PlayerX]).pressed()==true))||((HumanPlayer[PlayerX])&&(stick==null)&&(keyPressed)&&((keysPressed[(5*PlayerX)+4]) == MinToetsen2[PlayerX])))) // keysPressed[(5*PlayerX)+4]==((MinToetsen2[PlayerX])))))
   {
     if ((tweeDeler[(5*PlayerX)+4]) == false)
       {
        ItemSelected++;
        if (ItemSelected >= NumItems)
          ItemSelected = 0;
        tweeDeler[(5*PlayerX)+4] = true;
//        keysPressed[(5*PlayerX)+4] = 0;
       }
//       else
//         tweeDeler[(5*PlayerX)+4] = false;
   }
   else
   {
     if (!keyPressed)
       tweeDeler[(5*PlayerX)+4] = false;
   }
      
   ItemSelected = (ItemSelected % NumItems);
   buttonPressedMenu[PlayerX] = false;
//  }
 }
  
}

boolean tweeDeler[] = {false,false,false,false,false,
                       false,false,false,false,false,
                       false,false,false,false,false,
                       false,false,false,false,false};

//Menu Menu[] = {null,null,null,null};

String Options[] = {"Arcade 4 Player Pacman", "Arcade 4 Player Pong", "Brickwall demo", "Gyruss demo"};
