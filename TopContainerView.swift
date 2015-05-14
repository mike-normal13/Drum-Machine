//
//  TopContainerView.swift
//  FInalProject
//
//  Created by Budge on 5/1/15.
//  Copyright (c) 2015 Budge. All rights reserved.
//

import UIKit

// this class holds both sets of start/stop buttons, the metronome, BPM, record button, 
//  bars, and current time position.
//  instance of this class is owned by the PlayView
class TopContainerView: UIView
{
    private var _leftStartStopContainerView: StartStopContainerView! = nil;
    private var _timeContainerView: TimeContainerView! = nil;
    private var _recordView: RecordView! = nil;
    private var _timePositionContainerView: TimePositionContainerView! = nil;
    private var _rightStartStopContainerView: StartStopContainerView! = nil;
    
    //accessors
    var leftStartStopContainerView: StartStopContainerView
    {
        get{return _leftStartStopContainerView}
        set{ _leftStartStopContainerView = newValue}
    }
    var timeContainerView: TimeContainerView
    {
        get {return _timeContainerView}
        set { _timeContainerView = newValue }
    }
    var recordView: RecordView
    {
        get {return _recordView}
        set {_recordView = newValue}
    }
    var rightStartStopContainerView: StartStopContainerView
    {
        get {return _rightStartStopContainerView}
        set { _rightStartStopContainerView = newValue}
    }
    var timePositionContainerView: TimePositionContainerView!
    {
        get {return _timePositionContainerView}
        set {_timePositionContainerView = newValue}
    }
    
    // divide the sub view vertically 7 equal ways
    override func layoutSubviews()
    {
        var rect = bounds
        // width of each sub division
        var portion = bounds.width / 7;
        
        // initialize
        _leftStartStopContainerView = StartStopContainerView()
        _timeContainerView = TimeContainerView();
        //_recordView = RecordView();
        _recordView = RecordView(frame: bounds);                  
        _timePositionContainerView = TimePositionContainerView()
        _rightStartStopContainerView = StartStopContainerView();
        
        (_leftStartStopContainerView.frame, rect) = rect.rectsByDividing(portion * 2, fromEdge: CGRectEdge.MinXEdge);
        (_timeContainerView.frame, rect) = rect.rectsByDividing(portion, fromEdge: CGRectEdge.MinXEdge);
        (_recordView.frame, rect) = rect.rectsByDividing(portion, fromEdge: CGRectEdge.MinXEdge);
        (_timePositionContainerView.frame, _rightStartStopContainerView.frame) = rect.rectsByDividing(portion, fromEdge: CGRectEdge.MinXEdge)
        
        addSubview(_leftStartStopContainerView);
        addSubview(_timeContainerView);
        addSubview(_recordView);
        addSubview(_timePositionContainerView);
        addSubview(_rightStartStopContainerView);
    }
}
