#! /bin/bash

# Name of the project & target
read -p "Name of the project target : " PROJECT
TARGET="${PROJECT}"

# min os target
TARGET_DEPLOYMENT=12.0
read -p "Deployment target : " TARGET_DEPLOYMENT
echo "Target Deployment is ${TARGET_DEPLOYMENT}"

# Check if we should add tests targets
read -p "Include Tests ? y/n : " TARGET_SHOULD_INCLUDE_TESTS
if [[ $TARGET_SHOULD_INCLUDE_TESTS = 'y' || $TARGET_SHOULD_INCLUDE_TESTS = 'Y' ]]
then
# Target Tests
TARGET_TESTS="${TARGET}Tests"
read -p "Name of the Tests target is ${TARGET_TESTS} ? y/n : " TARGET_TESTS_USER
if [[ $TARGET_TESTS_USER = 'n' || $TARGET_TESTS_USER = 'N' ]]
then
  read -p "Rename the Tests target for : " TARGET_TESTS_USER
  TARGET_TESTS="${TARGET_TESTS_USER}"
  echo "Tests target changed for ${TARGET_TESTS}"
fi
  
# Target UITests
TARGET_UITESTS="${TARGET}UITests"
read -p "Name of the UITests target is ${TARGET_UITESTS} ? y/n : " TARGET_UITESTS_USER
if [[ $TARGET_UITESTS_USER = 'n' || $TARGET_UITESTS_USER = 'N' ]]
then
  read -p "Rename the UITests target for : " TARGET_UITESTS_USER
  TARGET_UITESTS="${TARGET_UITESTS_USER}"
  echo "UITests target changed for ${TARGET_UITESTS}"
fi

# Pod config with tests
POD_CONFIG="install! 'cocoapods', :warn_for_unused_master_specs_repo => false
platform :ios, '${TARGET_DEPLOYMENT}'
use_frameworks!
inhibit_all_warnings!

target '${TARGET}' do
  pod 'Swinject'
  pod 'SwinjectAutoregistration'

  target '${TARGET_TESTS}' do
    inherit! :search_paths
    pod 'InstantMock'
    pod 'OHHTTPStubs/Swift'
  end

  target '${TARGET_UITESTS}' do
  end
end
"
else
# Pod config without tests
POD_CONFIG="install! 'cocoapods', :warn_for_unused_master_specs_repo => false
platform :ios, '${TARGET_DEPLOYMENT}'
use_frameworks!
inhibit_all_warnings!

target '${TARGET}' do
  pod 'Swinject'
  pod 'SwinjectAutoregistration'
end
"
fi

# file
cd ..
mv Setup\ Clean\ Swift/Clean\ Swift\ Setup ${PROJECT}

# check if the project exists & if it's a directory
if [[ -e $PROJECT && -d $PROJECT ]]
then
  # Pod config
  pod init
  rm -f Podfile
  echo "$POD_CONFIG" >> Podfile
  pod install

  # Depends 🤷‍♂️
  # Try to find a way to don't drag and drop
  echo "––––––––––––––––––––––––––––"
  echo "Please Drag & Drop the folder Clean-Swift-Setup directory"
  echo "This directory contains all the boilerplate for a Clean Swift setup app"
  open -a Finder $PWD
  open -a Xcode "${PROJECT}.xcworkspace"

# Project was not found
else
  # Handle this error later
  echo "Didn't find the project, please try again"
fi

# Finish
echo "Thank your for using my tool :)"
rm -rf Setup\ Clean\ Swift
