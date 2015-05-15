//
//  ConfigurationButtonView.swift
//  FInalProject
//
//  Created by Budge on 5/1/15.
//  Copyright (c) 2015 Budge. All rights reserved.
//

import UIKit

// lets the user switch to configuration view mode for the higlighted tile
// instance of this class is owned by the BottomContainerView
class ConfigurationButtonView: UIControl
{
    private var _cLabel: UILabel! = nil;
    
    var cLabel: UILabel { return _cLabel }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame);
        self.frame = frame
        
        _cLabel = UILabel(frame: frame)
        _cLabel.textColor = UIColor.whiteColor();
        _cLabel.textAlignment = NSTextAlignment.Center;
        _cLabel.text = "Configure"
        _cLabel.font = UIFont(name: _cLabel.font.fontName, size: 20);
        
        layer.borderWidth = 1;
        layer.borderColor = UIColor.whiteColor().CGColor;
        layer.cornerRadius = 5;
        clipsToBounds = true;
        
        backgroundColor = UIColor.darkGrayColor();
    }
    required init(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented")}
    
    override func drawRect(rect: CGRect)
    {
        _cLabel.frame.size.width = rect.width;
        _cLabel.frame.size.height = rect.height;
        
        _cLabel.frame.origin.x = rect.origin.x;
        _cLabel.frame.origin.y = rect.origin.y;
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent)
    {
        // send signal to push the configuration screen
        //  target for this signal is set in the LoadStartViewController.
        sendActionsForControlEvents(UIControlEvents.TouchUpInside);
    }
    
}
