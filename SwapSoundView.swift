//
//  SwapSoundView.swift
//  FInalProject
//
//  Created by Budge on 5/1/15.
//  Copyright (c) 2015 Budge. All rights reserved.
//

import UIKit

// lets the user choose to swap out the current sound with another sound
//  instance of this class is owned by the SlotConfigView
class SwapSoundView: UIControl
{
    private var _swapLabel: UILabel! = nil
    
    var swapLabel: UILabel { return _swapLabel }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame);
        self.frame = frame;
        
        _swapLabel = UILabel(frame: frame);
        _swapLabel.textColor = UIColor.whiteColor();
        _swapLabel.text = "Swap";
        _swapLabel.textAlignment = NSTextAlignment.Center;
        
        layer.borderWidth = 2;
        layer.borderColor = UIColor.whiteColor().CGColor;
        layer.cornerRadius = 5;
    }
    required init(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func drawRect(rect: CGRect)
    {
        _swapLabel.frame.size.width = rect.width;
        _swapLabel.frame.size.height = rect.height
        
        _swapLabel.frame.origin.x = rect.origin.x
        _swapLabel.frame.origin.y = rect.origin.y;
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent)
    {
        // send signal to LoadStartViewController
        sendActionsForControlEvents(UIControlEvents.TouchUpInside);
    }
}
