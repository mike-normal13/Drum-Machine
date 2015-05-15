//
//  PanRandomView.swift
//  FInalProject
//
//  Created by Budge on 5/1/15.
//  Copyright (c) 2015 Budge. All rights reserved.
//

import UIKit

// lets the user choose the amount of randomness of panning for the sound each time the sound is triggered
// instance of this class is owned by the PanContainerView
class PanRandomView: UIControl
{
    // flag indicating whether the SlotConfigView has a sound loaded in it.
    //      buttons will have no effect if false.
    private var _soundIsLoaded: Bool = false;
    
    private var _panRandomLabel: UILabel! = nil;
    
    private var _minusButton: UIButton! = nil;
    private var _plusButton: UIButton! = nil;
    
    private var _panRandomValueLabel: UILabel! = nil;
    
    //  -1 ... 1, +/- 0.01
    private var _currentRandom: Int = 0;
    
    //  accessors
    var currentPanRandomPosition: Int
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
        
        _panRandomLabel = UILabel();
        _minusButton = UIButton();
        _plusButton = UIButton();
        _panRandomValueLabel = UILabel();
        
        _minusButton.setTitle("-", forState: UIControlState.Normal);
        _plusButton.setTitle("+", forState: UIControlState.Normal);
        
        _minusButton.showsTouchWhenHighlighted = true;
        _plusButton.showsTouchWhenHighlighted = true;
        
        _minusButton.backgroundColor = UIColor.whiteColor();
        _minusButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal);
        
        _plusButton.backgroundColor = UIColor.whiteColor();
        _plusButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal);
        
        _panRandomLabel.textColor = UIColor.whiteColor();
        _panRandomValueLabel.textColor = UIColor.whiteColor();
        
        //  center labels
        _panRandomLabel.textAlignment = NSTextAlignment.Center
        _panRandomValueLabel.textAlignment = NSTextAlignment.Center;
        
        layer.borderWidth = 1;
        layer.borderColor = UIColor.whiteColor().CGColor;
        layer.cornerRadius = 5;
        clipsToBounds = true;
        
        _minusButton.addTarget(self, action: "decrementPanRandom:", forControlEvents: UIControlEvents.TouchDown);
        _plusButton.addTarget(self, action: "incrementPanRandom:", forControlEvents: UIControlEvents.TouchDown);
        
        backgroundColor = UIColor.lightGrayColor();
    }
    
    required init(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func drawRect(rect: CGRect)
    {
        _minusButton.layer.cornerRadius = 5;
        _plusButton.layer.cornerRadius = 5;
        
        _panRandomLabel.frame.size.width  = self.frame.width;
        _panRandomLabel.frame.size.height = self.frame.height / 3;
        
        _minusButton.frame.size.width = self.frame.width / 2;
        _minusButton.frame.size.height = self.frame.height / 3;
        
        _plusButton.frame.size.width = self.frame.width / 2;
        _plusButton.frame.size.height = self.frame.height / 3;
        
        _panRandomValueLabel.frame.size.width = self.frame.width;
        _panRandomValueLabel.frame.size.height = self.frame.height / 3;
        
        _panRandomLabel.frame.origin.x = rect.origin.x;
        _panRandomLabel.frame.origin.y = rect.origin.y;
        
        _minusButton.frame.origin.x = frame.origin.x;
        _minusButton.frame.origin.y = frame.height * (1/3);
        
        _plusButton.frame.origin.x = frame.width / 2;
        _plusButton.frame.origin.y = _minusButton.frame.origin.y;
        
        _panRandomValueLabel.frame.origin.x = frame.origin.x;
        _panRandomValueLabel.frame.origin.y = frame.height * (2/3);
        
        _panRandomLabel.text = "Random";
        
        _panRandomValueLabel.text = "\(_currentRandom) %";
        
        addSubview(_panRandomLabel);
        addSubview(_minusButton);
        addSubview(_plusButton);
        addSubview(_panRandomValueLabel);
    }
    
    // handles the user pressing the minus button
    func decrementPanRandom(button: UIButton)
    {
        // sound must be loaded for the control to be adjusted
        if(_soundIsLoaded == true)
        {
            if (_currentRandom > 0)
            {
                if(_currentRandom > 1)
                {
                    _currentRandom--;
                }
                else
                {
                    _currentRandom = 0;
                }
                setNeedsDisplay();
                sendActionsForControlEvents(UIControlEvents.TouchDown);
            }
        }
    }
    
    // handles the user pressing the plus button
    func incrementPanRandom(button: UIButton)
    {
        // sound must be loaded for the control to be adjusted
        if(_soundIsLoaded == true)
        {
            if(_currentRandom < 100)
            {
                _currentRandom++;
                setNeedsDisplay();
                sendActionsForControlEvents(UIControlEvents.TouchDown);
            }
        }
    }

}
