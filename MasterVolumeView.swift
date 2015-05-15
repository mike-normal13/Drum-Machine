//
//  MasterVolumeView.swift
//  FInalProject
//
//  Created by Budge on 5/1/15.
//  Copyright (c) 2015 Budge. All rights reserved.
//

import UIKit

// allows the user to turn up/down the volume on all sounds
// instance of this class is owned by the BottomContainerView
class MasterVolumeView: UIControl
{
    private var _minusButton: UIButton! = nil;
    private var _plusButton: UIButton! = nil;
    
    private var _volumeValueLabel: UILabel! = nil;
    
    private var _currentMasterVolume: Float = 1;  // default
    private var _maxMasterVolume: Float = 3;
    
    private var _opQueue: NSOperationQueue! = nil; // for press and hold
    
    //  accessors
    var minusButton: UIButton! { return _minusButton }
    var plusButton: UIButton! { return _plusButton }
    var currentMasterVolume: Float
    {
        get { return _currentMasterVolume }
        set { _currentMasterVolume = newValue }
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame);
        self.frame = frame;
        
        _opQueue = NSOperationQueue();
        
        _minusButton = UIButton();
        _plusButton = UIButton();
        _volumeValueLabel = UILabel();
        
        _minusButton.setTitle("-", forState: UIControlState.Normal);
        _plusButton.setTitle("+", forState: UIControlState.Normal);
        
        _minusButton.showsTouchWhenHighlighted = true;
        _plusButton.showsTouchWhenHighlighted = true;
        
        _minusButton.backgroundColor = UIColor.whiteColor();
        _minusButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal);
        
        _plusButton.backgroundColor = UIColor.whiteColor();
        _plusButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal);
        
        _volumeValueLabel.textColor = UIColor.whiteColor();
        
        _volumeValueLabel.textAlignment = NSTextAlignment.Center
        
        layer.borderWidth = 1;
        layer.borderColor = UIColor.whiteColor().CGColor;
        layer.cornerRadius = 5;
        
        _minusButton.addTarget(self, action: "decrementMasterVolume:", forControlEvents: UIControlEvents.TouchDown);
        _plusButton.addTarget(self, action: "incrementMasterVolume:", forControlEvents: UIControlEvents.TouchDown);
    }
    required init(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func drawRect(rect: CGRect)
    {
        _minusButton.layer.cornerRadius = 5;
        _plusButton.layer.cornerRadius = 5;
        
        _minusButton.frame.size.width = (self.frame.width / 4)
        _minusButton.frame.size.height = (self.frame.height)
        
        _plusButton.frame.size.width = (self.frame.width / 4)
        _plusButton.frame.size.height = (self.frame.height)
        
        _volumeValueLabel.frame.size.width = self.frame.width / 2;
        _volumeValueLabel.frame.size.height = self.frame.height;
        
        _minusButton.frame.origin.x = rect.origin.x;
        _minusButton.frame.origin.y = rect.origin.y;
        
        _plusButton.frame.origin.x = (frame.width / 4);
        _plusButton.frame.origin.y = _minusButton.frame.origin.y;
        
        _volumeValueLabel.frame.origin.x = frame.width / 2;
        _volumeValueLabel.frame.origin.y = frame.origin.y;
        
        _volumeValueLabel.text = "\(_currentMasterVolume) %";
        
        addSubview(_minusButton);
        addSubview(_plusButton);
        addSubview(_volumeValueLabel);
    }
    
    // handles the user pressing and holding the minus button
    func decrementMasterVolume(button: UIButton)
    {
        // press and hold
        if(button.state != UIControlState.Normal)
        {
            if (_currentMasterVolume > 0)
            {
                // have separate thread handle the user holding the button down
                _opQueue.addOperationWithBlock()
                {
                    if(self._currentMasterVolume < 0.01)
                    {
                        self._currentMasterVolume = 0;
                    }
                    else
                    {
                        self._currentMasterVolume -= 0.01;
                    }
                    
                    //  main thread updates display
                    NSOperationQueue.mainQueue().addOperationWithBlock()
                    {
                        self.setNeedsDisplay();
                    }
                            
                    self.sendActionsForControlEvents(UIControlEvents.TouchDownRepeat);
                    NSThread.sleepForTimeInterval(NSTimeInterval(0.05));
                    self.decrementMasterVolume(button);
                }
            }
        }
    }
    
    // handles the user pressing the plus button
    func incrementMasterVolume(button: UIButton)
    {
        if(button.state != UIControlState.Normal)
        {
            if(_currentMasterVolume < _maxMasterVolume)
            {
                _opQueue.addOperationWithBlock()
                {
                    if(self._currentMasterVolume > 2.99)
                    {
                        self._currentMasterVolume = 3
                    }
                    else
                    {
                        self._currentMasterVolume += 0.01;
                    }
                    
                    NSOperationQueue.mainQueue().addOperationWithBlock()
                    {
                        self.setNeedsDisplay();
                    }
                    
                    self.sendActionsForControlEvents(UIControlEvents.TouchDownRepeat);
                    NSThread.sleepForTimeInterval(NSTimeInterval(0.05));
                    self.incrementMasterVolume(button);
                }
            }
        }
    }
}
