cd $HOME
sudo processing-4.3/processing-java --sketch="Arcade-4-Player-Games/HoofdMenuLinux" --run >output.lst 2>errors.lst
fgrep "sudo" output.lst >StartThis.sh
sh StartThis.sh
