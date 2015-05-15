//
//  TransposeView.swift
//  FInalProject
//
//  Created by Budge on 5/1/15.
//  Copyright (c) 2015 Budge. All rights reserved.
//

import UIKit

// lets the user choose how many semitones to raise or lower the sound's pitch by
//  instance of this class is owned by the TransposeContainerView
class TransposeView: UIControl
{
    // flag indicating whether the SlotConfigView has a sound loaded in it.
    //      buttons will have no effect if false.
    private var _soundIsLoaded: Bool = false;
    
    private var _transposeLabel: UILabel! = nil;
    
    private var _minusButton: UIButton! = nil;
    private var _plusButton: UIButton! = nil;
    
    private var _semiToneLabel: UILabel! = nil;
    
    // The start position will have a resolution of semitones(Ints)
    private var _currentTone: Int = 0;
    
    //  accessors
    var currentTone: Int
        {
        get { return _currentTone }
        set { _currentTone = newValue }
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
        
        _transposeLabel = UILabel();
        _minusButton = UIButton();
        _plusButton = UIButton();
        _semiToneLabel = UILabel();
        
        _minusButton.setTitle("-", forState: UIControlState.Normal);
        _plusButton.setTitle("+", forState: UIControlState.Normal);
        
        _minusButton.showsTouchWhenHighlighted = true;
        _plusButton.showsTouchWhenHighlighted = true;
        
        _minusButton.backgroundColor = UIColor.whiteColor();
        _minusButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal);
        
        _plusButton.backgroundColor = UIColor.whiteColor();
        _plusButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal);
        
        _transposeLabel.textColor = UIColor.whiteColor();
        _semiToneLabel.textColor = UIColor.whiteColor();
        
        _transposeLabel.textAlignment = NSTextAlignment.Center
        _semiToneLabel.textAlignment = NSTextAlignment.Center
        
        layer.borderWidth = 1;
        layer.cornerRadius = 5;
        layer.borderColor = UIColor.whiteColor().CGColor
        clipsToBounds = true;
        
        _minusButton.addTarget(self, action: "decrementTone:", forControlEvents: UIControlEvents.TouchDown);
        _plusButton.addTarget(self, action: "incrementTone:", forControlEvents: UIControlEvents.TouchDown);
        
        backgroundColor = UIColor.grayColor();
    }
    required init(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func drawRect(rect: CGRect)
    {
        _minusButton.layer.cornerRadius = 5;
        _plusButton.layer.cornerRadius = 5;
        
        _transposeLabel.frame.size.width  = self.frame.width;
        _transposeLabel.frame.size.height = self.frame.height / 3;
        
        _minusButton.frame.size.width = self.frame.width / 2;
        _minusButton.frame.size.height = self.frame.height / 3;
        
        _plusButton.frame.size.width = self.frame.width / 2;
        _plusButton.frame.size.height = self.frame.height / 3;
        
        _semiToneLabel.frame.size.width = self.frame.width;
        _semiToneLabel.frame.size.height = self.frame.height / 3;
        
        _transposeLabel.frame.origin.x = rect.origin.x;
        _transposeLabel.frame.origin.y = rect.origin.y;
        
        _minusButton.frame.origin.x = frame.origin.x;
        _minusButton.frame.origin.y = frame.height * (1/3);
        
        _plusButton.frame.origin.x = frame.width / 2;
        _plusButton.frame.origin.y = _minusButton.frame.origin.y;
        
        _semiToneLabel.frame.origin.x = frame.origin.x;
        _semiToneLabel.frame.origin.y = frame.height * (2/3);
        
        _transposeLabel.text = "Transpose";
        _semiToneLabel.text = "\(_currentTone) st";
        
        addSubview(_transposeLabel);
        addSubview(_minusButton);
        addSubview(_plusButton);
        addSubview(_semiToneLabel);
    }
    
    // handles the user pressing the minus button
    func decrementTone(button: UIButton)
    {
        // sound must be loaded for the control to be adjusted
        if(_soundIsLoaded == true)
        {
            // can't decrement past -48 semitones
            if (_currentTone > -48)
            {
                _currentTone--;
                setNeedsDisplay();
                sendActionsForControlEvents(UIControlEvents.TouchDown);
            }
        }
    }
    
    // handles the user pressing the plus button
    func incrementTone(button: UIButton)
    {
        // sound must be loaded for the control to be adjusted
        if(_soundIsLoaded == true)
        {
            //  can't increment past 48 semi tones
            if(_currentTone < 48)
            {
                _currentTone++;
                setNeedsDisplay();
                sendActionsForControlEvents(UIControlEvents.TouchDown);
            }
        }
    }
}

