//
//  PlayViewController.swift
//  FInalProject
//
//  Created by Budge on 5/1/15.
//  Copyright (c) 2015 Budge. All rights reserved.
//

import UIKit
import AVFoundation

//  this class controls the play view
// instance of this class is owned by the LoadStartViewController
class PlayViewController: UIViewController
{
    // directory we will save midi files to
    private var _masterDocumentDirectory: String = "";
    // name of the project, passed down from LoadStartViewController
    private var _projectName: String = "";
    
    // slot configuration controller array
    private var _slotConfigViewControllerArray: [SlotConfigViewController!] = [nil, nil, nil, nil, nil];
    // index of the tile in the array that is currently highlighted
    private var _highlightedSlotIndex: Int = -1;
    //  index of the previously highlighted tile
    private var _previouslyHighlightedSlotIndex = -1;
    
    private var _playModel: PlayModel! = nil;
    private var _playView: PlayView! = nil;
    private var _clock: Clock! = nil;
    
    // thread responsible for the clock
    private var _clockThread: NSThread! = nil;
    // manages audio for the loaded sounds
    private var _mixer: Mixer! = nil;
    // manages threads for triggering sounds
    private var _opQueue: NSOperationQueue! = nil;
        
    // accessors
    var playModel: PlayModel! { return _playModel }
    var playView: PlayView
    {
        get {return _playView}
        set { _playView = newValue}
    }
    var clock: Clock { return _clock }
    var slotConfigViewControllerArray: [SlotConfigViewController!]
    {
        get {return _slotConfigViewControllerArray}
        set {_slotConfigViewControllerArray = newValue}
    }
    var highlightedSlotIndex: Int { return _highlightedSlotIndex }
    var mixer: Mixer
    {
        get {return _mixer}
        set {_mixer = newValue}
    }
    var masterDocumentDirectory: String
    {
        get { return _masterDocumentDirectory }
        set { _masterDocumentDirectory = newValue }
    }
    var projectName: String
    {
        get { return _projectName }
        set { _projectName = newValue }
    }
    
    override func loadView()
    {
        // initialize and set view
        _playView = PlayView(frame: parentViewController!.view.frame);
        view = _playView;

        _mixer = Mixer();
        _opQueue = NSOperationQueue();
            
        // set mixer's save directory and project name
        _mixer.masterDocumentDirectory = _masterDocumentDirectory;
        _mixer.projectName = _projectName;
    }
    
    override func viewDidLoad()
    {
        _playModel = PlayModel()
        // set the length of each of the 5 MusicTracks in Mixer to the number of bars entered by the user
        _mixer.setTrackLengths(_playModel.nBars);
        _clock = Clock();
        _clock.addTarget(self, action: "resetBeatAndBar", forControlEvents: UIControlEvents.TouchUpInside);
        _clock.addTarget(self, action: "resetBeatIncrementBar", forControlEvents: UIControlEvents.TouchUpOutside);
        _clock.addTarget(self, action: "incrementBeat", forControlEvents: UIControlEvents.ValueChanged);
    }
    
