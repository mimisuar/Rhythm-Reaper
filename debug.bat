@echo off
adb -d logcat -c
adb -d logcat -s SDL/APP:I