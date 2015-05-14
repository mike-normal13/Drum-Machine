//
//  LoadViewController.swift
//  FInalProject
//
//  Created by Budge on 5/1/15.
//  Copyright (c) 2015 Budge. All rights reserved.
//

import UIKit

// responsible for letting the user choose a beat config to load
//  instance of this class is owned by the LoadStartViewController
class LoadViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    // names of all available projects
    private var _projectLabels: [String] = [];
    // the currently selected row
    private var _selectedIndexPath: NSIndexPath! = nil;
    // flag indicating whether or not the current project is blank
    private var _projectIsBlank: Bool = true;
    
    // alertController Members
    private var _loadViewAlert: UIAlertController! = nil;
    private var _loadViewYesAlertAction: UIAlertAction! = nil;
    private var _loadViewNoAlertAction: UIAlertAction! = nil;
    
    private var _masterDocumentDirectory: String = "";
    private var _fileManager: NSFileManager! = nil;
    
    //  flag indicating that a project was loaded
    private var _projectWasLoaded: Bool = false
    
    // accessors
    var soundNameTable: UITableView { return view as! UITableView }
    var selectedIndexPath: NSIndexPath { return _selectedIndexPath }
    var projectLabels: [String]
        {
        get { return _projectLabels }
        set { _projectLabels = newValue }
    }
    var masterDocumentDirectory: String
    {
        get { return _masterDocumentDirectory }
        set { _masterDocumentDirectory = newValue }
    }
    var projectIsBlank: Bool
    {
        get { return _projectIsBlank }
        set { _projectIsBlank = newValue }
    }
    var projectWasLoaded: Bool
    {
        get { return _projectWasLoaded }
        set { _projectWasLoaded = newValue }
    }
    
    override func loadView()
    {
        view = UITableView();
        
        _fileManager = NSFileManager();
        
        _loadViewAlert = UIAlertController(title: "Leave Current Project", message: "Are You Sure You Want To Leave The Current Project?", preferredStyle: UIAlertControllerStyle.Alert);
        
        _loadViewYesAlertAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: {
            action in switch action.style
            {
            case .Default:
                self.leaveCurrentProject();
            default:
                println("default default")
            }
        })
        
        _loadViewNoAlertAction = UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler: {
            action in switch action.style
            {
            case .Default:
                self.stayInCurrentProject();
            default:
                println("default default")
            }
        })
        
        _loadViewAlert.addAction(_loadViewYesAlertAction);
        _loadViewAlert.addAction(_loadViewNoAlertAction);
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad();
        soundNameTable.dataSource = self;
        soundNameTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell");
        soundNameTable.delegate = self;
        
        assembleProjectLabels();
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell") as! UITableViewCell;
        
        // display the options available to the user
        cell.textLabel?.text = _projectLabels[indexPath.row] as String;
        
        return cell;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return _projectLabels.count;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        _selectedIndexPath = indexPath
        
        // if the project is not blank allert the user that they are about to leave the current project
        if(_projectIsBlank == false)
        {
            navigationController?.presentViewController(_loadViewAlert, animated: true, completion: nil);
        }
        // else pop to the root view controller
        else
        {
            _projectWasLoaded = true;
            // pop to root view controller
            navigationController?.popToRootViewControllerAnimated(false);
        }
    }
    
    // get names of all loadable files
    private func assembleProjectLabels()
    {
        let fileArray: [AnyObject]? = _fileManager.contentsOfDirectoryAtPath(_masterDocumentDirectory, error: nil);
        
        //  if there are files to load
        if(fileArray != nil)
        {
            // fill the projectLabels array with the appropriate files
            for(var pos: Int = 0; pos < fileArray!.count; pos++)
            {
                if(((fileArray![pos] as! String).hasSuffix(".plist") == true) && ((fileArray![pos] as! String) != "paths.plist"))
                {
                    let currentParsedFileName = (fileArray![pos] as! String).componentsSeparatedByString(".")
                    // put the name of the file in the list, and trim the .plist
                    _projectLabels.append(currentParsedFileName[0]);
                }
            }
            // if no proper plists could be found
            if(_projectLabels.count == 0)
            {
                _projectLabels.append("There Are No Files To Load")
                return;
            }
        }
        // else there are no files to load
        else
        {
            _projectLabels.append("There Are No Files To Load")
            return;
        }
    }
    
    // handles the user deciding to leave the current project for the chosen project to be loaded
    private func leaveCurrentProject()
    {
        _projectWasLoaded = true;
        navigationController?.popToRootViewControllerAnimated(false);
    }
    
    //  handles the user not leaving the current project
    private func stayInCurrentProject()
    {
        navigationController?.popViewControllerAnimated(true);
    }
}
