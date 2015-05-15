//
//  TransposeRandomView.swift
//  FInalProject
//
//  Created by Budge on 5/1/15.
//  Copyright (c) 2015 Budge. All rights reserved.
//

import UIKit

// lets the user select the level of randomness applied to the sounds pitch each time the sound is triggered
// instance of this class is owned by the TransposeContainerView
class TransposeRandomView: UIControl
{
    // flag indicating whether the SlotConfigView has a sound loaded in it.
    //      buttons will have no effect if false.
    private var _soundIsLoaded: Bool = false;
    
    private var _randomLabel: UILabel! = nil;
    
    private var _minusButton: UIButton! = nil;
    private var _plusButton: UIButton! = nil;
    
    private var _randomValueLabel: UILabel! = nil;
    
    // THe start position will have a resolution of semitones(Ints)
    private var _currentRandom: UInt32 = 0;
    
    //  accessors
    var currentRandom: UInt32
    {
        get { return _currentRandom }
        set { _currentRandom = newValue }
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
                
        _randomLabel = UILabel();
        _minusButton = UIButton();
        _plusButton = UIButton();
        _randomValueLabel = UILabel();
        
        _minusButton.setTitle("-", forState: UIControlState.Normal);
        _plusButton.setTitle("+", forState: UIControlState.Normal);
        
        _minusButton.showsTouchWhenHighlighted = true;
        _plusButton.showsTouchWhenHighlighted = true;
        
        _minusButton.backgroundColor = UIColor.whiteColor();
        _minusButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal);
        
        _plusButton.backgroundColor = UIColor.whiteColor();
        _plusButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal);
        
        _randomLabel.textColor = UIColor.whiteColor();
        _randomValueLabel.textColor = UIColor.whiteColor();
        
        _randomLabel.textAlignment = NSTextAlignment.Center;
        _randomValueLabel.textAlignment = NSTextAlignment.Center;
        
        layer.borderWidth = 1;
        layer.cornerRadius = 5;
        layer.borderColor = UIColor.whiteColor().CGColor
        clipsToBounds = true;
        
        _minusButton.addTarget(self, action: "decrementRandom:", forControlEvents: UIControlEvents.TouchDown);
        _plusButton.addTarget(self, action: "incrementRandom:", forControlEvents: UIControlEvents.TouchDown);
        
        backgroundColor = UIColor.lightGrayColor();
    }
    required init(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func drawRect(rect: CGRect)
    {
        _minusButton.layer.cornerRadius = 5;
        _plusButton.layer.cornerRadius = 5;
        
        _randomLabel.frame.size.width  = self.frame.width;
        _randomLabel.frame.size.height = self.frame.height / 3;
        
        _minusButton.frame.size.width = self.frame.width / 2;
        _minusButton.frame.size.height = self.frame.height / 3;
        
        _plusButton.frame.size.width = self.frame.width / 2;
        _plusButton.frame.size.height = self.frame.height / 3;
        
        _randomValueLabel.frame.size.width = self.frame.width;
        _randomValueLabel.frame.size.height = self.frame.height / 3;
        
        _randomLabel.frame.origin.x = rect.origin.x;
        _randomLabel.frame.origin.y = rect.origin.y;
        
        _minusButton.frame.origin.x = frame.origin.x;
        _minusButton.frame.origin.y = frame.height * (1/3);
        
        _plusButton.frame.origin.x = frame.width / 2;
        _plusButton.frame.origin.y = _minusButton.frame.origin.y;
        
        _randomValueLabel.frame.origin.x = frame.origin.x;
        _randomValueLabel.frame.origin.y = frame.height * (2/3);
        
        _randomLabel.text = "Random";
        _randomValueLabel.text = "\(_currentRandom) %";
        
        addSubview(_randomLabel);
        addSubview(_minusButton);
        addSubview(_plusButton);
        addSubview(_randomValueLabel);
    }
    
    // handles the user pressing the minus button
    func decrementRandom(button: UIButton)
    {
        // sound must be loaded for the control to be adjusted
        if(_soundIsLoaded == true)
        {
            if (_currentRandom > 0)
            {
                _currentRandom--;
                setNeedsDisplay();
                sendActionsForControlEvents(UIControlEvents.TouchDown);
            }
            NSThread.sleepForTimeInterval(NSTimeInterval(0.01))
        }
    }
    
    // handles the user pressing the plus button
    func incrementRandom(button: UIButton)
    {
        // sound must be loaded for the control to be adjusted
        if(_soundIsLoaded == true)
        {
            //  can't increment past 48 semi tones
            if(_currentRandom < 10)
            {
                _currentRandom++;
                setNeedsDisplay();
                sendActionsForControlEvents(UIControlEvents.TouchDown);
            }
        }
    }
}
