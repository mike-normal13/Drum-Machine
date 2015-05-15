//
//  VolumeView.swift
//  FInalProject
//
//  Created by Budge on 5/1/15.
//  Copyright (c) 2015 Budge. All rights reserved.
//

import UIKit

// lets the user choose the gain of the sound
//  instance of this class is owned by the VolumeContainerView
class VolumeView: UIControl
{
    // flag indicating whether the SlotConfigView has a sound loaded in it.
    //      buttons will have no effect if false.
    private var _soundIsLoaded: Bool = false;
    
    private var _volumeLabel: UILabel! = nil;
    
    private var _minusButton: UIButton! = nil;
    private var _plusButton: UIButton! = nil;
    
    private var _volumeValueLabel: UILabel! = nil;
    
    // 0.9 by default, +/- 0.01
    private var _currentGain: Float = 0.9;
        
    //  accessors
    var currentGain: Float
        {
        get { return _currentGain }
        set { _currentGain = newValue }
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
        
        _volumeLabel = UILabel();
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
        
        _volumeLabel.textColor = UIColor.whiteColor();
        _volumeValueLabel.textColor = UIColor.whiteColor();
        
        //  center labels
        _volumeLabel.textAlignment = NSTextAlignment.Center
        _volumeValueLabel.textAlignment = NSTextAlignment.Center;
        
        _minusButton.addTarget(self, action: "gainDown:", forControlEvents: UIControlEvents.TouchDown);
        _plusButton.addTarget(self, action: "gainUp:", forControlEvents: UIControlEvents.TouchDown);
        
        backgroundColor = UIColor.grayColor();
    }
    
    required init(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func drawRect(rect: CGRect)
    {
        _minusButton.layer.cornerRadius = 5;
        _plusButton.layer.cornerRadius = 5;
        
        _volumeLabel.frame.size.width  = self.frame.width;
        _volumeLabel.frame.size.height = self.frame.height / 3;
        
        _minusButton.frame.size.width = self.frame.width / 2;
        _minusButton.frame.size.height = self.frame.height / 3;
        
        _plusButton.frame.size.width = self.frame.width / 2;
        _plusButton.frame.size.height = self.frame.height / 3;
        
        _volumeValueLabel.frame.size.width = self.frame.width;
        _volumeValueLabel.frame.size.height = self.frame.height / 3;
        
        //  TODO:   this is super weird that we had to do it this way!!!!!!
        _volumeLabel.frame.origin.x = rect.origin.x;
        _volumeLabel.frame.origin.y = rect.origin.y;
        
        _minusButton.frame.origin.x = frame.origin.x;
        _minusButton.frame.origin.y = frame.height * (1/3);
        
        _plusButton.frame.origin.x = frame.width / 2;
        _plusButton.frame.origin.y = _minusButton.frame.origin.y;
        
        _volumeValueLabel.frame.origin.x = frame.origin.x;
        _volumeValueLabel.frame.origin.y = frame.height * (2/3);
        
        _volumeLabel.text = "Volume";
        _volumeValueLabel.text = "\(_currentGain) %";
        
        addSubview(_volumeLabel);
        addSubview(_minusButton);
        addSubview(_plusButton);
        addSubview(_volumeValueLabel);
    }
    
    // handles the user pressing the minus button
    func gainDown(button: UIButton)
    {
        // sound must be loaded for the control to be adjusted
        if(_soundIsLoaded == true)
        {
            // 0 is lower bound
            if (_currentGain > 0.01)
            {
                _currentGain -= 0.01;
                setNeedsDisplay();
                sendActionsForControlEvents(UIControlEvents.TouchDown);
            }
            
            // band aid
            if(_currentGain < 0 || _currentGain > 5)
            {
                _currentGain = 0;
            }
        }
    }
    
    // handles the user pressing the plus button
    func gainUp(button: UIButton)
    {
        // sound must be loaded for the control to be adjusted
        if(_soundIsLoaded == true)
        {
            // 4 is upper bound
            if(_currentGain < 3.99)
            {
                _currentGain += 0.01;
                setNeedsDisplay();
                sendActionsForControlEvents(UIControlEvents.TouchDown);
            }
        }
    }
}
