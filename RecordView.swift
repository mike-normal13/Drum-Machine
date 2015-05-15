//
//  RecordView.swift
//  FInalProject
//
//  Created by Budge on 5/1/15.
//  Copyright (c) 2015 Budge. All rights reserved.
//

import UIKit

// the record button, when used in combination with the play button causes midi info to be recorded
//  just to keep things simple,
//      touching this button during playback,
//          regardless of whether recording is happening,
//              has no effect.
//      The user can only toggle arming the recording button while the app is stopped
// instance of this class is owned by the TopContainerView
class RecordView: UIControl
{
    private var _circleColor: UIColor = UIColor.blackColor();
    
    //  this flag will be set/reset only by touching the recording button
    private var _armed: Bool = false;
    
    //  this flag is set if the user presses the play button
    //      while the "_armed" flag is set.
    //  this flag is reset if the user presses the stop button while this flag is true.
    private var _recording: Bool = false;
    
    //  accessors
    var circleColor: UIColor
    {
        get { return _circleColor }
        set { _circleColor = newValue }
    }
    var bGColor: UIColor
    {
        get { return backgroundColor! }
        set { backgroundColor = newValue }
    }
    var recording: Bool
    {
        get { return _recording }
        set { _recording = newValue }
    }
    var armed: Bool
    {
        get { return _armed }
        set { _armed = newValue }
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame);
        self.frame = frame;
        backgroundColor = UIColor.grayColor();
        
        layer.borderWidth = 1;
        layer.borderColor = UIColor.whiteColor().CGColor
        layer.cornerRadius = 5;
        clipsToBounds = true;
    }

    required init(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func drawRect(rect: CGRect)
    {
        drawCircle(rect);
    }
    
    private func drawCircle(rect: CGRect)
    {
        var context = UIGraphicsGetCurrentContext();
        
        var circleBound: CGRect = rect;
        circleBound.size.width = min(rect.width, rect.height) * 0.8;
        circleBound.size.height = circleBound.width;
        circleBound.origin.x = (rect.width - circleBound.width) / 2;
        circleBound.origin.y = (rect.height - circleBound.height) / 2;
        
        CGContextSetFillColorWithColor(context, _circleColor.CGColor);
        CGContextFillEllipseInRect(context, circleBound);
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent)
    {
        sendActionsForControlEvents(UIControlEvents.TouchDown);
    }

    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent)
    {
        sendActionsForControlEvents(UIControlEvents.TouchUpInside);
    }
}
