//
//  NewView.swift
//  FInalProject
//
//  Created by Budge on 5/1/15.
//  Copyright (c) 2015 Budge. All rights reserved.
//

import UIKit

// this class is the view that lets the user enter the data neccessary to start a new beat project
// instance of this class is owned by the NewViewController
class NewView: UIControl, UITextFieldDelegate
{
    // project name entered by user
    private var _projectName: String = "";
    //  number of bars entered by user
    private var _numberOfBars: String = "";
    
    // enter a name label
    private var _nameLabel: UILabel! = nil
    // name text field
    private var _nameTextField: UITextField! = nil;
    
    // enter number of bars label
    private var _barsLabel: UILabel! = nil;
    // number of bars text field
    private var _barsTextField: UITextField! = nil;
    
    // alertController Member
    private var _newViewAlert: UIAlertController! = nil;
    // alertController action correspondgin to the user choosing to overwrite existing file
    private var _newViewYesAlertAction: UIAlertAction! = nil;
    private var _newViewNoAlertAction: UIAlertAction! = nil;
    
    // path file names array, passed down from LoadStartViewController
    private var _filePathsArray: NSMutableArray! = nil;
    
    private var _masterDocumentDirectory: String = "";
    
    // accessors
    var projectName: String
    {
        get { return _projectName }
        set { _projectName = newValue }
    }
    var numberOfBars: String
    {
        get { return _numberOfBars }
        set { _numberOfBars = newValue }
    }
    var filePathsArray: NSMutableArray
    {
        get { return _filePathsArray }
        set { _filePathsArray = newValue }
    }
    var newViewAlert: UIAlertController { return _newViewAlert }
    var masterDocumentDirectory: String
    {
        get {return _masterDocumentDirectory }
        set { _masterDocumentDirectory = newValue }
    }
    var nameTextField: UITextField { return _nameTextField }
    var barsTextField: UITextField { return _barsTextField }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        _newViewAlert = UIAlertController(title: "File Already Exists", message: "The Name Of The Project You Chose Already Exists, Overwrite?", preferredStyle: UIAlertControllerStyle.Alert);
        
        _newViewYesAlertAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: {
            action in switch action.style
        {
            case .Default:
                println("default")
                self.sendActionsForControlEvents(UIControlEvents.TouchDown);
            default:
                println("default default")
            }
        })

        _newViewNoAlertAction = UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler: {
            action in switch action.style
            {
            case .Default:
                println("default")
                self.sendActionsForControlEvents(UIControlEvents.TouchCancel);
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
        // intialize 
        _nameLabel = UILabel(frame: rect);
        _nameTextField = UITextField(frame: rect);
        _barsLabel = UILabel(frame: rect);
        _barsTextField = UITextField(frame: rect);
        
        _nameTextField.delegate = self;
        _barsTextField.delegate = self;
        
        //  set name label
        _nameLabel.frame.size.width = rect.width * 0.9;
        _nameLabel.frame.size.height = rect.height * 0.07;
        _nameLabel.frame.origin.x = rect.width * 0.05;
        _nameLabel.frame.origin.y = rect.height * 0.1;
        _nameLabel.textColor = UIColor.whiteColor();
        _nameLabel.text = "Project Name:"
        
        //  set name text field
        _nameTextField.frame.size.width = rect.width * 0.6;
        _nameTextField.frame.size.height = _nameLabel.frame.height;
        _nameTextField.frame.origin.x = _nameLabel.frame.origin.x
        _nameTextField.frame.origin.y = rect.height * 0.2;
        _nameTextField.backgroundColor = UIColor.whiteColor();
        _nameTextField.textColor = UIColor.blackColor();
        _nameTextField.borderStyle = UITextBorderStyle.RoundedRect;
        
        //  set bar label
        _barsLabel.frame.size.width = _nameLabel.frame.width;
        _barsLabel.frame.size.height = _nameLabel.frame.height;
        _barsLabel.frame.origin.x = _nameLabel.frame.origin.x;
        _barsLabel.frame.origin.y = rect.height * 0.3;
        _barsLabel.textColor = UIColor.whiteColor();
        _barsLabel.text = "Number Of Bars, Must Be 1, 2, 4, Or 8:";
        
        //  set bar text box
        _barsTextField.frame.size.width = _nameTextField.frame.width * 0.3;
        _barsTextField.frame.size.height = _nameLabel.frame.height;
        _barsTextField.frame.origin.x = _nameLabel.frame.origin.x;
        _barsTextField.frame.origin.y = rect.height * 0.4;
        _barsTextField.backgroundColor = UIColor.whiteColor();
        _barsTextField.textColor = UIColor.blackColor();
        _barsTextField.borderStyle = UITextBorderStyle.RoundedRect;
        
        // TODO: aparently we should not do this..
        addSubview(_nameLabel);
        addSubview(_nameTextField);
        addSubview(_barsLabel);
        addSubview(_barsTextField);
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        // if user did not enter valid info...
        if(_nameTextField.text == "" || (_barsTextField.text != "1" && _barsTextField.text != "2" && _barsTextField.text != "4" && _barsTextField.text != "8"))  // SUSPECT
        {
            return false
        }
        // else if the user entered valid info to start game
        else
        {
            _masterDocumentDirectory.stringByAppendingPathComponent(_nameTextField.text);
            
            // the user is not allowed to enter a name game of "paths"..........
            if(_nameTextField.text == "paths")
            {
                _nameTextField.text = "That Name Is Reserved!!!!"
                return false;
            }
            // check to see if the chosen project name exists
            else if(_filePathsArray.containsObject(_masterDocumentDirectory.stringByAppendingPathComponent(_nameTextField.text + ".plist")))
            {
                // send signal to present the alert view controller
                sendActionsForControlEvents(UIControlEvents.ValueChanged);
                return false;
            }
            else
            {
                _projectName = _nameTextField.text;
                _numberOfBars = _barsTextField.text;
                sendActionsForControlEvents(UIControlEvents.EditingChanged);
                return true;
            }
        }
    }
}
