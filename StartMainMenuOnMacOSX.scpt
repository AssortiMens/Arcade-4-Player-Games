cd $HOME/Downloads ;
processing cli --sketch="./HoofdMenuMacOSX" --run >output.lst 2>errors.lst ;
fgrep 'processing' output.lst >StartThis.scpt ;
chmod +x StartThis.scpt ;
./StartThis.scpt ;
exit ;
