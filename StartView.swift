//
//  StartView.swift
//  FInalProject
//
//  Created by Budge on 5/1/15.
//  Copyright (c) 2015 Budge. All rights reserved.
//

import UIKit

// holds the play button to begin playback or recording
//  Instance of this class is owned by the StartStopContainerView
class StartView: UIControl
{
    private var _triangleColor: UIColor = UIColor.grayColor();
    private var _backgroundColor: UIColor = UIColor.blackColor();
    // flag the indicates whether the app is playing back currently
    private var _playingFlag: Bool = false;
    
    // accessors
    var triangleColor: UIColor
    {
        get { return _triangleColor }
        set { _triangleColor = newValue }
    }
    var backgroundColorAccess: UIColor
    {
        get { return backgroundColor! }
        set { backgroundColor = newValue }
    }
    var playingFlag: Bool
    {
        get { return _playingFlag }
        set { _playingFlag = newValue }
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
        drawPlayTriangle();
    }
    
    // draws the play icon in the view
    private func drawPlayTriangle()
    {
        var context = UIGraphicsGetCurrentContext();
        
        //  trace the triangle
        CGContextMoveToPoint(context, bounds.width / 4, bounds.height / 4);
        CGContextAddLineToPoint(context, bounds.width * (3/4), bounds.height / 2);
        CGContextAddLineToPoint(context, bounds.width / 4, bounds.height * (3/4));
        CGContextAddLineToPoint(context, bounds.width / 4, bounds.height / 4);
        
        CGContextSetFillColorWithColor(context, _triangleColor.CGColor);
        CGContextFillPath(context);
    }
    
    // give the user a visual queue that the clock will start once they lift their finger
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent)
    {
        if(_playingFlag == false)
        {
            backgroundColorAccess = UIColor.whiteColor();
            setNeedsDisplay();
        }
    }
    
    //      send the signal to start the clock, and change the triangle to green
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent)
    {
        if(_playingFlag == false)
        {
            _playingFlag = true;
            // green indicates playback in progress
            triangleColor = UIColor.greenColor();
            // gray indicates the user cannot access this control while playback is in progress
            backgroundColorAccess = UIColor.grayColor();
            sendActionsForControlEvents(UIControlEvents.TouchUpInside);
            setNeedsDisplay();
        }
    }
}
    
