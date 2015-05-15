//
//  Mixer.swift
//  FInalProject
//
//  Created by Budge on 5/1/15.
//  Copyright (c) 2015 Budge. All rights reserved.
//

import Foundation
import AVFoundation

//  This class is responsible for playing sounds,
//  an instance of this class is owned by the PlayViewController
class Mixer
{
    // Setup engine and node instances
    private var _engine: AVAudioEngine
    private var _mixer: AVAudioMixerNode
    private var _format: AVAudioFormat! = nil //= input.inputFormatForBus(0)
    private var error: NSError?
    
    // audio unit arrays
    private var _playerNodeArray: [AVAudioPlayerNode!] = [];
    private var _variSpeedArray: [AVAudioUnitVarispeed!] = [];
    private var _stretchArray: [AVAudioUnitTimePitch!] = []
    
    // URL sounds for each of the 5 slots
    private var _sounds: [NSURL!] = [nil, nil, nil, nil, nil];
    // audio files for each of the 5 slots
    private var _audioFileArray: [AVAudioFile!] = [nil, nil, nil, nil, nil];
    // holds the number of frames for each of the files
    private var _numberOfFramesArray: [Int64] = [0, 0, 0, 0, 0];
    
    private var _decayArray: [Int64] = [132300, 132300, 132300, 132300, 132300]; // 3 seconds by default
    private var _transposeArray: [Int64] = [0, 0, 0, 0, 0];
    private var _tRandomArray: [UInt32] = [0, 0, 0, 0, 0];
    private var _panArray: [Int64] = [0, 0, 0, 0, 0];
    private var _pRandomArray: [UInt32] = [0, 0, 0, 0, 0];
    
    //  ******************************************************************************
    //  TODO: for now all this stuff will go in this class...
    
    //  responsible for containing the recording the user's sound triggering
    private var _sequence: MusicSequence! = nil;
    
    //  TODO:   hmmmmmmm..........
    private var _tempoTrack: MusicTrack! = nil
    
    //  TODO:   hopefully each of the 5 sound slots will wrtie midi info to these guys
    private var _track0: MusicTrack! = nil;
    private var _track1: MusicTrack! = nil;
    private var _track2: MusicTrack! = nil;
    private var _track3: MusicTrack! = nil;
    private var _track4: MusicTrack! = nil;
    
    //  TODO:   this is just an attempt to see if we can get our derived midi notes into an acceptable range...
    private var _midiNoteValueOffset: Int = 60;
    
    // directory we will save midi files to
    private var _masterDocumentDirectory: String = "";
    private var _saveUrl: NSURL! = nil;
    
    private var _projectName: String = "";
    
    //  ******************************************************************************
    
    //  accesssors
    var numberOfFramesArray: [Int64] { return _numberOfFramesArray }
    var audioFileArray: [AVAudioFile!]
    {
        get { return _audioFileArray }
        set { _audioFileArray = newValue }
    }
    var variSpeedArray: [AVAudioUnitVarispeed!]
    {
        get { return _variSpeedArray }
        set { _variSpeedArray = newValue}
    }
    var stretchArray: [AVAudioUnitTimePitch!] { return _stretchArray }
    var decayArray: [Int64]
    {
        get { return _decayArray }
        set { _decayArray = newValue}
    }
    var playerNodeArray: [AVAudioPlayerNode!] { return _playerNodeArray }
    var tRandomArray: [UInt32]
    {
        get { return _tRandomArray}
        set { _tRandomArray = newValue }
    }
    var transposeArray: [Int64]
    {
        get { return _transposeArray }
        set { _transposeArray = newValue }
    }
    var panArray: [Int64]
    {
        get { return _panArray }
        set { _panArray = newValue }
    }
    var pRandomArray: [UInt32]
    {
        get { return _pRandomArray}
        set { _pRandomArray = newValue }
    }
    var mixer: AVAudioMixerNode { return _mixer }
    
    //  ******************************************************************************
    //  TODO:   recording stuff, for now will be in this class
    var sequence: MusicSequence { return _sequence }

    //  TODO:   might not need this...
    var tempoTrack: MusicTrack { return _tempoTrack }
    
