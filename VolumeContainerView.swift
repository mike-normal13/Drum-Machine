//
//  VolumeContainerView.swift
//  FInalProject
//
//  Created by Budge on 5/1/15.
//  Copyright (c) 2015 Budge. All rights reserved.
//

import UIKit

// holds the controls that determine the volume of the sound
// instance of this class is owned by the SlotConfigView
class VolumeContainerView: UIView
{
    private var _volumeView: VolumeView! = nil;
    
    // accessors
    var volumeView: VolumeView
        {
        get { return _volumeView }
        set { _volumeView = newValue }
    }
    
    override func layoutSubviews()
    {
        var rect = bounds;
        
        layer.borderWidth = 1;
        layer.borderColor = UIColor.whiteColor().CGColor;
        layer.cornerRadius = 5;
        clipsToBounds = true;
        
        _volumeView = VolumeView(frame: bounds)
                
        addSubview(_volumeView);
    }
}
