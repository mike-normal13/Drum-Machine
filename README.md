# Drum-Machine
A basic drum machine for iPhone written in Swift. Created initially as a final projet for CS 4962(mobile application development) at the University of Utah. Total development time upon first release (including time for research and debugging), upwards of 100 hours.

# Concept
As an avid producer of electronic music, I wanted to make my first audio app. This project was generally built upon the concept of Ableton Live's Impulse instrument(http://www.soundonsound.com/sos/jun07/articles/livetech_0607.htm). Going into the project, I had acquired a semester's worth of knowledge of Swift, but I knew nothing of how to use Swift to generate sound. Because of this, a large amount of exploration was needed. I finally ended up using Audio Units as the basis for sound generation.

Creating the application was a very challening, yet fun, learning experience. The application was written 100% programmatically, without the use of the StoryBoard. A considerable amount of time was spent on functionalities that were ultimatly abbandoned in time for the due date. These functionalities included real time recording/playback of user sound triggering, rendering a midi or wav file of a recorded session, having a limiter on the master output, and sound meters. I very much look forward to implementing these functionalities.

# The Application
The final submission of the project ended up being a basic version of Impulse, with a Metronome. Upon launching the app, the user is alowed the choice between loading a saved project and creating a new project. Upon creating a new project, the user is allowed to enter the project's name and number of measures. The app assumes 4/4 timing. Once the project is created the user is presented with the Play View.

The Play view allows the user to start and stop the metronome, enable recording mode, play each of five selected sounds, configure each of the five sounds, save and load a project, start a new project, and adjust the master volume for the project.
In order to load/configure a sound for one of the sound slots, the user must press one of the sound slots and then press the configure button. Upon loading/configuring a sound, the user is presented with the Configure View.
The Configuration View allows the user to choose a sound to load, and preview the sound once loaded. The Configuration View also allows the user to configure the loaded sound through various controls. The controls include "Start", "Transpose", "Stretch", "Decay", "Pan", and "Volume".

The "Start" control alows the user to adjust the starting point of where the sound is played back in milliseconds.
The "Tranpose" control allows the user to adjust the pitch of the sound, in semitones, by changing the rate of playback via the VariSpeed Audio Unit, as well as adjusting the randomization of the pitch for any given triggering of the sound. 
THe "Stretch" control alows the user to adjust the pitch and rate of the sound independent of each other, as well as adjusting the quality of stretching the sound via the TimePitch Audio Unit.
The "Decay" control allows the user to adjust the duration of playback in milliseconds.
The "Pan" control allows the user to pan the sound from right to left, as well as adjusting the randomization of panning for any given triggering of the sound.
The "Volume" control allows the user to adjust the volume of the sound.

While viewing the Configuration View, the user can at any time choose to load a different sound by pressing the "Swap" button. Upon pressing the "Swap" button, the user will be presented with table view consisting of various sound catagories(e.g. snare, hi hat, kick, etc). Upon selecting a sound catagory the user is presented with a table view consisting of all the sound options for the selected sound catagory. The user is able to preview any of the sounds via "Play" button, and load a sound via the "Choose" button. Once a sound is chosen, the user is again presented with the Configuration View.

The user can preview a sound in the Configuration View by pressing the preview button(initially with text "No Sound Loaded"), and move back to the Play View by pressing the "Back" button.

# Skills Demonstrated By This Project
Knowledge of various components of the Swift API. Namely: UIViewController, UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate, UIControl, UITextFieldDelegate, UIView, and AVFoundation, among others. 
Compitent O.O.P. and M.V.C. practices.
Ability to independently conceptualize, design, and execute a project from start to finish in the time allotted.

# Future Plans For The Project
Implement rendering a wav file of a recorded session.
Implement Playback of recorded notes.
Implement a limiter on the master output.
Implement volume meters that alert the user of clipping.


