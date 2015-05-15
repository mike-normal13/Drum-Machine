//
//  StretchView.swift
//  FInalProject
//
//  Created by Budge on 5/1/15.
//  Copyright (c) 2015 Budge. All rights reserved.
//

import UIKit

// lets the user alter the rate and pitch of the sound independently
//  instance of this class is owned by the SlotConfigView
class StretchView: UIControl
{
    // flag indicating whether the SlotConfigView has a sound loaded in it.
    //      buttons will have no effect if false.
    private var _soundIsLoaded: Bool = false;
    
    private var _stretchLabel: UILabel! = nil;
    private var _pitchLabel: UILabel! = nil;
    private var _pitchAmountLabel: UILabel! = nil;
    private var _rateLabel: UILabel! = nil;
    private var _rateAmountLabel: UILabel! = nil;
    private var _overlapLabel: UILabel! = nil;
    private var _overlapAmountLabel: UILabel! = nil;
    
    private var _pitchMinusButton: UIButton! = nil;
    private var _pitchPlusButton: UIButton! = nil;
    private var _rateMinusButton: UIButton! = nil;
    private var _ratePlusButton: UIButton! = nil;
    private var _overlapMinusButton: UIButton! = nil;
    private var _overlapPlusButton: UIButton! = nil;
    
    private var _currentPitch: Int = 0;
    private var _currentRate: Float = 1; // as per API
    private var _currentOverlap: Float = 8.0; // as per API
    
    private var _opQueue: NSOperationQueue! = nil;
    
    //  accessors
    var currentPitch: Int
    {
        get { return _currentPitch}
        set { _currentPitch = newValue}
    }
    var currentRate: Float
        {
        get { return _currentRate }
        set { _currentRate = newValue}
    }
    var currentOverlap: Float
        {
        get { return _currentOverlap }
        set { _currentOverlap = newValue}
    }
    var pitchLabel: UILabel { return _pitchLabel }
    var pitchAmountLabel: UILabel { return _pitchAmountLabel }
    var rateLabel: UILabel { return _rateLabel }
    var rateAmountLabel: UILabel { return _rateAmountLabel }
    var overlapLabel: UILabel { return _overlapLabel }
    var overlapAmountLabel: UILabel { return _overlapAmountLabel }
    var soundIsLoaded: Bool
    {
        get { return _soundIsLoaded }
        set { _soundIsLoaded = newValue }
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame);
        self.frame = frame;
        
        _stretchLabel = UILabel();
        _pitchLabel = UILabel()
        _pitchAmountLabel = UILabel();
        _rateLabel = UILabel()
        _rateAmountLabel = UILabel();
        _overlapLabel = UILabel();
        _overlapAmountLabel = UILabel();
        
        _pitchMinusButton = UIButton();
        _pitchPlusButton = UIButton();
        _rateMinusButton = UIButton();
        _ratePlusButton = UIButton();
        _overlapMinusButton = UIButton();
        _overlapPlusButton = UIButton();
        
        _pitchMinusButton.setTitle("-", forState: UIControlState.Normal);
        _pitchPlusButton.setTitle("+", forState: UIControlState.Normal);
        _rateMinusButton.setTitle("-", forState: UIControlState.Normal);
        _ratePlusButton.setTitle("+", forState: UIControlState.Normal);
        _overlapMinusButton.setTitle("-", forState: UIControlState.Normal);
        _overlapPlusButton.setTitle("+", forState: UIControlState.Normal);
        
        _pitchMinusButton.showsTouchWhenHighlighted = true;
        _pitchPlusButton.showsTouchWhenHighlighted = true;
        _rateMinusButton.showsTouchWhenHighlighted = true;
        _ratePlusButton.showsTouchWhenHighlighted = true;
        _overlapMinusButton.showsTouchWhenHighlighted = true;
        _overlapPlusButton.showsTouchWhenHighlighted = true;
        
