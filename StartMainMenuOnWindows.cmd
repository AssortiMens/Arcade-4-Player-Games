echo off
cd "c:\\Gebruikers\William Senn\Documenten"
set returnVal="cmd /c processing cli --sketch=./HoofdMenuWindows --run >output.lst 2>errors.lst"
echo %returnVal%
%returnVal%
find "cmd /c" <output.lst >StartThis.cmd
set Keus=StartThis.cmd
echo %Keus%
%Keus%