    //  TODO:   might not need these...
    var track0: MusicTrack { return _track0 }
    var track1: MusicTrack { return _track1 }
    var track2: MusicTrack { return _track2 }
    var track3: MusicTrack { return _track3 }
    var track4: MusicTrack { return _track4 }
    
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
    //  ******************************************************************************
    
    
    init()
    {
        _engine = AVAudioEngine()
        
        var input = _engine.inputNode;
        
        _format = input.inputFormatForBus(0);
        _mixer = _engine.mainMixerNode;
        
        // init nodes in arrays, attach all nodes to mixer, 
        //      and configure signal path for each of the 5 slots
        for(var pos: Int = 0; pos < 5; pos++)
        {
            _playerNodeArray.append(AVAudioPlayerNode());
            _playerNodeArray[pos].volume = 0.9;
            _variSpeedArray.append(AVAudioUnitVarispeed());
            _stretchArray.append(AVAudioUnitTimePitch());
            
            _engine.attachNode(_playerNodeArray[pos]);
            _engine.attachNode(_variSpeedArray[pos]);
            _engine.attachNode(_stretchArray[pos]);
            
            _engine.connect(_variSpeedArray[pos], to: _mixer, format: _format);
            _engine.connect(_stretchArray[pos], to: _variSpeedArray[pos], format: _format);
            _engine.connect(_playerNodeArray[pos], to: _stretchArray[pos], format: _format);
        }
        
        // Start engine
        _engine.startAndReturnError(&error)

        //  ******************************************************************************
        //  TODO:   recording stuff, for now will go in this class......
        
        _sequence = MusicSequence();
        
        _tempoTrack = MusicTrack();
        
        MusicSequenceGetTempoTrack(_sequence, &_tempoTrack!);
        
        _track0 = MusicTrack();
        _track1 = MusicTrack();
        _track2 = MusicTrack();
        _track3 = MusicTrack();
        _track4 = MusicTrack();
        
        NewMusicSequence(&_sequence!);
        
        MusicSequenceNewTrack(_sequence, &_track0!);
        MusicSequenceNewTrack(_sequence, &_track1!);
        MusicSequenceNewTrack(_sequence, &_track2!);
        MusicSequenceNewTrack(_sequence, &_track3!);
        MusicSequenceNewTrack(_sequence, &_track4!);
        
        //  ******************************************************************************
    }

    // sound array accessor for the outside
    func setSound(index: Int, sound: NSURL)
    {
        // put the sound chosen by the user into the sound array
        _sounds[index] = sound;
        // init chosen file
        _audioFileArray[index] = AVAudioFile(forReading: _sounds[index], error: &error);
        // set number of frames of the chosen file
        _numberOfFramesArray[index] = Int64(_audioFileArray[index].length.value);
    }
    
    //  this fuctions is called by the soundTileTriggered() method in the PlayViewController
    //      this function is called when ever a user presses one of the sound tiles in the play view.
    func triggerSound(index: Int)
    {
        if(_sounds[index] != nil)
        {
            //  stop playing the sound if it is currently playing
            if(_playerNodeArray[index].playing == true)
            {
                _playerNodeArray[index].stop();
            }
            
            // schedule the sound based upon the start and end(decay) points
            _playerNodeArray[index].scheduleSegment(_audioFileArray[index], startingFrame: _audioFileArray[index].framePosition, frameCount: min(AVAudioFrameCount(UInt32(_decayArray[index])), AVAudioFrameCount(AVAudioFrameCount(_numberOfFramesArray[index]) - AVAudioFrameCount(_audioFileArray[index].framePosition))), atTime: nil, completionHandler: nil);
            
            _playerNodeArray[index].play();
            // update random values after every hit.
            updateRandomValues(index);
        }
    }
    
    private func updateRandomValues(index : Int)
    {
        // tranpose
        _variSpeedArray[index].rate = pow(2, ( ((Float(_transposeArray[index]) + (-Float(_tRandomArray[index]) + Float(arc4random_uniform(2 * _tRandomArray[index]))) / 2) * 100) / 1200))
        //  pan
        _playerNodeArray[index].pan = (Float(_panArray[index]) + (-Float(_pRandomArray[index]) + Float(arc4random_uniform(2 * _pRandomArray[index])))) / 100;
    }
    
    func addNoteToSequence(track: Int, position: Int64, nBars: Int)
    {
        // number of frames
        let fileLength: Int64 = numberOfFramesArray[track];
        // length in seconds of file
        let fileDuration: Float = Float(fileLength / 44100);
        //  determine midi duration value
        var midiDuration: Float = determineFileDuration(fileDuration);
        
        // status
        var status: OSStatus;
        
        var midiNoteMessage: MIDINoteMessage = MIDINoteMessage(channel: UInt8(0), note: UInt8(track + _midiNoteValueOffset), velocity: UInt8(127), releaseVelocity: UInt8(0), duration: Float32(midiDuration));
        
        if(track == 0)
        {
            status =  MusicTrackNewMIDINoteEvent(_track0, MusicTimeStamp(8 * (Float(position) / Float(176400))), &midiNoteMessage);
        }
        else if(track == 1)
        {
            status =  MusicTrackNewMIDINoteEvent(_track1, MusicTimeStamp(Float( (Float(position) % (Float(nBars * 4))) )), &midiNoteMessage);   assert(status == 0);
        }
        else if(track == 2)
        {
            status =  MusicTrackNewMIDINoteEvent(_track2, MusicTimeStamp(Float( (Float(position) % (Float(nBars * 4))) )), &midiNoteMessage);   assert(status == 0);
        }
        else if(track == 3)
        {
            status =  MusicTrackNewMIDINoteEvent(_track3, MusicTimeStamp(Float( (Float(position) % (Float(nBars * 4))) )), &midiNoteMessage);assert(status == 0);
        }
        else
        {
            assert(track == 4);
            status =  MusicTrackNewMIDINoteEvent(_track4, MusicTimeStamp(Float( (Float(position) % (Float(nBars * 4))) )), &midiNoteMessage); assert(status == 0);
        }
    }
    
