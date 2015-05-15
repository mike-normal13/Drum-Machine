//
//  SoundNameLabelView.swift
//  FInalProject
//
//  Created by Budge on 5/1/15.
//  Copyright (c) 2015 Budge. All rights reserved.
//

import UIKit

// shows the name of the sound 
// instance of this class is owned by the SlotConfigView
class SoundNameLabelView: UIControl
{
    private var _soundNameLabel: UILabel! = nil;
    private var _soundName: String = "";
    private var _soundIsLoaded: Bool = false;
    
    //  accessors
    var soundNameLabel: UILabel { return _soundNameLabel }
    var soundName: String
    {
        get { return _soundName }
        set { _soundName = newValue }
    }
    var soundIsLoaded: Bool
    {
        get { return _soundIsLoaded }
        set { _soundIsLoaded = newValue }
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame);
        self.frame = frame;
        
        _soundNameLabel = UILabel(frame: frame);
        _soundNameLabel.textColor = UIColor.whiteColor();
        _soundName = "No Sound Loaded"
        
        _soundNameLabel.textColor = UIColor.whiteColor();
        _soundNameLabel.textAlignment = NSTextAlignment.Center;
        _soundNameLabel.layer.borderWidth = 2;
        _soundNameLabel.layer.borderColor = UIColor.whiteColor().CGColor;
        
        _soundNameLabel.layer.cornerRadius = 5;
    }
    required init(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func drawRect(rect: CGRect)
    {
        _soundNameLabel.frame.size.width = rect.width;
        _soundNameLabel.frame.size.height = rect.height;
        
        _soundNameLabel.frame.origin.x = rect.origin.x;
        _soundNameLabel.frame.origin.y = rect.origin.y;
        
        _soundNameLabel.text = _soundName;
        
        addSubview(_soundNameLabel);
    }
    
    // allow the user to preview the sound
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent)
    {
        if(_soundIsLoaded == true)
        {
            sendActionsForControlEvents(UIControlEvents.TouchDown);
        }
    }
}
