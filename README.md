# TheInterviewer
An app designed to guide the interviewer in a BPM interview.
This prototype was implemented to validate a *Guided Interview structure* proposed by the author, intended to guide an *Business Process Management* analyst through a process discovery interview.

## Building the Project
Before running the project, ensure that you meet the following requirements.

* Latest XCode Installed
* *CocoaPods* dependency manager installed

Clone the project or download the *zip*, and navigate to the project folder.

### CocoaPods
Using *Homebrew* on your terminal, just run the following commands:
```
$ brew update
```

When it's done updating, install *CocoaPods*:
```
$ brew install cocoapods
```

Now, before getting into the project, be sure to install the required dependencies:
```
$ pod install
```

### XCode
Building the Messenger source code is as simple as:

1. Launch XCode
2. Open the project from the folder where you have downloaded the code using menu `File -> Open`
3. If you plan on running the prototype in a physical device, be sure to set the correct `Provisioning Profile` in the Project File
4. Build using menu `Product -> Build`
5. It may take a while to build the project for the first time.
6. Once the build is over, run on the target device using menu `Product -> Run`

## Running the Application
If you just want to test the prototype without going into the adventures of building the project, you can obtain access to the latest build via *TestFlight*.
The open access link can be found at https://testflight.apple.com/join/nX4uoSZ7.
