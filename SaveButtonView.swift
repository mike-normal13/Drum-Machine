//
//  SaveButtonView.swift
//  FInalProject
//
//  Created by Budge on 5/1/15.
//  Copyright (c) 2015 Budge. All rights reserved.
//

import UIKit

class SaveButtonView: UIControl
{
    private var _saveLabel: UILabel! = nil;
    
    var saveLabel: UILabel { return _saveLabel }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame);
        self.frame = frame
        
        _saveLabel = UILabel(frame: frame)
        _saveLabel.textColor = UIColor.whiteColor();
        _saveLabel.textAlignment = NSTextAlignment.Center;
        _saveLabel.text = "Save"
        _saveLabel.font = UIFont(name: _saveLabel.font.fontName, size: 20);
        
        layer.borderWidth = 1;
        layer.borderColor = UIColor.whiteColor().CGColor;
        layer.cornerRadius = 5;
        clipsToBounds = true;
        
        backgroundColor = UIColor.darkGrayColor();
    }
    required init(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented")}
    
    override func drawRect(rect: CGRect)
    {
        _saveLabel.frame.size.width = rect.width;
        _saveLabel.frame.size.height = rect.height;
        
        _saveLabel.frame.origin.x = rect.origin.x;
        _saveLabel.frame.origin.y = rect.origin.y;
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent)
    {
        // send signal to save the project
        //  target for this signal is set in the LoadStartViewController.
        sendActionsForControlEvents(UIControlEvents.TouchUpInside);
    }
}