        _pitchMinusButton.backgroundColor = UIColor.whiteColor();
        _pitchMinusButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal);
        
        _rateMinusButton.backgroundColor = UIColor.whiteColor();
        _rateMinusButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal);
        
        _overlapMinusButton.backgroundColor = UIColor.whiteColor();
        _overlapMinusButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal);
        
        _pitchPlusButton.backgroundColor = UIColor.whiteColor();
        _pitchPlusButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal);
        
        _ratePlusButton.backgroundColor = UIColor.whiteColor();
        _ratePlusButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal);
        
        _overlapPlusButton.backgroundColor = UIColor.whiteColor();
        _overlapPlusButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal);
        
        _stretchLabel.textColor = UIColor.whiteColor();
        _pitchLabel.textColor = UIColor.whiteColor();
        _pitchAmountLabel.textColor = UIColor.whiteColor();
        _rateLabel.textColor = UIColor.whiteColor();
        _rateAmountLabel.textColor = UIColor.whiteColor();
        _overlapLabel.textColor = UIColor.whiteColor();
        _overlapAmountLabel.textColor = UIColor.whiteColor();
        
        // make the font smaller for the parameter labels
        _pitchLabel.font = UIFont(name: _pitchLabel.font.fontName, size: 11);
        _pitchAmountLabel.font = UIFont(name: _pitchLabel.font.fontName, size: 11);
        _rateLabel.font = UIFont(name: _pitchLabel.font.fontName, size: 11);
        _rateAmountLabel.font = UIFont(name: _pitchLabel.font.fontName, size: 11);
        _overlapLabel.font = UIFont(name: _pitchLabel.font.fontName, size: 11);
        _overlapAmountLabel.font = UIFont(name: _pitchLabel.font.fontName, size: 11);
        
        _stretchLabel.textAlignment = NSTextAlignment.Center
        _pitchLabel.textAlignment = NSTextAlignment.Center
        _pitchAmountLabel.textAlignment = NSTextAlignment.Center
        _rateLabel.textAlignment = NSTextAlignment.Center
        _rateAmountLabel.textAlignment = NSTextAlignment.Center
        _overlapLabel.textAlignment = NSTextAlignment.Center
        _overlapAmountLabel.textAlignment = NSTextAlignment.Center
        
        layer.borderWidth = 1;
        layer.cornerRadius = 5;
        layer.borderColor = UIColor.whiteColor().CGColor
        clipsToBounds = true;
        
        _pitchMinusButton.addTarget(self, action: "decrementPitch:", forControlEvents: UIControlEvents.TouchDown);
        _pitchPlusButton.addTarget(self, action: "incrementPitch:", forControlEvents: UIControlEvents.TouchDown);
        _rateMinusButton.addTarget(self, action: "decrementRate:", forControlEvents: UIControlEvents.TouchDown);
        _ratePlusButton.addTarget(self, action: "incrementRate:", forControlEvents: UIControlEvents.TouchDown);
        _overlapMinusButton.addTarget(self, action: "decrementOverlap:", forControlEvents: UIControlEvents.TouchDown);
        _overlapPlusButton.addTarget(self, action: "incrementOverlap:", forControlEvents: UIControlEvents.TouchDown);
    }
    required init(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func drawRect(rect: CGRect)
    {
        _pitchMinusButton.layer.cornerRadius = 5;
        _pitchPlusButton.layer.cornerRadius = 5;
        _rateMinusButton.layer.cornerRadius = 5;
        _ratePlusButton.layer.cornerRadius = 5;
        _overlapMinusButton.layer.cornerRadius = 5;
        _overlapPlusButton.layer.cornerRadius = 5;
        
        //  set dimensions of all subviews
        _stretchLabel.frame.size.width  = self.frame.width;
        _stretchLabel.frame.size.height = self.frame.height * 0.1;
        
        _pitchMinusButton.frame.size.width = self.frame.width / 2;
        _pitchMinusButton.frame.size.height = self.frame.height * 0.2;
        
        _pitchPlusButton.frame.size.width = self.frame.width / 2;
        _pitchPlusButton.frame.size.height = self.frame.height * 0.2;
        
        _pitchLabel.frame.size.width = self.frame.width * 0.5;
        _pitchLabel.frame.size.height = _stretchLabel.frame.size.height;
        
        _pitchAmountLabel.frame.size.width  = _pitchLabel.frame.size.width;
        _pitchAmountLabel.frame.size.height = _stretchLabel.frame.size.height;
        
        _rateMinusButton.frame.size.width = self.frame.width / 2;
        _rateMinusButton.frame.size.height = self.frame.height * 0.2;
        
        _ratePlusButton.frame.size.width = self.frame.width / 2;
        _ratePlusButton.frame.size.height = self.frame.height * 0.2;
        
        _rateLabel.frame.size.width  = _pitchLabel.frame.size.width;
        _rateLabel.frame.size.height = _stretchLabel.frame.size.height;
        
        _rateAmountLabel.frame.size.width  = _pitchLabel.frame.size.width;
        _rateAmountLabel.frame.size.height = _stretchLabel.frame.size.height;
        
        _overlapMinusButton.frame.size.width = self.frame.width / 2;
        _overlapMinusButton.frame.size.height = self.frame.height * 0.2;
        
        _overlapPlusButton.frame.size.width = self.frame.width / 2;
        _overlapPlusButton.frame.size.height = self.frame.height * 0.2;
        
        _overlapLabel.frame.size.width  = _pitchLabel.frame.size.width;
        _overlapLabel.frame.size.height = _stretchLabel.frame.size.height;
        
        _overlapAmountLabel.frame.size.width  = _pitchLabel.frame.size.width;
        _overlapAmountLabel.frame.size.height = _stretchLabel.frame.size.height;
        
        //  set positions of all subviews
        _stretchLabel.frame.origin.x = rect.origin.x;
        _stretchLabel.frame.origin.y = rect.origin.y;
        
        _pitchMinusButton.frame.origin.x = rect.origin.x;
        _pitchMinusButton.frame.origin.y = rect.height * 0.1;
        
        _pitchPlusButton.frame.origin.x = frame.width / 2;
        _pitchPlusButton.frame.origin.y = _pitchMinusButton.frame.origin.y;
        
        _pitchLabel.frame.origin.x = rect.origin.x;
        _pitchLabel.frame.origin.y = rect.height * 0.3;
        
        _pitchAmountLabel.frame.origin.x = _pitchPlusButton.frame.origin.x
        _pitchAmountLabel.frame.origin.y = _pitchLabel.frame.origin.y
        
        _rateMinusButton.frame.origin.x = rect.origin.x;
        _rateMinusButton.frame.origin.y = rect.height * 0.4;
        
        _ratePlusButton.frame.origin.x = _pitchPlusButton.frame.origin.x
        _ratePlusButton.frame.origin.y = _rateMinusButton.frame.origin.y
        
        _rateLabel.frame.origin.x = rect.origin.x;
        _rateLabel.frame.origin.y = rect.height * 0.6;
        
        _rateAmountLabel.frame.origin.x = _pitchPlusButton.frame.origin.x;
        _rateAmountLabel.frame.origin.y = _rateLabel.frame.origin.y
        
        _overlapMinusButton.frame.origin.x = rect.origin.x;
        _overlapMinusButton.frame.origin.y = rect.height * 0.7;
        
        _overlapPlusButton.frame.origin.x = _pitchPlusButton.frame.origin.x;
        _overlapPlusButton.frame.origin.y = _overlapMinusButton.frame.origin.y;
        
        _overlapLabel.frame.origin.x = rect.origin.x;
        _overlapLabel.frame.origin.y = rect.height * 0.9;
        
        _overlapAmountLabel.frame.origin.x = _pitchPlusButton.frame.origin.x;
        _overlapAmountLabel.frame.origin.y = _overlapLabel.frame.origin.y
        
        _stretchLabel.text = "Stretch";
        
        _pitchLabel.text = "Pitch";
        _pitchAmountLabel.text = "\(_currentPitch) st";
    
        _rateLabel.text = "Rate";
        _rateAmountLabel.text = "\(_currentRate) ";
    
        _overlapLabel.text = "Quality";
        _overlapAmountLabel.text = "\(_currentOverlap) ";
        
        addSubview(_stretchLabel);
        addSubview(_pitchMinusButton);
        addSubview(_pitchPlusButton);
        addSubview(_pitchLabel);
        addSubview(_pitchAmountLabel);
        addSubview(_rateMinusButton);
        addSubview(_ratePlusButton);
        addSubview(_rateLabel);
        addSubview(_rateAmountLabel);
        addSubview(_overlapMinusButton);
        addSubview(_overlapPlusButton);
        addSubview(_overlapLabel);
        addSubview(_overlapAmountLabel);
    }
    
    // handles the user pressing the pitch minus button
    func decrementPitch(button: UIButton)
    {
        // sound must be loaded for the control to be adjusted
        if(_soundIsLoaded == true)
        {
            // can't decrement past -48 semitones
            if (_currentPitch > -48 && _soundIsLoaded == true)
            {
                _currentPitch--;
                setNeedsDisplay();
                sendActionsForControlEvents(UIControlEvents.TouchDown);
            }
            NSThread.sleepForTimeInterval(NSTimeInterval(0.01))
        }
    }
    
    // handles the user pressing the pitch plus button
    func incrementPitch(button: UIButton)
    {
        // sound must be loaded for the control to be adjusted
        if(_soundIsLoaded == true)
        {
            //  can't increment past 48 semi tones
            if(_currentPitch < 48 && _soundIsLoaded == true)
            {
                _currentPitch++;
                setNeedsDisplay();
                sendActionsForControlEvents(UIControlEvents.TouchDown);
            }
        }
    }
    
    // handles the user pressing the rate minus button
    func decrementRate(button: UIButton)
    {
        // sound must be loaded for the control to be adjusted
        if(_soundIsLoaded == true)
        {
            if (_currentRate > 0.1 /*0.03124*/ && _soundIsLoaded == true) // as per API
            {
                _currentRate -= 0.1; //  SUSPECT we need to decrement by value less than 1
                setNeedsDisplay();
                sendActionsForControlEvents(UIControlEvents.EditingChanged);
            }
            NSThread.sleepForTimeInterval(NSTimeInterval(0.01))
            
            // band aid
            if(_currentRate < 0.1)
            {
                _currentRate = 0.1
            }
        }
    }
    
    // handles the user pressing the rate plus button
    func incrementRate(button: UIButton)
    {
        // sound must be loaded for the control to be adjusted
        if(_soundIsLoaded == true)
        {
            if(_currentRate < 32 && _soundIsLoaded == true) // as per API
            {
                _currentRate += 0.1;
                setNeedsDisplay();
                sendActionsForControlEvents(UIControlEvents.EditingChanged);
            }
        }
    }
    
    // handles the user pressing the overlap minus button
    func decrementOverlap(button: UIButton)
    {
        // sound must be loaded for the control to be adjusted
        if(_soundIsLoaded == true)
        {
            if (_currentOverlap > 3.0 && _soundIsLoaded == true) // as per API
            {
                _currentOverlap -= 0.5
                setNeedsDisplay();
                sendActionsForControlEvents(UIControlEvents.ValueChanged);
            }
        }
    }
    
    // handles the user pressing the overlap plus button
    func incrementOverlap(button: UIButton)
    {
        // sound must be loaded for the control to be adjusted
        if(_soundIsLoaded == true)
        {
            if(_currentOverlap < 32 && _soundIsLoaded == true) // as per API
            {
                _currentOverlap += 0.5
                setNeedsDisplay();
                sendActionsForControlEvents(UIControlEvents.ValueChanged);
            }
        }
    }
}
