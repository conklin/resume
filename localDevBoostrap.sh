#!/bin/sh

which -s brew
if [[ $? != 0 ]]; then
    echo "Installing Hombrew"
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
    echo "Updating Homebrew"
    brew update
fi

which -s gcloud
if [[ $? != 0 ]] ; then
    echo "Installing google-cloud-sdk" 
    brew cask install google-cloud-sdk
    gcloud init
else
    echo "Updating gcloud components"
     gcloud components update
fi

which -s terraform
if [[ $? != 0 ]] ; then
    echo "Installing terraform"
    brew install terraform
else
     echo "Updating terraform"
     brew upgrade terraform
fi