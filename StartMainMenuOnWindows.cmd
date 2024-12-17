echo off
cd "c:\\Users\admin\Documents"
set returnVal="cmd /c c:processing-4.3.1-windows-x64\processing-4.3.1\processing-java --sketch=c:../../Arcade-4-Player-Games-kopie/HoofdMenuWindows --run >output.lst 2>errors.lst"
echo %returnVal%
%returnVal%
find "cmd /c" <output.lst >StartThis.cmd
set Keus=StartThis.cmd
echo %Keus%
%Keus%
