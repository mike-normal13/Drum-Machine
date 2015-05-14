//
//  StopView.swift
//  FInalProject
//
//  Created by Budge on 5/1/15.
//  Copyright (c) 2015 Budge. All rights reserved.
//

import UIKit

// holds the stop button to halt playback or recording
// instance of this class is owned by the StartStopContainerView
class StopView: UIControl
{
    private var _stopSquareColor: UIColor = UIColor.grayColor();
    //private var _backgroundColor: UIColor = UIColor.blackColor();
    // flag indicates whether the app is currently stopped
    private var _stoppedFlag: Bool = true;
    
    // accessors
    var stopSquareColor: UIColor
    {
        get { return _stopSquareColor }
        set { _stopSquareColor = newValue }
    }
    var backgroundColorAccess: UIColor
    {
        get { return backgroundColor! }
        set { backgroundColor = newValue }
    }
    var stoppedFlag: Bool
    {
        get { return _stoppedFlag }
        set { _stoppedFlag = newValue }
    }
    
    override init(frame: CGRect)  
    {
        super.init(frame: frame);
        self.frame = frame;
        
        layer.borderWidth = 1;
        layer.borderColor = UIColor.whiteColor().CGColor;
        layer.cornerRadius = 5;
        clipsToBounds = true;
    }
    
    required init(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func drawRect(rect: CGRect)
    {
        drawStopSquare();
    }
    
    // draws the stop icon in the view
    private func drawStopSquare()
    {
        var context = UIGraphicsGetCurrentContext();
        
        //  trace the square
        CGContextMoveToPoint(context, bounds.width / 4, bounds.height / 4);
        CGContextAddLineToPoint(context, bounds.width * (3/4), bounds.height / 4);
        CGContextAddLineToPoint(context, bounds.width * (3/4), bounds.height * (3/4));
        CGContextAddLineToPoint(context, bounds.width / 4, bounds.height * (3/4));
        CGContextAddLineToPoint(context, bounds.width / 4, bounds.height / 4);
        
        CGContextSetFillColorWithColor(context, _stopSquareColor.CGColor);
        CGContextFillPath(context);
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent)
    {
        // if we are not currently stopped...
        if(_stoppedFlag == false)
        {
            // switch flag
            _stoppedFlag = true;
            stopSquareColor = UIColor.grayColor();
            backgroundColorAccess = UIColor.blackColor();

            sendActionsForControlEvents(UIControlEvents.TouchUpInside);
            setNeedsDisplay();
        }
    }
}