    func playBack()
    {
        
    }
    
    private func determineFileDuration(length: Float) -> Float
    {
        if(length <= 0.25)      { return 0.25;  }
        else if(length <= 0.5)  { return 0.5;   }
        else if(length <= 0.75) { return 0.75   }
        else if(length <= 1)    { return 1;     }
        else if(length <= 1.25) { return 1.25;  }
        else if(length <= 1.5)  { return 1.5;   }
        else if(length <= 1.75) { return 1.75;  }
        else if(length <= 2)    { return 2;     }
        else if(length <= 2.25) { return 2.25;  }
        else if(length <= 2.5)  { return 2.5;   }
        else if(length <= 2.75) { return 2.75   }
        else if(length <= 3.0)  { return 3.0;   }
        else if(length <= 3.25) { return 3.25;  }
        else if(length <= 3.5)  { return 3.5;   }
        else if(length <= 3.75) { return 3.75   }
        else                    { return 4;     }
    }
    
    func saveSequenceToMidiFile()
    {
        _saveUrl = NSURL(fileURLWithPath: _masterDocumentDirectory + "/\(_projectName).mid"); // SUSPECT!!!
        
        var status: OSStatus;
        
        status = MusicSequenceFileCreate(_sequence, _saveUrl, MusicSequenceFileTypeID(kMusicSequenceFile_MIDIType), MusicSequenceFileFlags(kMusicSequenceFileFlags_EraseFile), 0);
        
        var x = 10;
    }
    
    func setTrackLengths(bars: Int)
    {
        var x = bars;
        
        var loopStatus: OSStatus;
        var lengthStatus: OSStatus;
        
        var loopInfoForTracks: MusicTrackLoopInfo = MusicTrackLoopInfo(loopDuration: MusicTimeStamp(bars * 4), numberOfLoops: 0);
        
        // set loop info properties
        loopStatus = MusicTrackSetProperty(_track0, UInt32(kSequenceTrackProperty_LoopInfo), &loopInfoForTracks, UInt32(sizeof(MusicTrackLoopInfo)));       assert(loopStatus == 0);
        loopStatus = MusicTrackSetProperty(_track1, UInt32(kSequenceTrackProperty_LoopInfo), &loopInfoForTracks, UInt32(sizeof(MusicTrackLoopInfo)));       assert(loopStatus == 0);
        loopStatus = MusicTrackSetProperty(_track2, UInt32(kSequenceTrackProperty_LoopInfo), &loopInfoForTracks, UInt32(sizeof(MusicTrackLoopInfo)));       assert(loopStatus == 0);
        loopStatus = MusicTrackSetProperty(_track3, UInt32(kSequenceTrackProperty_LoopInfo), &loopInfoForTracks, UInt32(sizeof(MusicTrackLoopInfo)));       assert(loopStatus == 0);
        loopStatus = MusicTrackSetProperty(_track4, UInt32(kSequenceTrackProperty_LoopInfo), &loopInfoForTracks, UInt32(sizeof(MusicTrackLoopInfo)));       assert(loopStatus == 0);
        
        var trackLength: MusicTimeStamp = MusicTimeStamp(bars * 4);
        
        // set length properties
        lengthStatus = MusicTrackSetProperty(_track0, UInt32(kSequenceTrackProperty_TrackLength), &trackLength, UInt32(sizeof(MusicTimeStamp)));            assert(lengthStatus == 0);
        lengthStatus = MusicTrackSetProperty(_track1, UInt32(kSequenceTrackProperty_TrackLength), &trackLength, UInt32(sizeof(MusicTimeStamp)));            assert(lengthStatus == 0);
        lengthStatus = MusicTrackSetProperty(_track2, UInt32(kSequenceTrackProperty_TrackLength), &trackLength, UInt32(sizeof(MusicTimeStamp)));            assert(lengthStatus == 0);
        lengthStatus = MusicTrackSetProperty(_track3, UInt32(kSequenceTrackProperty_TrackLength), &trackLength, UInt32(sizeof(MusicTimeStamp)));            assert(lengthStatus == 0);
        lengthStatus = MusicTrackSetProperty(_track4, UInt32(kSequenceTrackProperty_TrackLength), &trackLength, UInt32(sizeof(MusicTimeStamp)));            assert(lengthStatus == 0);
    }
    //  ******************************************************************************
}
