setlocal
@echo off

::change to folder containing this bat file
cd %~dp0

start %1 %2
d:\Apps\HREFTools\MiscUtil\wait.exe 4
