//
//  MetronomeView.swift
//  FInalProject
//
//  Created by Budge on 5/1/15.
//  Copyright (c) 2015 Budge. All rights reserved.
//

import UIKit

// lets the user choose whether to hear the metronome
// instance of this class is owned by the TimeContainerView
class MetronomeView: UIControl
{
    private var _toggleLabel: UILabel! = nil
    private var _toggleLabelString = "ON";
    
    // accessors
    var toggleLabel: UILabel!
    {
        get { return _toggleLabel }
        set { _toggleLabel = newValue }
    }
    var toggleLabelString: String
    {
        get { return _toggleLabelString }
        set { _toggleLabelString = newValue}
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame);
        self.frame = frame;
        
        layer.borderWidth = 1;
        layer.borderColor = UIColor.whiteColor().CGColor
        layer.cornerRadius = 5;
        clipsToBounds = true;
        
        backgroundColor = UIColor.darkGrayColor();
        
        _toggleLabel = UILabel(frame: self.frame);
        _toggleLabel.textColor = UIColor.whiteColor();
        _toggleLabel.font = UIFont(name: _toggleLabel.font.fontName, size: 25);
        _toggleLabel.textAlignment = NSTextAlignment.Center;
    }
    required init(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func drawRect(rect: CGRect)
    {
        _toggleLabel.frame.size.width = rect.width;
        _toggleLabel.frame.size.height = rect.height;
        
        _toggleLabel.frame.origin.x = rect.origin.x;
        _toggleLabel.frame.origin.y = rect.origin.y;
        
        _toggleLabel.text = _toggleLabelString;
    }
    
    // signal will be caught be by the PlayViewController
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent)
    {
        sendActionsForControlEvents(UIControlEvents.TouchDown);
    }
}
