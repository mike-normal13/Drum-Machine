//
//  SoundSlotConfigModel.swift
//  FInalProject
//
//  Created by Budge on 5/1/15.
//  Copyright (c) 2015 Budge. All rights reserved.
//

import Foundation

// 5 instances of this class will be owned by the PlayModel
//  data for a sound slot
class SoundSlotConfigModel
{
    // the sound loaded into the slot
    private var _loadedSound: NSURL! = nil;
    private var _name: String = "";
    private var _startPosition: Int64 = 0;
    //  the VariSpeed audio unit adjusts pitch in terms of rate, not semitones; default is 1
    private var _transposeRate: Int = 1;
    private var _transposeRandom: UInt32 = 0;
    // default value of 3 seconds
    private var _decayLength: Int64 = 132300; // ms
    private var _panPosition: Int = 0;
    private var _panRandom: Int = 0;
    // 0 - 1
    private var _volume: Float = 0.9;
    private var _volumeRandom: Float = 0;
    // params for the stretch view
    private var _stretchPitch: Int = 0;
    private var _stretchRate: Float = 1;
    private var _stretchOverlap: Float = 8.0;
    private var _muted: Bool = false;
    // catagory of the sound
    private var _soundCatagory: Int = -1;
    //  row of the sound
    private var _soundIndex: Int = -1;
    
    // accessors
    var name: String
    {
        get { return _name}
        set { _name = newValue}
    }
    var startPosition: Int64
    {
        get { return _startPosition}
        set { _startPosition = newValue}
    }
    var transposeRate: Int
    {
        get { return _transposeRate}
        set { _transposeRate = newValue}
    }
    var transposeRandom: UInt32
    {
        get { return _transposeRandom}
        set { _transposeRandom = newValue}
    }
    var decayLength: Int64
    {
        get { return _decayLength}
        set { _decayLength = newValue}
    }
    var panPosition: Int
    {
        get { return _panPosition}
        set { _panPosition = newValue}
    }
    var panRandom: Int
    {
        get { return _panRandom}
        set { _panRandom = newValue}
    }
    var volume: Float
    {
        get { return _volume }
        set { _volume = newValue}
    }
    var volumeRandom: Float
        {
        get { return _volumeRandom }
        set { _volumeRandom = newValue}
    }
    var loadedSound: NSURL
    {
        get { return _loadedSound }
        set { _loadedSound = newValue }
    }
    var stretchPitch: Int
    {
        get { return _stretchPitch }
        set { _stretchPitch = newValue }
    }
    var stretchRate: Float
    {
        get { return _stretchRate }
        set { _stretchRate = newValue }
    }
    var stretchOverlap: Float
    {
        get { return _stretchOverlap }
        set { _stretchOverlap = newValue }
    }
    var muted: Bool
    {
        get { return _muted }
        set { _muted = newValue }
    }
    var soundCatagory: Int
    {
        get { return _soundCatagory }
        set { _soundCatagory = newValue}
    }
    var soundIndex: Int
    {
        get { return _soundIndex }
        set { _soundIndex = newValue }
    }
}
