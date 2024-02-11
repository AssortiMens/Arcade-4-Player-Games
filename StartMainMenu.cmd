echo off
cd "c:\Users\William Senn\documents"
set returnVal="cmd /c c:processing-4.3-windows-x64\processing-4.3\processing-java --sketch=c:../../Arcade-4-Player-Games-kopie/HoofdMenu --run >output.lst 2>errors.lst"
echo %returnVal%
%returnVal%
find "cmd /c" <output.lst >StartThis.cmd
set Keus=StartThis.cmd
echo %Keus%
%Keus%
