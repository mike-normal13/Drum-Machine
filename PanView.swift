//
//  PanView.swift
//  FInalProject
//
//  Created by Budge on 5/1/15.
//  Copyright (c) 2015 Budge. All rights reserved.
//

import UIKit

//  lets the user choose where the sound is panned to 
// instance of this class is owned by the PanContainerView
class PanView: UIControl
{
    // flag indicating whether the SlotConfigView has a sound loaded in it.
    //      buttons will have no effect if false.
    private var _soundIsLoaded: Bool = false;
    
    private var _panLabel: UILabel! = nil;
    
    private var _minusButton: UIButton! = nil;
    private var _plusButton: UIButton! = nil;
    
    private var _panValueLabel: UILabel! = nil;
    
    //  -1 ... 1, +/- 0.01
    private var _currentPanPosition: Int = 0;
    
    //  accessors
    var currentPanPosition: Int
    {
        get { return _currentPanPosition }
        set { _currentPanPosition = newValue }
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
        
        _panLabel = UILabel();
        _minusButton = UIButton();
        _plusButton = UIButton();
        _panValueLabel = UILabel();
        
        _minusButton.setTitle("L", forState: UIControlState.Normal);
        _plusButton.setTitle("R", forState: UIControlState.Normal);
        
        _minusButton.showsTouchWhenHighlighted = true;
        _plusButton.showsTouchWhenHighlighted = true;
        
        _minusButton.backgroundColor = UIColor.whiteColor();
        _minusButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal);
        
        _plusButton.backgroundColor = UIColor.whiteColor();
        _plusButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal);
        
        _panLabel.textColor = UIColor.whiteColor();
        _panValueLabel.textColor = UIColor.whiteColor();
        
        //  center labels
        _panLabel.textAlignment = NSTextAlignment.Center
        _panValueLabel.textAlignment = NSTextAlignment.Center;
        
        layer.borderWidth = 1;
        layer.borderColor = UIColor.whiteColor().CGColor;
        layer.cornerRadius = 5;
        clipsToBounds = true;
        
        _minusButton.addTarget(self, action: "panLeft:", forControlEvents: UIControlEvents.TouchDown);
        _plusButton.addTarget(self, action: "panRight:", forControlEvents: UIControlEvents.TouchDown);
        
        backgroundColor = UIColor.grayColor();
    }
    
    required init(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func drawRect(rect: CGRect)
    {
        _minusButton.layer.cornerRadius = 5;
        _plusButton.layer.cornerRadius = 5;
        
        _panLabel.frame.size.width  = self.frame.width;
        _panLabel.frame.size.height = self.frame.height / 3;
        
        _minusButton.frame.size.width = self.frame.width / 2;
        _minusButton.frame.size.height = self.frame.height / 3;
        
        _plusButton.frame.size.width = self.frame.width / 2;
        _plusButton.frame.size.height = self.frame.height / 3;
        
        _panValueLabel.frame.size.width = self.frame.width;
        _panValueLabel.frame.size.height = self.frame.height / 3;
        
        _panLabel.frame.origin.x = rect.origin.x;
        _panLabel.frame.origin.y = rect.origin.y;
        
        _minusButton.frame.origin.x = frame.origin.x;
        _minusButton.frame.origin.y = frame.height * (1/3);
        
        _plusButton.frame.origin.x = frame.width / 2;
        _plusButton.frame.origin.y = _minusButton.frame.origin.y;
        
        _panValueLabel.frame.origin.x = frame.origin.x;
        _panValueLabel.frame.origin.y = frame.height * (2/3);
        
        _panLabel.text = "Pan";
        
        // if left of center
        if(_currentPanPosition < 0)
        {
            _panValueLabel.text = "\(_currentPanPosition) L";
        }
        // if right of center
        else if(_currentPanPosition > 0)
        {
            _panValueLabel.text = "\(_currentPanPosition) R";
        }
        else
        {
            _panValueLabel.text = "\(_currentPanPosition) C";
        }
        
        addSubview(_panLabel);
        addSubview(_minusButton);
        addSubview(_plusButton);
        addSubview(_panValueLabel);
    }
    
    // handles the user pressing the minus button
    func panLeft(button: UIButton)
    {
        // sound must be loaded for the control to be adjusted
        if(_soundIsLoaded == true)
        {
            if (_currentPanPosition > -100)
            {
                _currentPanPosition--;
                setNeedsDisplay();
                sendActionsForControlEvents(UIControlEvents.TouchDown);
            }
        }
    }
    
    // handles the user pressing the plus button
    func panRight(button: UIButton)
    {
        // sound must be loaded for the control to be adjusted
        if(_soundIsLoaded == true)
        {
            if(_currentPanPosition < 100)
            {
                _currentPanPosition++;
                setNeedsDisplay();
                sendActionsForControlEvents(UIControlEvents.TouchDown);
            }
        }
    }
}