    //  This target was set in the LoadStartViewController
    // catches signal sent by start buttons
    func startButtonChangesStopButton(button: StartView)
    {
        // set Clock's kill flag to false
        _clock.killFlag = false;
        // intialize and fire the clock thread
        _clockThread = NSThread(target: _clock, selector: "ticTok", object: nil);
        _clockThread.start();
                
        // if the signal was sent from the left button
        if(button === _playView.topContainerView.leftStartStopContainerView.startView)
        {
            // change the right button's background to gray
            _playView.topContainerView.rightStartStopContainerView.startView.backgroundColorAccess = UIColor.grayColor()
            // change right buttons triangle to green
            _playView.topContainerView.rightStartStopContainerView.startView.triangleColor = UIColor.greenColor();
            // change right button's playingFlag to true
            _playView.topContainerView.rightStartStopContainerView.startView.playingFlag = true;
            _playView.topContainerView.rightStartStopContainerView.startView.setNeedsDisplay();
        }
        //else if the signal was sent from the right button
        else
        {
            // change the left button's background to gray
            _playView.topContainerView.leftStartStopContainerView.startView.backgroundColorAccess = UIColor.grayColor()
            // change left buttons triangle to green
            _playView.topContainerView.leftStartStopContainerView.startView.triangleColor = UIColor.greenColor();
            // change right button's playingFlag to true
            _playView.topContainerView.leftStartStopContainerView.startView.playingFlag = true;
            _playView.topContainerView.leftStartStopContainerView.startView.setNeedsDisplay();
        }
        
        // change color scheme of both stop buttons
        //  left
        _playView.topContainerView.leftStartStopContainerView.stopView.stopSquareColor = UIColor.blackColor();
        _playView.topContainerView.leftStartStopContainerView.stopView.backgroundColorAccess = UIColor.grayColor();
        //right
        _playView.topContainerView.rightStartStopContainerView.stopView.stopSquareColor = UIColor.blackColor();
        _playView.topContainerView.rightStartStopContainerView.stopView.backgroundColorAccess = UIColor.grayColor();
        
        // set both stop button's stopped flags to false
        _playView.topContainerView.leftStartStopContainerView.stopView.stoppedFlag = false;
        _playView.topContainerView.rightStartStopContainerView.stopView.stoppedFlag = false;
        
        // update stop button displays
        _playView.topContainerView.leftStartStopContainerView.stopView.setNeedsDisplay();
        _playView.topContainerView.rightStartStopContainerView.stopView.setNeedsDisplay();
        
        // if the record button is armed...
        if(_playView.topContainerView.recordView.armed == true)
        {
            //  set the record button's recording flag
            _playView.topContainerView.recordView.recording = true;
            //  set the record button to recording colors
            _playView.topContainerView.recordView.bGColor = UIColor.greenColor();
            _playView.topContainerView.recordView.circleColor = UIColor.redColor();
            
            _playView.topContainerView.recordView.setNeedsDisplay();
        }
    }
    
    // catches signal sent by stop buttons
    func stopButtonChangesStartButton(button: StopView)
    {
        // set Clock's kill flag to stop the thread
        _clock.killFlag = true;
        // cancel the clock thread
        _clockThread.cancel();
                
        // if the signal was sent from the left button
        if(button === _playView.topContainerView.leftStartStopContainerView.stopView)
        {
            // change right stop button to innopperable color scheme
            _playView.topContainerView.rightStartStopContainerView.stopView.backgroundColorAccess = UIColor.blackColor();
            _playView.topContainerView.rightStartStopContainerView.stopView.stopSquareColor = UIColor.grayColor();
            
            // change the right stop button's flag
            _playView.topContainerView.rightStartStopContainerView.stopView.stoppedFlag = true;
            _playView.topContainerView.rightStartStopContainerView.stopView.setNeedsDisplay();
        }
        //else if the signal was sent from the right button
        else
        {
            // change left stop button to innopperable color scheme
            _playView.topContainerView.leftStartStopContainerView.stopView.backgroundColorAccess = UIColor.blackColor();
            _playView.topContainerView.leftStartStopContainerView.stopView.stopSquareColor = UIColor.grayColor();
            
            // change the left stop button's flag
            _playView.topContainerView.leftStartStopContainerView.stopView.stoppedFlag = true;
            _playView.topContainerView.leftStartStopContainerView.stopView.setNeedsDisplay();
        }
        
        // change both play buttons to non-playing color scheme
        //left
        _playView.topContainerView.leftStartStopContainerView.startView.backgroundColorAccess = UIColor.blackColor();
        _playView.topContainerView.leftStartStopContainerView.startView.triangleColor = UIColor.grayColor();
        //  right
        _playView.topContainerView.rightStartStopContainerView.startView.backgroundColorAccess = UIColor.blackColor();
        _playView.topContainerView.rightStartStopContainerView.startView.triangleColor = UIColor.grayColor();

        // switch both start button's flags
        _playView.topContainerView.leftStartStopContainerView.startView.playingFlag = false;
        _playView.topContainerView.rightStartStopContainerView.startView.playingFlag = false;
        
        // update both play button's displays
        _playView.topContainerView.leftStartStopContainerView.startView.setNeedsDisplay();
        _playView.topContainerView.rightStartStopContainerView.startView.setNeedsDisplay();
        
        // if recording was in progress...
        if(_playView.topContainerView.recordView.recording == true)
        {
            //  reset armed and recording flags
            _playView.topContainerView.recordView.armed = false;
            _playView.topContainerView.recordView.recording = false;
            
            // update the model's MusicSequence
            _playModel.sequence = _mixer.sequence;
            
            // save the music sequence in Mixer
            _mixer.saveSequenceToMidiFile();
        }
        
        //  rest the clock
        // reset the Clock's millitimer to 0
        _clock.milliTimer = 0;
        // rest the Clock's beat and bar counters
        _clock.beatCounter = 1;
        _clock.barCounter = 1;
        // reset the Clock's _firstPress flag to true
        _clock.firstPress = true;
        // reset the clock labels to 1 and 1
        _playView.topContainerView.timePositionContainerView.timePositionLabelContainerView.beatLabelText = "1";
        _playView.topContainerView.timePositionContainerView.timePositionLabelContainerView.barLabelText = "1";
        
        // set the record button back to unarmed colors
        _playView.topContainerView.recordView.bGColor = UIColor.grayColor();
        _playView.topContainerView.recordView.circleColor = UIColor.blackColor();
        
        _playView.topContainerView.recordView.setNeedsDisplay();
    }
    
