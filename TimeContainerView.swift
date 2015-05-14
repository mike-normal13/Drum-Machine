//
//  TimeContainerView.swift
//  FInalProject
//
//  Created by Budge on 5/1/15.
//  Copyright (c) 2015 Budge. All rights reserved.
//

import UIKit

// holds the metronome button and current time position label
// instance of this class is owned by the TopContainerView
class TimeContainerView: UIView
{
    private var _metronomeView: MetronomeView! = nil;
    private var _tempoView: TempoView! = nil;
    
    //accessors
    var metronomeView: MetronomeView
    {
        get {return _metronomeView}
        set { _metronomeView = newValue}
    }
    var tempoView: TempoView
    {
        get {return _tempoView}
        set { _tempoView = newValue}
    }
        
    override func layoutSubviews()
    {
        var rect = bounds;
        
        _metronomeView = MetronomeView(frame: bounds);
        _tempoView = TempoView(frame: bounds);
        
        // place
        (_metronomeView.frame, _tempoView.frame) = rect.rectsByDividing(frame.height/2, fromEdge: CGRectEdge.MinYEdge);
        
        addSubview(_metronomeView);
        _metronomeView.addSubview(_metronomeView.toggleLabel);
        addSubview(_tempoView);
        _tempoView.addSubview(_tempoView.tempoLabel);
    }
}
