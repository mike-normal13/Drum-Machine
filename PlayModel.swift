//
//  PlayModel.swift
//  FInalProject
//
//  Created by Budge on 5/1/15.
//  Copyright (c) 2015 Budge. All rights reserved.
//

import Foundation
import AVFoundation

// instance of this class is owned by the PlayViewController
// data for playing
class PlayModel
{
    private var _projectName: String;
    private var _nBars: Int;
    private var _limiterArmed: Bool;
    private var _muteArray: [Bool];
    private var _soloArray: [Bool];
    private var _BPM: Int;
    private var _masterVolume: Float = 1;
    
    //array of soundSlotConfigModel
    private var _soundSlotConfigModelArray: [SoundSlotConfigModel!] = [nil, nil, nil, nil, nil];
    
    // the midi file
    private var _sequence: MusicSequence! = nil;
    
    //  accessors
    var projectName: String
    {
        get { return _projectName }
        set { _projectName = newValue }
    }
    var nBars: Int
    {
        get { return _nBars }
        set
        {
            if(newValue == 1 || newValue == 2 || newValue == 4 || newValue == 8)
            {
                _nBars = newValue
            }
        }
    }
    var BPM: Int
    {
        get { return _BPM }
        set
        {
            if(newValue >= 20 && newValue <= 300)
            {
                _BPM = newValue;
            }
        }
    }
    var limiterArmed: Bool
    {
        get { return _limiterArmed }
        set { _limiterArmed = newValue }
    }
    var muteArray: [Bool] { return _muteArray }
    var soloArray: [Bool] { return _soloArray }
    var soundSlotConfigModelArray: [SoundSlotConfigModel!]
    {
        get { return _soundSlotConfigModelArray }
        set {_soundSlotConfigModelArray = newValue }
    }
    var sequence: MusicSequence
    {
        get { return _sequence }
        set { _sequence = newValue }
    }
    var masterVolume: Float
    {
        get { return _masterVolume }
        set { _masterVolume = newValue }
    }
    
    init()
    {
        _projectName = "";
        _nBars = 0;
        _masterVolume = 0.0;
        _limiterArmed = false;
        _muteArray = [Bool](count: 5, repeatedValue: false);
        _soloArray = [Bool](count: 5, repeatedValue: false);
        // new projects will have this be the default  BPM value
        _BPM = 120;
    }
    
    func setSoundSlotConfigModelArrayPosition(index: Int, model: SoundSlotConfigModel!)
    {
        _soundSlotConfigModelArray[index] = model;
    }
}
