//
//  PreviewView.swift
//  FInalProject
//
//  Created by Budge on 5/1/15.
//  Copyright (c) 2015 Budge. All rights reserved.
//

import UIKit

// lets the user preview the current configuration of the sound
// instance of this class is owned by the SlotConfigView
class PreviewView: UIControl
{
    // flag indicating whether the SlotConfigView has a sound loaded in it.
    //      buttons will have no effect if false.
    private var _soundIsLoaded: Bool = false;
    
    //accessors
    var soundIsLoaded: Bool
        {
        get { return _soundIsLoaded }
        set { _soundIsLoaded = newValue }
    }
}
