//
//  SlotTileView.swift
//  FInalProject
//
//  Created by Budge on 5/1/15.
//  Copyright (c) 2015 Budge. All rights reserved.
//

import UIKit

// triggers the sound and displays the sounds name
// 5 instances of this class will belong to the SlotTileContainerView
class SlotTileView : UIControl
{
    var _fileNameLabel: UILabel! = nil;
    
    // 0 - 4
    var _slotNumber: Int = 0;
    
    //  accessors
    var fileNameLabelText : String
    {
        get { return _fileNameLabel.text! }
        set { _fileNameLabel.text = newValue}
    }
    var slotNumber: Int
    {
        get { return _slotNumber }
        set { _slotNumber = newValue }
    }
    var fileNameLabel: UILabel { return _fileNameLabel }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame);
        
        self.frame = frame;
        
        _fileNameLabel = UILabel(frame: frame);
        _fileNameLabel.textColor = UIColor.whiteColor()
        _fileNameLabel.font = UIFont(name: _fileNameLabel.font.fontName, size: 15);
        
        backgroundColor = UIColor.blueColor();
        
        _fileNameLabel.textAlignment = NSTextAlignment.Center;
        _fileNameLabel.clipsToBounds = true;
        
        layer.borderWidth = 1;
        layer.borderColor = UIColor.whiteColor().CGColor;
        layer.cornerRadius = 5;
        clipsToBounds = true;
    }
    required init(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func drawRect(rect: CGRect)
    {
        _fileNameLabel.frame.size.width = rect.width;
        _fileNameLabel.frame.size.height = rect.height;
        
        _fileNameLabel.frame.origin.x = rect.origin.x
        _fileNameLabel.frame.origin.y = rect.origin.y;
    }
    
    //  touching down on a tile will trigger the sound only
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent)
    {
        // target in LoadStartViewController
        self.sendActionsForControlEvents(UIControlEvents.TouchDown);
    }
    // lifting the finger highlights the tile
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent)
    {
        // target in LoadStartViewController
        sendActionsForControlEvents(UIControlEvents.TouchUpInside);
    }
}
