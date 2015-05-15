//
//  Clock.swift
//  FInalProject
//
//  Created by Budge on 5/1/15.
//  Copyright (c) 2015 Budge. All rights reserved.
//

import UIKit
import AVFoundation

//  this class is responsible for handling the beat bar clock, playing the metronome sound in the audio output,
//      sending signals that result in the proper updating of the TimePositionView,
//          and keeping track a millisecond resolution clock that will help to write midi notes to a midi file
//  The only function in this class is run by a sperate thread than the main thread.
// instance of this class is owned by the PlayViewController
class Clock: UIControl
{
    // the app starts with a default value of 120 beats per minute
    private var _BPM: Int = 120;
    
    // the number of bars the user chose
    private var _bars: Int = 0;
    
    private var _beatCounter = 1;
    private var _barCounter = 1;
    
    // metronome sounds
    private var _downBeatClickSound: NSURL! = nil;
    private var _clickSound: NSURL! = nil;
    
    // metronome AVPlayers
    private var _downBeatPlayer: AVAudioPlayer! = nil;
    private var _clickPlayer: AVAudioPlayer! = nil;
    
    //  flag indicating pressing the play button while clock is in intial state
    private var _firstPress: Bool = true;
    
    // timer for playback
    private var _milliTimer: Float64 = 0
    //  TODO: doing it this way will probably get us out of sync with the Clock.......
    // max value of timer
    private var _timerMax: Float64 = -1;
    
    // this flag will be set to true whenever the player presses the stop button
    //      causing the thread to stop counting
    private var _killFlag: Bool = false;

    // flag that is set by clicking the metronome button in the play view
    //      determines whether the metronome is silent or not
    private var _clickFlag: Bool = true;

    // accessors
    var BPM: Int
    {
        get { return _BPM }
        set { _BPM = newValue }
    }
    // computes the number of beats per seconds given the current BPM
    var quarterNoteTimeInterval: Float { return Float(Float(60) / Float(_BPM)) }
    var bars: Int
    {
        get { return _bars }
        set { _bars = newValue }
    }
    var killFlag: Bool
    {
        get { return _killFlag }
        set { _killFlag = newValue }
    }
    var clickFlag: Bool
    {
        get { return _clickFlag }
        set { _clickFlag = newValue }
    }
    var beatCounter: Int
    {
        get { return _beatCounter }
        set { _beatCounter = newValue }
    }
    var barCounter: Int
    {
        get { return _barCounter }
        set { _barCounter = newValue }
    }
    var milliTimer: Float64
    {
        get { return _milliTimer }
        set { _milliTimer = newValue }
    }
    var firstPress: Bool
    {
        get { return _firstPress }
        set { _firstPress = newValue }
    }
        
    override init(frame: CGRect)
    {
        super.init(frame: frame);
        _downBeatClickSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("DownBeat", ofType: "wav")!);
        _clickSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Click", ofType: "wav")!);
        _downBeatPlayer = AVAudioPlayer(contentsOfURL: _downBeatClickSound, error: nil);
        _clickPlayer = AVAudioPlayer(contentsOfURL: _clickSound, error: nil);
    }
    required init(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // this function will be run by a separate thread
    func ticTok()
    {
        // set timer max
        _timerMax = Float64((1000) * (60) * (_bars * 4)) / Float64(_BPM);
        
        //  clock until the user presses the stop button
        while(_killFlag == false)
        {
            //  if we pressed the play button for the first time
            if(_barCounter == 1 && _beatCounter == 1 && _firstPress == true)
            {
                _downBeatPlayer.prepareToPlay();
                
                // play the downbeat sound if the metronome button is set
                if(_clickFlag == true)
                {
                    _downBeatPlayer.play();
                }
            }
            // if we need to reset both the measure counter and the beat counter to 0
            else if(_barCounter == _bars && _beatCounter == 4)
            {
                _downBeatPlayer.prepareToPlay();
                
                // reset both
                _barCounter = 1;
                _beatCounter = 1;
                
                sendActionsForControlEvents(UIControlEvents.TouchUpInside); // downbeat
                
                // play the downbeat sound if the metronome button is set
                if(_clickFlag == true)
                {
                    _downBeatPlayer.play();
                }
            }
            // else if we need to increment the measure counter and reset the beat counter
            else if(_barCounter < _bars && _beatCounter == 4)
            {
                _downBeatPlayer.prepareToPlay();
                
                // increment measure counter, reset beat counter
                ++_barCounter;
                _beatCounter = 1
                
                sendActionsForControlEvents(UIControlEvents.TouchUpOutside); // downbeat
                
                // play the downbeat sound if the metronome button is set
                if(_clickFlag == true)
                {
                    _downBeatPlayer.play();
                }
            }
            // else if we just need to increment the beat counter
            else if(_barCounter <= bars && _beatCounter <= 4 && _firstPress == false)
            {
                _clickPlayer.prepareToPlay();
                
                // increment beat
                ++_beatCounter;
                
                sendActionsForControlEvents(UIControlEvents.ValueChanged)
                
                // play the non-downbeat sound if the metronome button is set
                if(_clickFlag == true)
                {
                    _clickPlayer.play();
                }
            }
            do
            {
                NSThread.sleepForTimeInterval(0.001);
                if(_milliTimer < _timerMax )
                {
                    _milliTimer++;
                }
                else
                {
                    _milliTimer = 1;
                }
            } while (_milliTimer % Float64(quarterNoteTimeInterval * 1000) != 0 && _killFlag == false)
            println("left do-while; _millitimer: \(_milliTimer)");
            
            //  if thead exits the loop becuase the stop button was pressed,
            //      reset first press flag to true
            //          else set the firstPress flag to false
            _firstPress = _killFlag == true ? true : false;
        }
        
        return;
    }
}