    // handles the user pressing down on the record button
    //  target for this function was set in the LoadStartViewController
    func recordButtonDown()
    {
        // pressing the record button only has an effect if playback is not in progress
        if(_playView.topContainerView.leftStartStopContainerView.startView.playingFlag == false)
        {
            // if unarmed
            if(_playView.topContainerView.recordView.armed == false)
            {
                _playView.topContainerView.recordView.bGColor = UIColor.whiteColor();
                _playView.topContainerView.recordView.circleColor = UIColor.blackColor();
            }
        
            // if armed
            if(_playView.topContainerView.recordView.armed == true && _playView.topContainerView.recordView.recording == false)
            {
                _playView.topContainerView.recordView.bGColor = UIColor.whiteColor();
                _playView.topContainerView.recordView.circleColor = UIColor.grayColor();
            }
        }
        // else if playback is in progress
        else
        {
            // alert user that they cannot access the record button while playback is in progress
            _playView.topContainerView.recordView.bGColor = UIColor.grayColor();
            _playView.topContainerView.recordView.circleColor = UIColor.lightGrayColor();
        }
        
        _playView.topContainerView.recordView.setNeedsDisplay();
    }

    // handles the user releasing the record button
    //  target for this function was set in the LoadStartViewController
    func recordButtonUp()
    {
        // pressing the record button only has an effect if playback is not in progress
        if(_playView.topContainerView.leftStartStopContainerView.startView.playingFlag == false)
        {
                // if unarmed, set armed flag and move to armed colors
            if(_playView.topContainerView.recordView.armed == false)
            {
                _playView.topContainerView.recordView.armed = true;
                _playView.topContainerView.recordView.bGColor = UIColor.redColor();
                _playView.topContainerView.recordView.circleColor = UIColor.whiteColor();
            }
                // if armed, reset armed flag and move to unarmed colors
            else if(_playView.topContainerView.recordView.armed == true && _playView.topContainerView.recordView.recording == false)
            {
                _playView.topContainerView.recordView.armed = false;
                _playView.topContainerView.recordView.bGColor = UIColor.grayColor();
                _playView.topContainerView.recordView.circleColor = UIColor.blackColor();
            }
        }
        //  else if playback is in progress...
        else
        {
            // and if recording is in progress, move back to recording colors
            if(_playView.topContainerView.recordView.armed == true && _playView.topContainerView.recordView.recording == true)
            {
                _playView.topContainerView.recordView.bGColor = UIColor.greenColor();
                _playView.topContainerView.recordView.circleColor = UIColor.redColor();
            }
            // else if recording is not in prrogress
            else
            {
                // set colors back to unarmed
                _playView.topContainerView.recordView.bGColor = UIColor.grayColor();
                _playView.topContainerView.recordView.circleColor = UIColor.blackColor();
            }
        }
        
        _playView.topContainerView.recordView.setNeedsDisplay();
    }
    
