@echo off
cd src
"C:\Program Files\Java\jdk-10.0.1\bin\jar" -cMf ../"%1" .
cd ..
adb push "%1" "/sdcard/%1"
adb shell am start -S -n "org.love2d.android/.GameActivity" -d "file:///sdcard/%1"
start cmd /C debug.bat