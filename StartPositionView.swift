//
//  StartPositionView.swift
//  FInalProject
//
//  Created by Budge on 5/1/15.
//  Copyright (c) 2015 Budge. All rights reserved.
//

import UIKit

// lets the user choose how far into the sample to start playback
//  instance of this class is owned by the SlotConfigView
class StartPositionView: UIControl
{
    private var _startLabel: UILabel! = nil;
    
    private var _minusButton: UIButton! = nil;
    private var _plusButton: UIButton! = nil;
    
    private var _positionLabel: UILabel! = nil;
    
    // THe start position will have a resolution of milliseconds, no more, no less... 
    private var _startPosition: Int64 = 0;
    
    // represents the furthest position "_startPostion" can be incremented to.
    private var _maxPosition: Int64! = nil;
    
    // flag indicating whether the SlotConfigView has a sound loaded in it.
    //      buttons will have no effect if false.
    private var _soundIsLoaded: Bool = false;
    
    private var _opQueue: NSOperationQueue! = nil;
    
    //  accessors
    var startPosition: Int64
    {
        get { return _startPosition }
        set { _startPosition = newValue }
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
        
        _startLabel = UILabel();
        _minusButton = UIButton();
        _plusButton = UIButton();
        _positionLabel = UILabel();
        
        _minusButton.setTitle("-", forState: UIControlState.Normal);
        _plusButton.setTitle("+", forState: UIControlState.Normal);

        _minusButton.showsTouchWhenHighlighted = true;
        _plusButton.showsTouchWhenHighlighted = true;
        
        _minusButton.backgroundColor = UIColor.whiteColor();
        _minusButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal);
        
        _plusButton.backgroundColor = UIColor.whiteColor();
        _plusButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal);

        _startLabel.textColor = UIColor.whiteColor();
        _positionLabel.textColor = UIColor.whiteColor();
        
        _startLabel.textAlignment = NSTextAlignment.Center
        _positionLabel.textAlignment = NSTextAlignment.Center
        
        layer.borderWidth = 1;
        layer.borderColor = UIColor.whiteColor().CGColor;
        layer.cornerRadius = 5;
        clipsToBounds = true;
        
        _minusButton.addTarget(self, action: "decrementStart:", forControlEvents: UIControlEvents.TouchDown);
        _plusButton.addTarget(self, action: "incrementStart:", forControlEvents: UIControlEvents.TouchDown);
    }

    required init(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func drawRect(rect: CGRect)
    {
        _minusButton.layer.cornerRadius = 5;
        _plusButton.layer.cornerRadius = 5;
        
        _startLabel.frame.size.width  = self.frame.width;
        _startLabel.frame.size.height = self.frame.height / 3;
        
        _minusButton.frame.size.width = self.frame.width / 2;
        _minusButton.frame.size.height = self.frame.height / 3;
        
        _plusButton.frame.size.width = self.frame.width / 2;
        _plusButton.frame.size.height = self.frame.height / 3;
        
        _positionLabel.frame.size.width = self.frame.width;
        _positionLabel.frame.size.height = self.frame.height / 3;
        
        _startLabel.frame.origin.x = rect.origin.x;
        _startLabel.frame.origin.y = rect.origin.y;
        
        _minusButton.frame.origin.x = frame.origin.x;
        _minusButton.frame.origin.y = frame.height * (1/3);
        
        _plusButton.frame.origin.x = frame.width / 2;
        _plusButton.frame.origin.y = _minusButton.frame.origin.y;
        
        _positionLabel.frame.origin.x = frame.origin.x;
        _positionLabel.frame.origin.y = frame.height * (2/3);
        
        _startLabel.text = "Start";
        _positionLabel.text = "\(_startPosition) ms";
        
        addSubview(_startLabel);
        addSubview(_minusButton);
        addSubview(_plusButton);
        addSubview(_positionLabel);
    }
    
    // handles the user pressing and holding the minus button
    func decrementStart(button: UIButton)
    {
        if(_maxPosition != nil)
        {
            // it is looking like having press and hold functionality will require threads......
            if(button.state != UIControlState.Normal)
            {
                // can't decrement past the file's starting point
                if (_startPosition > 0 && _soundIsLoaded == true)
                {
                    // have separate thread handle the user holding the button down
                    _opQueue.addOperationWithBlock()
                    {
                        self._startPosition--;
                        
                        //  main thread updates display
                        NSOperationQueue.mainQueue().addOperationWithBlock()
                        {
                            self.setNeedsDisplay();
                        }
                
                        self.sendActionsForControlEvents(UIControlEvents.TouchDownRepeat);
                        NSThread.sleepForTimeInterval(NSTimeInterval(0.08));
                        self.decrementStart(button);
                    }
                }
            }
        }
    }
    
    // handles the user pressing the plus button
    func incrementStart(button: UIButton)
    {
        if(_maxPosition != nil)
        {
            if(button.state != UIControlState.Normal)
            {
                //  can't increment past the file's last frame
                if(_startPosition < _maxPosition && _soundIsLoaded == true) // + 40???
                {
                    _opQueue.addOperationWithBlock()
                    {
                        self._startPosition++;
                        
                        NSOperationQueue.mainQueue().addOperationWithBlock()
                        {
                            self.setNeedsDisplay();
                        }
                        self.sendActionsForControlEvents(UIControlEvents.TouchDownRepeat);
                        NSThread.sleepForTimeInterval(NSTimeInterval(0.08));
                        self.incrementStart(button);
                    }
                }
            }
        }
    }
}