    // this method handles a signal sent by the clock(thread)
    // updates the Playview's beat and bar label displays
    func resetBeatAndBar()
    {
        //  make is so the main thread will up date the beat and bar lables in the PlayView
        //      instead of the clock thread
        dispatch_async(dispatch_get_main_queue(), {
            // update Playview's bar label
            self._playView.topContainerView.timePositionContainerView.timePositionLabelContainerView.barLabelText = self._clock.barCounter.description;
            // update Playview's beat label
            self._playView.topContainerView.timePositionContainerView.timePositionLabelContainerView.beatLabelText = self._clock.beatCounter.description
            }
        )
    }

    // this method handles a signal sent by the clock(thread)
    // updates the Playview's beat and bar label displays
    func resetBeatIncrementBar()
    {
        //  make is so the main thread will up date the beat and bar lables in the PlayView
        //      instead of the clock thread
        dispatch_async(dispatch_get_main_queue(), {
            // update Playview's bar label
            self._playView.topContainerView.timePositionContainerView.timePositionLabelContainerView.barLabelText = self._clock.barCounter.description;
            // update Playview's beat label
            self._playView.topContainerView.timePositionContainerView.timePositionLabelContainerView.beatLabelText = self._clock.beatCounter.description
            }
        )
    }
    
    // this method handles a signal sent by the clock(thread)
    // updates the Playview's beat label display
    func incrementBeat()
    {
        //  make is so the main thread will up date the beat lable in the PlayView
        //      instead of the clock thread
        dispatch_async(dispatch_get_main_queue(), {
            // update Playview's beat label
            self.playView.topContainerView.timePositionContainerView.timePositionLabelContainerView.beatLabelText = self._clock.beatCounter.description;
            }
        )
    }
    
    // the target for this function was set in the LoadStartViewController
    //  this function catches a signal from a touch to the MetronomeVeiw in the PlayView
    //  this function toggles the sound from the metronome
    func toggleMetronomeSound()
    {
        _clock.clickFlag = _clock.clickFlag == false ? true : false;
        // switch label in metronome view
        _playView.topContainerView.timeContainerView.metronomeView.toggleLabelString = _playView.topContainerView.timeContainerView.metronomeView.toggleLabelString == "ON" ? "OFF" : "ON";
        
        _playView.topContainerView.timeContainerView.metronomeView.setNeedsDisplay();
    }
    
    // the target for this function was set in the LoadStartViewController
    //  this function catches the signal sent from the SoundNameLabelView.
    //  enables the user to preview a sound in the SlotConfigView
    func previewConfigSound()
    {
        _mixer.triggerSound(_highlightedSlotIndex);
    }
    
    // the target for this function was set in the LoadStartViewController
    //  this function catches signals sent from the TempoView
    //  This function adjusts the project's tempo by updating the model,
    //      adjusting the tempo label in the TempoView, and adjusting the tempo of the clock
    func adjustTempo()
    {
        // adjust the model's tempo
        _playModel.BPM += _playView.topContainerView.timeContainerView.tempoView.tempoAdustment
        // adjust the tempo of the clock
        _clock.BPM = _playModel.BPM
        // adjust the tempo label in the PlayView
        _playView.topContainerView.timeContainerView.tempoView.tempoLabelText = _playModel.BPM.description;
    }

    // the target for this function was set in the LoadStartViewController
    //  handels triggering sound via the user touching down on a sound tile
    func soundTileTriggered(soundTile: SlotTileView)
    {
        // trigger sound in mixer
        _mixer.triggerSound(soundTile.slotNumber);
        
        // if we are currently recording
        if(_playView.topContainerView.recordView.recording == true)
        {
            // get the current millisecond time of the clock
            let currentTime: Float64 = _clock.milliTimer;
            
            _mixer.addNoteToSequence(soundTile.slotNumber, position: Int64(currentTime), nBars: _playModel.nBars);
        }
    }
    
