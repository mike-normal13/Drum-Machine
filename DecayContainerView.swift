//
//  DecayContainerView.swift
//  FInalProject
//
//  Created by Budge on 5/1/15.
//  Copyright (c) 2015 Budge. All rights reserved.
//

import UIKit

// holds the controls that decide how a sound terminates
// instance of this class is owned by the SlotConfigView
class DecayContainerView: UIView
{
    private var _decayView: DecayView! = nil;
    
    //  accessors
    var decayView: DecayView
    {
        get { return _decayView }
        set {_decayView = newValue }
    }
    
    override func layoutSubviews()
    {
        var rect = bounds;
        
        layer.borderWidth = 1;
        layer.borderColor = UIColor.whiteColor().CGColor;
        layer.cornerRadius = 5;
        clipsToBounds = true;
        
        _decayView = DecayView(frame: bounds)
        addSubview(_decayView);
    }
}
