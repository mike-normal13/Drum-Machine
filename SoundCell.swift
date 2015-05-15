//
//  SoundCell.swift
//  FInalProject
//
//  Created by Budge on 5/1/15.
//  Copyright (c) 2015 Budge. All rights reserved.
//

import UIKit

// Responsible for the custom cells in SoundCatagoryViewContorller's table view.
//  many instances of this class will be owned by the SoundCatagoryViewContorller
class SoundCell: UITableViewCell
{
    private var _playButton: UIButton = UIButton()
    private var _selectButton: UIButton = UIButton();
    
    //  accessors
    var playButton: UIButton { return _playButton }
    var selectButton: UIButton { return _selectButton }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        
        _playButton.frame = CGRect(x: 40, y: 60, width: 80, height: 24);
        _selectButton.frame = CGRect(x: 80, y: _playButton.frame.origin.y, width: 90, height: _playButton.frame.height);
    
        _playButton.backgroundColor = UIColor.blueColor();
        _selectButton.backgroundColor = UIColor.greenColor();
    
        _playButton.showsTouchWhenHighlighted = true;
        _selectButton.showsTouchWhenHighlighted = true;
        
        _playButton.layer.cornerRadius = 5
        _selectButton.layer.cornerRadius = 5;
    
        _playButton.setTitle("Play", forState: UIControlState.Normal);
        _selectButton.setTitle("Choose", forState: UIControlState.Normal);
        
        self.selectionStyle = .None;
        
        self.contentView.addSubview(playButton);
        self.contentView.addSubview(selectButton);
    }
    
    override func drawRect(rect: CGRect)
    {
        _playButton.frame.origin.x = rect.width * 0.6;
        _playButton.frame.origin.y = rect.height * 0.25;
        
        _selectButton.frame.origin.x = rect.width * 0.8;
        _selectButton.frame.origin.y = _playButton.frame.origin.y;
    }
    required init(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
