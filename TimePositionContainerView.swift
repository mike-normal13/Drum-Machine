//
//  TimePositionContainerView.swift
//  FInalProject
//
//  Created by Budge on 5/1/15.
//  Copyright (c) 2015 Budge. All rights reserved.
//

import UIKit

// holds the bars view and the time position view
// instance of this class belongs to the TopContainerView
class TimePositionContainerView: UIView
{
    //private var _measuresView: MeasuresView! = nil;
    private var _measuresView: UILabel! = nil;
    private var _timePositionLabelContainerView: TimePositionLabelContainerView! = nil;
    
    // accessors
    var measuresViewText: String
    {
        get { return _measuresView.text!}
        set { _measuresView.text = newValue }
    }
    var timePositionLabelContainerView: TimePositionLabelContainerView { return _timePositionLabelContainerView }
    var measuresView: UILabel
        {
        get { return _measuresView }
        set { _measuresView = newValue }
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame);
        
        _measuresView = UILabel();
        
        _measuresView.textColor = UIColor.whiteColor();
        _measuresView.textAlignment = NSTextAlignment.Center
        _measuresView.font = UIFont(name: _measuresView.font.fontName, size: 30);
        
        _measuresView.backgroundColor = UIColor.darkGrayColor();
        
        _measuresView.layer.borderWidth = 1;
        _measuresView.layer.borderColor = UIColor.whiteColor().CGColor;
        _measuresView.layer.cornerRadius = 5;
        _measuresView.clipsToBounds = true;
    }
    required init(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func layoutSubviews()
    {
        var rect = bounds;
        
        _timePositionLabelContainerView = TimePositionLabelContainerView();
        
        (_measuresView.frame, _timePositionLabelContainerView.frame) = rect.rectsByDividing(rect.height/2, fromEdge: CGRectEdge.MinYEdge);
        
        addSubview(_measuresView);
        addSubview(_timePositionLabelContainerView);
    }
}
