//
//  StartStopContainerView.swift
//  FInalProject
//
//  Created by Budge on 5/1/15.
//  Copyright (c) 2015 Budge. All rights reserved.
//

import UIKit

// holds start and stop buttons
//  two instances of this class belong to the TopContainerView
class StartStopContainerView: UIView
{
    private var _startView: StartView! = nil;
    private var _stopView: StopView! = nil;
    
    // accessors
    var startView: StartView
    {
        get {return _startView}
        set {_startView = newValue}
    }
    var stopView: StopView
    {
        get{return _stopView}
        set {_stopView = newValue}
    }
    
    override func layoutSubviews()
    {
        var rect = bounds;
        
        //intialize
        _startView = StartView(frame: bounds);
        _stopView = StopView(frame: bounds);
        
        (_startView.frame, rect) = rect .rectsByDividing(rect.width * 0.6, fromEdge: CGRectEdge.MinXEdge);
        //make the stop button have shorter height than the play button
        (_stopView.frame, rect) = rect.rectsByDividing(rect.height * 0.6, fromEdge: CGRectEdge.MinYEdge);
        
        addSubview(_startView);
        addSubview(_stopView);
    }
}
