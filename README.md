# idea computer

An app that generates prompts and optionally an image for artists to use as inspiration.  
This app was created as a friend of mine was hoping to see something cool like this!

![Android Example](https://raw.githubusercontent.com/fishydarwin/idea-computer/main/github_assets/android_example.png)

Currently only designed & tested on **Android**, but **iOS** version is coming soon.  
This app was made using **Flutter**.

## Web Server

The images are generated using StabilityAI/SD-Turbo (specifically pre-trained from HuggingFace).  
Inside `extra`, a module is placed which hosts a basic Flask server (as well as a `start.sh` file).

You **must** have said web server open for this application to work.  
This web server leaves some things to be desired to be fair, but hopefully I can update it soon.
### !!! Do note that no security is placed and you can abuse the `/generated/` endpoint!

## This README.md file will be updated further once I figure out what I want to put here.