//
//  TimePositionLabelContainerView.swift
//  FInalProject
//
//  Created by Budge on 5/1/15.
//  Copyright (c) 2015 Budge. All rights reserved.
//

import UIKit

// this class holds the labels coresponding to the bar : beat clock
//  instance of this class is owned by the TimePositionContainerView
class TimePositionLabelContainerView: UIView
{
    private var _barLabelView: UILabel! = nil;
    private var _separatoreView: UILabel! = nil;
    private var _beatLabelView: UILabel! = nil;
    
    //accessors
    var barLabelText: String
    {
        get { return _barLabelView.text! }
        set { _barLabelView.text = newValue }
    }
    var beatLabelText: String
    {
        get { return _beatLabelView.text!}
        set { _beatLabelView.text = newValue }
    }
    var barLabelView: UILabel { return _barLabelView }
    var beatLabelView: UILabel { return _beatLabelView }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame);
        self.frame = frame;
        
        //  init labels
        _barLabelView = UILabel();
        _separatoreView = UILabel();
        _beatLabelView = UILabel();
        
        // configure labels
        _barLabelView.textColor = UIColor.whiteColor();
        _barLabelView.textAlignment = NSTextAlignment.Center;
        _barLabelView.font = UIFont(name: _barLabelView.font.fontName, size: 30);
        
        _separatoreView.text = ":";
        _separatoreView.textColor = UIColor.whiteColor();
        _separatoreView.textAlignment = NSTextAlignment.Center;
        _separatoreView.font = UIFont(name: _separatoreView.font.fontName, size: 30);
        
        _beatLabelView.textColor = UIColor.whiteColor();
        _beatLabelView.textAlignment = NSTextAlignment.Center;
        _beatLabelView.font = UIFont(name: _beatLabelView.font.fontName, size: 30);
        
        backgroundColor = UIColor.darkGrayColor();
        
        layer.borderWidth = 1;
        layer.borderColor = UIColor.whiteColor().CGColor;
        layer.cornerRadius = 5;
        clipsToBounds = true;
    }
    required init(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func layoutSubviews()
    {
        var rect = bounds;
     
        // view is devided into 3 equal parts
        let portion = rect.width / 3
        
        (_barLabelView.frame, rect) = rect.rectsByDividing(portion, fromEdge: CGRectEdge.MinXEdge);
        (_separatoreView.frame, _beatLabelView.frame) = rect.rectsByDividing(portion, fromEdge: CGRectEdge.MinXEdge);
        
        addSubview(_barLabelView);
        addSubview(_separatoreView);
        addSubview(_beatLabelView);
    }
}
