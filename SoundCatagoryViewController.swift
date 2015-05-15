//
//  SoundCatagoryViewController.swift
//  FInalProject
//
//  Created by Budge on 5/1/15.
//  Copyright (c) 2015 Budge. All rights reserved.
//

import UIKit
import AVFoundation

//  lets the user preview and choose among sounds from a chosen catagory
//  the number of sound catagories 
//      will be the number of instances of this class owned by the SwapSoundViewController (12)
class SoundCatagoryViewController:  UIViewController, UITableViewDataSource, UITableViewDelegate
{
    // names of all available sounds
    private var _soundLabels: [String] = [];
    // URLs of all sound associated with this view controller
    private var _URLArray: [NSURL] = [];
    // the sound index selected by the user
    private var _chosenSound: NSURL! = nil;
    // corresposnds to the index this view controller is in the SwapSoundViewController's
    //      array of SoundCatagoryViewControllers
    private var _controllerIndex: Int = -1;
    // player for sound previewing
    private var _previewPlayer: AVAudioPlayer! = nil;
    // flag that indicates if a sound was chosen
    private var _soundWasChosen: Bool = false;
    // row the user pressed the "choose" button on
    private var _chosenRow: Int = -1;
    
    // accessors
    var soundNameTable: UITableView { return view as! UITableView }
    //var selectedIndexPath: NSIndexPath { return _selectedIndexPath }
    var soundLabels: [String]
    {
        get { return _soundLabels }
        set { _soundLabels = newValue }
    }
    var controllerIndex: Int
    {
        get { return _controllerIndex }
        set { _controllerIndex = newValue }
    }
    var URLArray: [NSURL]
    {
        get { return _URLArray }
        set { _URLArray = newValue }
    }
    var chosenSound: NSURL { return _chosenSound }
    var soundWasChosen: Bool { return _soundWasChosen }
    var chosenRow: Int { return _chosenRow }
    
    override func loadView()
    {
        view = UITableView();    
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad();
        soundNameTable.dataSource = self;
        soundNameTable.registerClass(SoundCell.self, forCellReuseIdentifier: "Cell");
        soundNameTable.delegate = self;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell: SoundCell = tableView.dequeueReusableCellWithIdentifier("Cell") as! SoundCell;
        
        // add identifier for target functions
        cell.playButton.tag = indexPath.item;
        cell.selectButton.tag = indexPath.item;
        
        cell.playButton.addTarget(self, action: "previewSound:", forControlEvents: UIControlEvents.TouchDown);
        cell.selectButton.addTarget(self, action: "selectSound:", forControlEvents: UIControlEvents.TouchUpInside);
        
        // display the options available to the user
        cell.textLabel?.text = _soundLabels[indexPath.row] as String;
        
        return cell;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return _soundLabels.count;
    }
    
    // plays the sound corresponding to the pressed button.
    func previewSound(button: UIButton)
    {
        // get the selected sound
        _previewPlayer = AVAudioPlayer(contentsOfURL: _URLArray[button.tag], error: nil);
        // play the selected sound
        _previewPlayer.prepareToPlay();
        _previewPlayer.play();
    }
    
    // sets the selected sound and pops back to the SlotConfigViewController
    func selectSound(button: UIButton)
    {
        // set member so playView can access it
        _chosenSound = _URLArray[button.tag]
        
        // indicate that A sound was chosen
        _soundWasChosen = true;
        
        // set _chosenRow
        _chosenRow = button.tag
        
        // pop sounds
        navigationController?.popViewControllerAnimated(true);
        // pop catagories
        navigationController?.popViewControllerAnimated(false);
        navigationController?.setNavigationBarHidden(true, animated: false);
    }
}
