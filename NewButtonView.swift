//
//  NewButtonView.swift
//  FInalProject
//
//  Created by Budge on 5/1/15.
//  Copyright (c) 2015 Budge. All rights reserved.
//

import UIKit

class NewButtonView: UIControl
{
    private var _newLabel: UILabel! = nil;
    
    // alertController Members
    private var _newViewAlert: UIAlertController! = nil;
    private var _newViewYesAlertAction: UIAlertAction! = nil;
    private var _newViewNoAlertAction: UIAlertAction! = nil;
    
    // accessors
    var newLabel: UILabel { return _newLabel }
    var newViewAlert: UIAlertController! { return _newViewAlert }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame);
        self.frame = frame
        
        _newLabel = UILabel(frame: frame)
        _newLabel.textColor = UIColor.whiteColor();
        _newLabel.textAlignment = NSTextAlignment.Center;
        _newLabel.text = "New"
        _newLabel.font = UIFont(name: _newLabel.font.fontName, size: 20);
        
        layer.borderWidth = 1;
        layer.borderColor = UIColor.whiteColor().CGColor;
        layer.cornerRadius = 5;
        clipsToBounds = true;
        
        backgroundColor = UIColor.darkGrayColor();
        
        _newViewAlert = UIAlertController(title: "Start New Project", message: "Are You Sure You Want To Start A New Project?", preferredStyle: UIAlertControllerStyle.Alert);
        
        _newViewYesAlertAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: {
            action in switch action.style
            {
            case .Default:
                self.leaveCurrentProject();
            default:
                println("default default")
            }
        })
        
        _newViewNoAlertAction = UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler: {
            action in switch action.style
            {
            case .Default:
                self.stayInCurrentProject();
            default:
                println("default default")
            }
        })
        
        _newViewAlert.addAction(_newViewYesAlertAction);
        _newViewAlert.addAction(_newViewNoAlertAction);
    }
    required init(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented")}
    
    override func drawRect(rect: CGRect)
    {
        _newLabel.frame.size.width = rect.width;
        _newLabel.frame.size.height = rect.height;
        
        _newLabel.frame.origin.x = rect.origin.x;
        _newLabel.frame.origin.y = rect.origin.y;
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent)
    {
        sendActionsForControlEvents(UIControlEvents.TouchUpInside);
    }
    
    func leaveCurrentProject()
    {
        sendActionsForControlEvents(UIControlEvents.TouchDown);
    }
    
    func stayInCurrentProject()
    {
        sendActionsForControlEvents(UIControlEvents.ValueChanged);
    }
}
