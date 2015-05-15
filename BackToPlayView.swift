//
//  BackToPlayView.swift
//  FInalProject
//
//  Created by Budge on 5/1/15.
//  Copyright (c) 2015 Budge. All rights reserved.
//

import UIKit

// lets the user switch back to play view
// instance of this class is owned by the SlotConfigView
class BackToPlayView: UIControl
{
    //  "Go Back"
    private var _goBackLabel: UILabel! = nil
    
    // accessors
    var goBackLabel: UILabel { return _goBackLabel }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame);
        self.frame = frame;

        _goBackLabel = UILabel(frame: frame);
        _goBackLabel.textColor = UIColor.whiteColor();
        _goBackLabel.text = "Back";
        _goBackLabel.textAlignment = NSTextAlignment.Center;
        
        layer.borderWidth = 2;
        layer.borderColor = UIColor.whiteColor().CGColor;
        layer.cornerRadius = 5;
    }
    required init(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func drawRect(rect: CGRect)
    {
        _goBackLabel.frame.size.width = frame.width;
        _goBackLabel.frame.size.height = frame.height;
        
        _goBackLabel.frame.origin.x = frame.origin.x;
        _goBackLabel.frame.origin.y = frame.origin.y;
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent)
    {
        var o = 0;
        // send the signal ...
        sendActionsForControlEvents(UIControlEvents.TouchUpInside);
    }
}
