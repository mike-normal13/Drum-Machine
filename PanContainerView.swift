//
//  PanContainerView.swift
//  FInalProject
//
//  Created by Budge on 5/1/15.
//  Copyright (c) 2015 Budge. All rights reserved.
//

import UIKit

// holds the controls that determine the panning behavior of a sound
//  instance of this class is owned by the SlotConfigView
class PanContainerView: UIView
{
    private var _panView: PanView! = nil;
    private var _panRandomView: PanRandomView! = nil;
    
    // accessors
    var panView: PanView
    {
        get { return _panView }
        set { _panView = newValue }
    }
    var panRandomView: PanRandomView
    {
        get { return _panRandomView }
        set { _panRandomView = newValue }
    }
    
    override func layoutSubviews()
    {
        var rect = bounds;
        
        layer.borderWidth = 1;
        layer.borderColor = UIColor.whiteColor().CGColor;
        layer.cornerRadius = 5;
        clipsToBounds = true;
        
        _panView = PanView(frame: bounds)
        _panRandomView = PanRandomView(frame: bounds);
        
        (_panView.frame, _panRandomView.frame) = rect.rectsByDividing(rect.height / 2, fromEdge: CGRectEdge.MinYEdge);
        
        addSubview(_panView);
        addSubview(_panRandomView);
    }
}

