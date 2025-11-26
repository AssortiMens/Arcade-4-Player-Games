#cd '/mnt/Deelnemers/William Senn'
processing cli --sketch="./HoofdMenuLinux" --run >output.lst 2>errors.lst
fgrep "processing" output.lst >StartThis.sh
sh StartThis.sh
