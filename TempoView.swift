//
//  TempoView.swift
//  FInalProject
//
//  Created by Budge on 5/1/15.
//  Copyright (c) 2015 Budge. All rights reserved.
//

import UIKit

// allows the user to adjust the BPM
//  instance of this class is owned by the TimeContainerView
class TempoView: UIControl
{
    // this label will hold the current tempo
    private var _tempoLabel: UILabel! = nil;
    
    // the amount the tempo was adjusted by
    //  this value must not let the project's tempo go outside of its bounds
    private var _tempoAdjustment: Int = 0;
    
    // the starting point of the user drag
    private var _startingTouchPoint: CGPoint! = nil;
    
    //  accessors
    var tempoLabelText: String
    {
        get { return _tempoLabel.text! }
        set { _tempoLabel.text = newValue }
    }
    var tempoLabel: UILabel { return _tempoLabel }
    var tempoAdustment: Int { return _tempoAdjustment }
    
    
    override init(frame: CGRect)
    {
        super.init(frame: frame);
        self.frame = frame;
        _tempoLabel = UILabel(frame: frame);
        _tempoLabel.textColor = UIColor.whiteColor();
        _tempoLabel.textAlignment = NSTextAlignment.Center;
        _tempoLabel.font = UIFont(name: _tempoLabel.font.fontName, size: 20);
        
        layer.borderWidth = 1;
        layer.borderColor = UIColor.whiteColor().CGColor;
        layer.cornerRadius = 5;
        clipsToBounds = true;
        
        backgroundColor = UIColor.darkGrayColor();
    }
    required init(coder aDecoder: NSCoder){ fatalError("init(coder:) has not been implemented") }
    
    override func drawRect(rect: CGRect)
    {
        _tempoLabel.frame.size.width = rect.width;
        _tempoLabel.frame.size.height = rect.height;
        
        _tempoLabel.frame.origin.x = rect.origin.x;
        _tempoLabel.frame.origin.y = rect.origin.y;
        
        //_tempoLabel.text = _currentTempo;
    }
        
    private func calculateTempoAdjustment(currentTouchPoint: CGPoint)
    {
        //  TODO:   your attempts to scale here are not having close to the desired affect....
            // apply scaing factor
            _tempoAdjustment = Int((currentTouchPoint.x/50) - (_startingTouchPoint.x/50));
    }
}
