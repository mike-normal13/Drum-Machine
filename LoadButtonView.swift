//
//  LoadButtonView.swift
//  FInalProject
//
//  Created by Budge on 5/1/15.
//  Copyright (c) 2015 Budge. All rights reserved.
//

import UIKit

// alows the user to leave the current config and load an existing one
// instance of this class is owned by the BottomContainerView
class LoadButtonView: UIControl
{
    private var _loadLabel: UILabel! = nil;
    
    var loadLabel: UILabel { return _loadLabel }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame);
        self.frame = frame
        
        _loadLabel = UILabel(frame: frame)
        _loadLabel.textColor = UIColor.whiteColor();
        _loadLabel.textAlignment = NSTextAlignment.Center;
        _loadLabel.text = "Load"
        _loadLabel.font = UIFont(name: _loadLabel.font.fontName, size: 20);
        
        layer.borderWidth = 1;
        layer.borderColor = UIColor.whiteColor().CGColor;
        layer.cornerRadius = 5;
        clipsToBounds = true;
        
        backgroundColor = UIColor.darkGrayColor();        
    }
    required init(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented")}
    
    override func drawRect(rect: CGRect)
    {
        _loadLabel.frame.size.width = rect.width;
        _loadLabel.frame.size.height = rect.height;
        
        _loadLabel.frame.origin.x = rect.origin.x;
        _loadLabel.frame.origin.y = rect.origin.y;
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent)
    {
        sendActionsForControlEvents(UIControlEvents.TouchUpInside);
    }
}
