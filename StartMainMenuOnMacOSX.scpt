cd $HOME/Downloads ;
./Arcade-4-Player-Games-main/HoofdMenuMacOSX/application.macosx/HoofdMenuMacOSX.app/Contents/MacOS/HoofdMenuMacOSX >output.lst 2>errors.lst ;
fgrep 'Arcade' output.lst >StartThis.scpt ;
chmod +x StartThis.scpt ;
./StartThis.scpt ;
exit ;