    // the target for this function was set in the LoadStartViewController
    //  handles highlighting a tile via the user releasing their touch from a tile
    func soundTileHighlighted(soundTile: SlotTileView)
    {
        // set previousely highlighted slot index
        _previouslyHighlightedSlotIndex = _highlightedSlotIndex;
        // set highlighted index
        _highlightedSlotIndex = soundTile.slotNumber;
        
        // if this is the first press...
        if(_previouslyHighlightedSlotIndex != -1)
        {
            // reset previously highlighted slot's background
            _playView.slotTileContainerView.slotTileViewArray[_previouslyHighlightedSlotIndex].backgroundColor = UIColor.blackColor();
        }
        
        // set highlighted tile's background color
        _playView.slotTileContainerView.slotTileViewArray[_highlightedSlotIndex].backgroundColor = UIColor.grayColor();
    }
    
    // pushes the the currently highlighted tile's configuration view once the "C" button is pressed.
    func pushSelectedTilesConfigurationView()
    {
        // if there is a currently selected tile
        if(_highlightedSlotIndex != -1)
        {
            // if the currently selected sound tile's configuration view controller has not been initialized.....
            if(_slotConfigViewControllerArray[_highlightedSlotIndex] == nil)
            {
                //... initialize it
                _slotConfigViewControllerArray[_highlightedSlotIndex] = SlotConfigViewController();
                // set its index number
                _slotConfigViewControllerArray[_highlightedSlotIndex].configNumber = _highlightedSlotIndex;
            }
        
            navigationController?.pushViewController(_slotConfigViewControllerArray[_highlightedSlotIndex], animated: true);
        }
    }
    
    //  Target that catches signal for this method was set in LoadStartViewController
    // handles the user adjusting the start position of the currently selected sound
    func soundStartPositionChanged(button: UIButton)
    {
        var adjustedStartPosition: Int64 = _slotConfigViewControllerArray[_highlightedSlotIndex].slotConfigView.startPositionView.startPosition * 44;  //   yes, that is a magic number....**********
        // update model
        _playModel.soundSlotConfigModelArray[_highlightedSlotIndex].startPosition = adjustedStartPosition;
        
        if(_mixer.audioFileArray[_highlightedSlotIndex] != nil)
        {
            // update the start position for the audio file in the mixer
            _mixer.audioFileArray[_highlightedSlotIndex].framePosition = adjustedStartPosition;
        }
    }
    
    //  Target that catches signal for this method was set in LoadStartViewController
    // adjusts the model and mixer's endpoint for playback.
    func decayPositionChanged()
    {
        var adjustedDecayPosition: Int64 = _slotConfigViewControllerArray[_highlightedSlotIndex].slotConfigView.decayContainerView.decayView.currentDecay;
        // update model
        _playModel.soundSlotConfigModelArray[_highlightedSlotIndex].decayLength = adjustedDecayPosition;
        
        if(_mixer.audioFileArray[_highlightedSlotIndex] != nil)
        {
            _mixer.decayArray[_highlightedSlotIndex] = adjustedDecayPosition;
        }
    }
        
    //  Target that catches signal for this method was set in LoadStartViewController
    //  handles the user changing the pitch of the currently selected sound,
    //      via the transpose control in the slot config view
    func soundsPitchChanged()
    {
        // each semtione is 100 cents
        let adjustedPitch: Int = _slotConfigViewControllerArray[_highlightedSlotIndex].slotConfigView.transposeContainerView.transposeView.currentTone;
        
        //  conversion as per the API
        //let adjustedRate: Float = pow(2, (Float(adjustedPitch * 100) / 1200))
        // update model
        _playModel.soundSlotConfigModelArray[_highlightedSlotIndex].transposeRate = adjustedPitch;

        if(_mixer.variSpeedArray[_highlightedSlotIndex] != nil)
        {
            // update mixer
            _mixer.transposeArray[_highlightedSlotIndex] = Int64(adjustedPitch);
        }
    }
    
    //  Target that catches signal for this method was set in LoadStartViewController
    // transpose random handler
    func adjustTranposeRandom()
    {
        // each semtione is 100 cents
        let adjustedRandom: UInt32 = _slotConfigViewControllerArray[_highlightedSlotIndex].slotConfigView.transposeContainerView.transposeRandomView.currentRandom;
        // update model
        _playModel.soundSlotConfigModelArray[_highlightedSlotIndex].transposeRandom = adjustedRandom;
        
        if(_mixer.variSpeedArray[_highlightedSlotIndex] != nil)
        {
            // update mixer
            _mixer.tRandomArray[_highlightedSlotIndex] = adjustedRandom;
        }
    }
    
