#!/bin/sh

workPath=${0%/*}/
Project_Name=CashGift

cd $workPath
pod install

open $workPath/$Project_Name.xcworkspace
