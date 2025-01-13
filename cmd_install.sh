#!/bin/bash
echo "pod clean > delete > install 🚀"
pod cache clean --all
rm -rf Pods Podfile.lock
pod install

echo "carthage update 🚀"
rm -rf Carthage Cartfile.resolved
carthage update
#carthage update --use-xcframeworks --platform iOS 
