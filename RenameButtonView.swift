//
//  RenameButtonView.swift
//  FInalProject
//
//  Created by Budge on 5/1/15.
//  Copyright (c) 2015 Budge. All rights reserved.
//

import UIKit

// allows the user to look at the view where the user can rename the current project
//  an instance of this class is owned by the BottomContainerView
class RenameButtonView: UIControl
{
    private var _renameLabel: UILabel! = nil;
    
    var renameLabel: UILabel { return _renameLabel }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame);
        self.frame = frame
        
        _renameLabel = UILabel(frame: frame)
        _renameLabel.textColor = UIColor.whiteColor();
        _renameLabel.textAlignment = NSTextAlignment.Center;
        _renameLabel.text = "Rename"
        _renameLabel.font = UIFont(name: _renameLabel.font.fontName, size: 20);
        
        layer.borderWidth = 1;
        layer.borderColor = UIColor.whiteColor().CGColor;
        layer.cornerRadius = 5;
        
        backgroundColor = UIColor.darkGrayColor();        
    }
    required init(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented")}
    
    override func drawRect(rect: CGRect)
    {
        _renameLabel.frame.size.width = rect.width;
        _renameLabel.frame.size.height = rect.height;
        
        _renameLabel.frame.origin.x = rect.origin.x;
        _renameLabel.frame.origin.y = rect.origin.y;
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent)
    {
        sendActionsForControlEvents(UIControlEvents.TouchUpInside);
    }
}
