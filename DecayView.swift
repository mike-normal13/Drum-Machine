//
//  DecayView.swift
//  FInalProject
//
//  Created by Budge on 5/1/15.
//  Copyright (c) 2015 Budge. All rights reserved.
//

import UIKit

// controls how long a sound plays after it is triggerd by the user
//  NOTE:   decay is dependent upon frames, not time,
//              i.e. if a sound is stretched out via the Stretch control causing the sound to play for 10 seconds,
//                  and the current decay is set at 2 seconds,
//                      the sound will not stop after 2 seconds....
//  instance of this class is owned by the DecayContainerView
class DecayView: UIControl
{
    // flag indicating whether the SlotConfigView has a sound loaded in it.
    //      buttons will have no effect if false.
    private var _soundIsLoaded: Bool = false;
    
    private var _decayLabel: UILabel! = nil;
    private var _decayValueLabel: UILabel! = nil;
    
    private var _minusButton: UIButton! = nil;
    private var _plusButton: UIButton! = nil;
    
    // represents the furthest position "_startPostion" can be incremented to.
    private var _maxPosition: Int64! = nil;
    
    // set to 3 seconds by default
    private var _currentDecay: Int64! = nil;
    
    private var _opQueue: NSOperationQueue! = nil;
    
    //  accessors
    var currentDecay: Int64
    {
        get { return _currentDecay }
        set { _currentDecay = newValue }
    }
    var maxPosition: Int64
    {
        get { return _maxPosition }
        set { _maxPosition = newValue }
    }
    var soundIsLoaded: Bool
    {
        get { return _soundIsLoaded }
        set { _soundIsLoaded = newValue }
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame);
        self.frame = frame;
        
        _opQueue = NSOperationQueue();
        
        _decayLabel = UILabel();
        _minusButton = UIButton();
        _plusButton = UIButton();
        _decayValueLabel = UILabel();
        
        _minusButton.setTitle("-", forState: UIControlState.Normal);
        _plusButton.setTitle("+", forState: UIControlState.Normal);
        
        _minusButton.showsTouchWhenHighlighted = true;
        _plusButton.showsTouchWhenHighlighted = true;
        
        _minusButton.backgroundColor = UIColor.whiteColor();
        _minusButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal);
        
        _plusButton.backgroundColor = UIColor.whiteColor();
        _plusButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal);
        
        _decayLabel.textColor = UIColor.whiteColor();
        _decayLabel.textAlignment = NSTextAlignment.Center;
        
        _decayValueLabel.textColor = UIColor.whiteColor();
        
        _decayValueLabel.font = UIFont(name: _decayValueLabel.font.fontName, size: 12);
        _decayValueLabel.textAlignment = NSTextAlignment.Center;
        
        _minusButton.addTarget(self, action: "decrementDecay:", forControlEvents: UIControlEvents.TouchDown);
        _plusButton.addTarget(self, action: "incrementDecay:", forControlEvents: UIControlEvents.TouchDown);

        backgroundColor = UIColor.grayColor();
    }
    required init(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func drawRect(rect: CGRect)
    {
        _minusButton.layer.cornerRadius = 5;
        _plusButton.layer.cornerRadius = 5;
        
        _decayLabel.frame.size.width  = self.frame.width;
        _decayLabel.frame.size.height = self.frame.height * (1/3);
        
        _minusButton.frame.size.width = self.frame.width / 2;
        _minusButton.frame.size.height = self.frame.height * (1/3);
        
        _plusButton.frame.size.width = self.frame.width / 2;
        _plusButton.frame.size.height = self.frame.height * (1/3);
        
        _decayValueLabel.frame.size.width = self.frame.width;
        _decayValueLabel.frame.size.height = self.frame.height * (1/3);
        
        _decayLabel.frame.origin.x = rect.origin.x;
        _decayLabel.frame.origin.y = rect.origin.y;
        
        _minusButton.frame.origin.x = frame.origin.x;
        _minusButton.frame.origin.y = frame.height * (1/3);
        
        _plusButton.frame.origin.x = frame.width / 2;
        _plusButton.frame.origin.y = _minusButton.frame.origin.y;
        
        _decayValueLabel.frame.origin.x = frame.origin.x;
        _decayValueLabel.frame.origin.y = frame.height * (2/3);
        
        
        _decayLabel.text = "Decay";
        
        if(_maxPosition == nil)
        {
            _decayValueLabel.text = "-- ms";
        }
        else
        {
            _decayValueLabel.text = "\(_currentDecay) ms";
        }
        
        var x = _maxPosition;
        
        addSubview(_decayLabel);
        addSubview(_minusButton);
        addSubview(_plusButton);
        addSubview(_decayValueLabel);
    }
    
    //  Both this method and the incrementer increment the cuttoff point by 10 ms
    // handles the user pressing the minus button
    func decrementDecay(button: UIButton)
    {
        // sound must be loaded for the control to be adjusted
        if(_maxPosition != nil)
        {
            // it is looking like having press and hold functionality will require threads......
            if(button.state != UIControlState.Normal)
            {
                // can't decrement past file's starting point
                if (_currentDecay > 10 && _soundIsLoaded == true)
                {
                    _opQueue.addOperationWithBlock()
                    {
                        self._currentDecay! -= 50;
                        
                        NSOperationQueue.mainQueue().addOperationWithBlock()
                        {
                            self.setNeedsDisplay();
                        }
                        self.sendActionsForControlEvents(UIControlEvents.TouchDown);
                    
                        NSThread.sleepForTimeInterval(NSTimeInterval(0.05))
                        self.decrementDecay(button);
                    }
                }
            }
        }
    }
    
    // handles the user pressing the plus button
    func incrementDecay(button: UIButton)
    {
        // sound must be loaded for the control to be adjusted
        if(_maxPosition != nil)
        {
            if(button.state != UIControlState.Normal)
            {
                // can't incremnt past file's last frame
                if(_currentDecay < _maxPosition && _soundIsLoaded == true)
                {
                    _opQueue.addOperationWithBlock()
                    {
                        self._currentDecay! += 50;
                        
                        NSOperationQueue.mainQueue().addOperationWithBlock()
                        {
                            self.setNeedsDisplay();
                        }
                        self.sendActionsForControlEvents(UIControlEvents.TouchDown);
                        
                        NSThread.sleepForTimeInterval(NSTimeInterval(0.05))
                        self.incrementDecay(button);
                    }
                }
            }
        }
    }
}