    //  Target that catches signal for this method was set in LoadStartViewController
    //  handles the user changing the pitch of the currently selected sound,
    //      via the stretch control in the slot config view
    func stretchPitchChanged()
    {
        // each semtione is 100 cents
        let adjustedPitch: Int = _slotConfigViewControllerArray[_highlightedSlotIndex].slotConfigView.stretchView.currentPitch * 100;
        
        // update model
        _playModel.soundSlotConfigModelArray[_highlightedSlotIndex].stretchPitch = adjustedPitch;
        
        if(_mixer.stretchArray[_highlightedSlotIndex] != nil)
        {
            _mixer.stretchArray[_highlightedSlotIndex].pitch = Float(adjustedPitch);
        }
    }
    
    //  Target set in LoadStartViewController
    //  handles user changing rate of play of currently selected sound, via stretch control in slot config view
    func stretchRateChanged()
    {
        // rate changes have resolution of 0.1
        let adjustedRate: Float = _slotConfigViewControllerArray[_highlightedSlotIndex].slotConfigView.stretchView.currentRate;
        
        // update model
        _playModel.soundSlotConfigModelArray[_highlightedSlotIndex].stretchRate = adjustedRate;
        
        if(_mixer.stretchArray[_highlightedSlotIndex] != nil)
        {
            _mixer.stretchArray[_highlightedSlotIndex].rate = adjustedRate;
        }
    }
    
    //  Target that catches signal for this method was set in LoadStartViewController
    //  handles user changing quality of currently selected sound, via the stretch control in the slot config view
    func stretchOverlapChanged()
    {
        // increments have resolution of 0.5
        let adjustedOverlap: Float = _slotConfigViewControllerArray[_highlightedSlotIndex].slotConfigView.stretchView.currentOverlap;
                
        // update model
        _playModel.soundSlotConfigModelArray[_highlightedSlotIndex].stretchOverlap = adjustedOverlap;
        
        if(_mixer.stretchArray[_highlightedSlotIndex] != nil)
        {
            _mixer.stretchArray[_highlightedSlotIndex].overlap = adjustedOverlap;
        }
    }
    
    //  Target set in LoadStartViewController
    //  handles user changing pan position of currently selected sound, via the pan control in the slot config view
    func adjustPan()
    {
        // +/- 1
        let adjustedPanPosition: Int = _slotConfigViewControllerArray[_highlightedSlotIndex].slotConfigView.panContainerView.panView.currentPanPosition;
        // update model
        _playModel.soundSlotConfigModelArray[_highlightedSlotIndex].panPosition = adjustedPanPosition;
        //  TODO:   not sure why we aren't doing a nil check here
        //  update mixer
        _mixer.panArray[_highlightedSlotIndex] = Int64(adjustedPanPosition);
    }
    
    //  Target set in LoadStartViewController, handles user adjusting pan random param
    func adjustPanRandom()
    {
        // +/- 1
        let adjustedPanRandom: Int = _slotConfigViewControllerArray[_highlightedSlotIndex].slotConfigView.panContainerView.panRandomView.currentPanRandomPosition;
        // update model
        _playModel.soundSlotConfigModelArray[_highlightedSlotIndex].panRandom = adjustedPanRandom;
        //  TODO:   not sure why we aren't doing a nil check here
        // update mixer
        _mixer.pRandomArray[_highlightedSlotIndex] = UInt32(adjustedPanRandom);
    }
    
    //  Target set in LoadStartViewController, handles user changing volume of the currently selected sound,
    //      via the volume in the slot config view
    func adjustVolume()
    {
        // +/- 0.01
        let adjustedVolumePosition: Float = _slotConfigViewControllerArray[_highlightedSlotIndex].slotConfigView.volumeContainerView.volumeView.currentGain;
        // update model
        _playModel.soundSlotConfigModelArray[_highlightedSlotIndex].volume = adjustedVolumePosition;
        // update mixer
        _mixer.playerNodeArray[_highlightedSlotIndex].volume = adjustedVolumePosition;
    }
}
