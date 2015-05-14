//
//  LoadStartViewController.swift
//  FInalProject
//
//  Created by Budge on 5/1/15.
//  Copyright (c) 2015 Budge. All rights reserved.
//

import UIKit
import AVFoundation

// this class is directly below the app delegate
//  presents the user with options to begin using the app
//  This class is also responsible for setting every target for every control in the app
//  This class is also responsible for saving and loading games
class LoadStartViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate
{
    private var _selectedIndexPath: NSIndexPath? = nil
    // the options the user is presented with
    private let _optionLabels: [String] = ["Make A New Beat","Load A Beat"];
    
    // view controller members
    private var _newViewController: NewViewController! = nil
    private var _playViewController: PlayViewController! = nil;
    
    // indicates whether the _playViewController appeared because a user chose to start a new project
    private var _startFlag: Bool = false;
    
    // indicates whether all the targets of the PlayViewController have already been set
    //      in order to set all the targets only once.
    private var _playViewControllerTargetsHaveAlreadyBeenSet: Bool = false;
    
    // keeps track of whether each of the 5 SlotConfigViewController's targets have already been set
    private var _slotConfigViewControllerTargetsHaveAlreadyBeenSetArray: [Bool] = [false, false, false, false, false];
    
    // the directory we will save midi files to
    //  self -> _playViewController -> mixer
    private var _masterDocumentDirectory: String = "";
    
    //  name of the game entered by the user in the new or rename view.
    //      passed down the same as masterDocumentDirectory
    private var _projectName: String = "";
    
    // model keeps track of all the saved files on disk
    private var _loadStartModel: LoadStartModel! = nil;
    
    //  TODO:   we might not use this at all!!!!
    // NSFileManager for overwriting
    private var _fileManager: NSFileManager! = nil;
    
    //  load view controller member lets the user choose a project to load
    private var _loadViewController: LoadViewController! = nil;
    
    // view accessor
    var loadStartTable: UITableView { return view as! UITableView }
    
    
    override func loadView()
    {
        view = UITableView();
        navigationController?.delegate = self;
        
        // set the document directory
        //_masterDocumentDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)?[0] as! String
        _masterDocumentDirectory =  "Users/Budge/Desktop/Finalprojectfiles";
        
        _fileManager = NSFileManager();
        
        _loadStartModel = LoadStartModel();
        // fill the _loadStartModel's file path array with all the file paths on disk
        getSavedFilePaths();
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad();
        loadStartTable.dataSource = self;
        loadStartTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Starting Option Cell");
        loadStartTable.delegate = self;
        title = "Let's Get Started";
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("Starting Option Cell") as! UITableViewCell;
        
        // display the options available to the user
        cell.textLabel?.text = _optionLabels[indexPath.row] as String;
        
        return cell;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // this table view always presents the user with two options
        return 2;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        _selectedIndexPath = indexPath;
                
        // if user chooses to make new beat
        if(_selectedIndexPath?.item == 0)
        {
            // intialize the NewViewController
            _newViewController = NewViewController();
            //  push the NewViewController
            navigationController?.pushViewController(_newViewController, animated: true);
            
            // add a target to NewView indicating that the user entered a "valid" name
            _newViewController.newView.addTarget(self, action: "pushPlayViewController", forControlEvents: UIControlEvents.EditingChanged);
            // add target to NewView handling if the user enters a project name that exists on disk
            _newViewController.newView.addTarget(self, action: "presentNewViewAlertController", forControlEvents: UIControlEvents.ValueChanged);
            //  add target handling if the user chooses to overwrite and existing file
            _newViewController.newView.addTarget(self, action: "overwriteProject", forControlEvents: UIControlEvents.TouchDown);
            //  add target handling if the user chooses NOT to overwrite and existing file
            _newViewController.newView.addTarget(self, action: "cancelOverwrite", forControlEvents: UIControlEvents.TouchCancel);
            
            // pass the master document directory down 
            _newViewController.newView.masterDocumentDirectory = _masterDocumentDirectory;
            
            // indicates the view controller will be shown because the user chose to make a new beat
            _startFlag = true;
        }
        // else if user chooses to load a beat
        else
        {            
            // init the loadViewController
            _loadViewController = LoadViewController();
            // push
            navigationController?.pushViewController(_loadViewController, animated: true);
            
            // pass down the path to document directory
            _loadViewController.masterDocumentDirectory = _masterDocumentDirectory;
        }
    }
    
    func navigationController(navigationController: UINavigationController, didShowViewController viewController: UIViewController, animated: Bool)
    {
        // if the _playViewController appeared
        if(viewController is PlayViewController)
        {
            showedPlayViewController();
        }
            
        //else if a SlotConfigViewController shows...
        else if(viewController is SlotConfigViewController)
        {
            //  set targets
            if((viewController as! SlotConfigViewController).targetsHaveBeenSet == false)
            {
                handleShowingSlotConfigViewController((viewController as! SlotConfigViewController).configNumber);
                
                // set flag indicator to true
                (viewController as! SlotConfigViewController).targetsHaveBeenSet = true;
            }
            
            showedSlotConfigViewController();
        }
        // else if the NewViewController appeard
        else if(viewController is NewViewController)
        {
            // if the file paths array is not nill
            if(_loadStartModel.projectFilePathsArray != nil)
            {
                // pass the file paths array down
                _newViewController.newView.filePathsArray = _loadStartModel.projectFilePathsArray!;
            }
        }
        // else if the LoadStartViewController shows....
        else if(viewController is LoadStartViewController)
        {
            //  if the LoadStartViewController shows because the user chose to load a project
            if(_loadViewController != nil)
            {
                if(_loadViewController.projectWasLoaded == true)
                {
                    // set the start flag back to flase 
                    _startFlag = false;
                    
                    // if the current project is not blank
                    if(_loadViewController.projectIsBlank == false)
                    {
                        // save the current project
                        saveButtonPressed();
                    }

                    // re/initialize the PlayViewController
                    _playViewController = PlayViewController();
                    // and the play view
                    _playViewController.playView = PlayView();
                    
                    //  push the playViewController
                    navigationController.pushViewController(_playViewController, animated: true);
                    navigationController.setNavigationBarHidden(true, animated: false);
                }
            }
        }
        else    //  ...........................
        {}
    }
    
    private func showedPlayViewController()
    {
        // if the PlayViewController is being shown because the user chose to start a new session
        if(_startFlag == true)
        {
            // set _startFlag back to false
            _startFlag = false;
            // add the data entered from the NewView into the PlayModel
            _playViewController.playModel.projectName = _newViewController.newView.projectName;
            _playViewController.playModel.nBars =   _newViewController.newView.numberOfBars.toInt()!;
            
            // set the Clock's _bars member
            _playViewController.clock.bars = _playViewController.playModel.nBars;
            
            // set the label text for number of bars entered by the user
            if(_playViewController.playModel.nBars.description != "1")
            {
                _playViewController.playView.topContainerView.timePositionContainerView.measuresViewText = _playViewController.playModel.nBars.description + " bars";
            }
            else
            {
                _playViewController.playView.topContainerView.timePositionContainerView.measuresViewText = _playViewController.playModel.nBars.description + " bar";
            }
            
            // set the label text for the bars and beats in the play view based upon the Clock
            _playViewController.playView.topContainerView.timePositionContainerView.timePositionLabelContainerView.barLabelText = _playViewController.clock.barCounter.description;
            _playViewController.playView.topContainerView.timePositionContainerView.timePositionLabelContainerView.beatLabelText = _playViewController.clock.beatCounter.description;
            
            // place the default initial value for BPMs (120) in the play view
            _playViewController.playView.topContainerView.timeContainerView.tempoView.tempoLabelText = _playViewController.playModel.BPM.description + "BPM";
        }
            
            // else if the PlayViewController is being show because the player chose to load a session
        else if(_startFlag == false && _loadViewController != nil)
        {
            if(_loadViewController.projectWasLoaded == true)
            {
                _loadViewController.projectWasLoaded = false;
                // load the selected project
                load();
                
                // set labels in the top view
                _playViewController.playView.topContainerView.timePositionContainerView.measuresViewText = _playViewController.playModel.nBars.description;
                _playViewController.playView.topContainerView.timeContainerView.tempoView.tempoLabel.text =                     _playViewController.playModel.BPM.description
                _playViewController.playView.topContainerView.timePositionContainerView.timePositionLabelContainerView.barLabelText = _playViewController.clock.barCounter.description;
                _playViewController.playView.topContainerView.timePositionContainerView.timePositionLabelContainerView.beatLabelText = _playViewController.clock.beatCounter.description;
            }
        }
        else
        {
            
        }
        
        // if all the targets have not been set yet,
        //      set them.
        if(_playViewControllerTargetsHaveAlreadyBeenSet == false)
        {
            // add all targets for all controls in the top view
            addTopViewTargets();
            // add the targets for the five sound slots
            addSoundSlotTargets();
            // add all targets for all controls in the bottom view
            addBottomViewTargets()
            
            // set the targets-have-already-been-set-flag
            _playViewControllerTargetsHaveAlreadyBeenSet = true;
        }
    }
    
    private func showedSlotConfigViewController()
    {
        // set the sound chosen by the user to the highlighted sound slot's sound member,
        //      and return the value in order to update the model
        var slotSoundForModel: NSURL? = _playViewController.slotConfigViewControllerArray[_playViewController.highlightedSlotIndex].setSlotSound();
        
        // for abbreviation's sake....
        let pVCHSI = _playViewController.highlightedSlotIndex;
        
        if(slotSoundForModel != nil)
        {
            // if the sound slot in the model is nil...
            if(_playViewController.playModel.soundSlotConfigModelArray[_playViewController.highlightedSlotIndex] == nil)
            {
                // make a new one
                var newSoundSlotModel: SoundSlotConfigModel! = SoundSlotConfigModel()
                // set it
                _playViewController.playModel.setSoundSlotConfigModelArrayPosition(_playViewController.highlightedSlotIndex, model: newSoundSlotModel);
            }
            
            let sIPI = _playViewController.slotConfigViewControllerArray[pVCHSI].swapSoundViewController.selectedIndexPath.item
            let cR = _playViewController.slotConfigViewControllerArray[pVCHSI].swapSoundViewController.soundCatagoryViewControllerArray[sIPI].chosenRow
            
            // update the model's URL and name member
            //      URL
            _playViewController.playModel.soundSlotConfigModelArray[pVCHSI].loadedSound = slotSoundForModel!;
            //      name
            _playViewController.playModel.soundSlotConfigModelArray[pVCHSI].name = _playViewController.slotConfigViewControllerArray[pVCHSI].swapSoundViewController.soundCatagoryViewControllerArray[sIPI].soundLabels[cR];
            
            // update the model's sound catagory member
            _playViewController.playModel.soundSlotConfigModelArray[pVCHSI].soundCatagory = sIPI;
            // update the model's sound index member
            _playViewController.playModel.soundSlotConfigModelArray[pVCHSI].soundIndex = cR;
            
            // set the sound slot tile's label in the playView
            _playViewController.playView.slotTileContainerView.slotTileViewArray[pVCHSI].fileNameLabel.text = _playViewController.playModel.soundSlotConfigModelArray[pVCHSI].name;
            
            // set the sound label in the slot config view
            _playViewController.slotConfigViewControllerArray[pVCHSI].slotConfigView.soundNameLabelView.soundName = "Preview: \(_playViewController.playModel.soundSlotConfigModelArray[pVCHSI].name)";
            
            //  update display with name of currently loaded sound
            _playViewController.slotConfigViewControllerArray[pVCHSI].slotConfigView.soundNameLabelView.setNeedsDisplay();
            
            //  now that a sound has been loaded,
            //      make it so the currently visible SlotConfigView's controls can be manipulated
            _playViewController.slotConfigViewControllerArray[pVCHSI].slotConfigView.setControlFlags();
            
            // update the mixer's sounds
            _playViewController.mixer.setSound(pVCHSI, sound: _playViewController.playModel.soundSlotConfigModelArray[pVCHSI].loadedSound);
            
            //  once setSound() is called, set the _maxPosition member in StartPositionView, and DecayView
            _playViewController.slotConfigViewControllerArray[pVCHSI].slotConfigView.startPositionView.maxPosition = _playViewController.mixer.numberOfFramesArray[pVCHSI];
            _playViewController.slotConfigViewControllerArray[pVCHSI].slotConfigView.decayContainerView.decayView.maxPosition = _playViewController.mixer.numberOfFramesArray[pVCHSI];
            
            _playViewController.slotConfigViewControllerArray[pVCHSI].slotConfigView.decayContainerView.decayView.currentDecay = _playViewController.slotConfigViewControllerArray[pVCHSI].slotConfigView.decayContainerView.decayView.maxPosition
            
            _playViewController.slotConfigViewControllerArray[pVCHSI].slotConfigView.decayContainerView.decayView.setNeedsDisplay();
            
            if(_loadViewController != nil)
            {
                // notify the LoadViewController that the current project is not blank
                _loadViewController.projectIsBlank = false;
            }
        }

            // else if the SlotConfigViewController shows without a sound loaded...
        else
        {
            //if(_playViewController.slotConfigViewControllerArray[pVCHSI].slotConfigView.soundNameLabelView.soundName == nil)
            //                {
            //                    _playViewController.slotConfigViewControllerArray[pVCHSI].slotConfigView.soundNameLabelView.soundName = "No Sound Loaded"
            //                }
        }
    }
    
    // this function is called by the didShowViewControllerDelegate method,
    //      it handles setting all targets for all controls in a slot configuration view once it is initialized
    private func handleShowingSlotConfigViewController(viewControllerIndex: Int)
    {
        //  THE METHODs THAT HANDLE ALL SIGNALS CAUGHT BY THE BELOW TARGETS ARE NOT IN THIS CLASS,
        //      they are in the SlotConfigViewControllerClass.
        
        // if the SlotConfigViewController's targets haven not already been set...
        if(_slotConfigViewControllerTargetsHaveAlreadyBeenSetArray[viewControllerIndex] == false)
        {
            // set the target for the "Back button"
            _playViewController.slotConfigViewControllerArray[viewControllerIndex].slotConfigView.backToPlayView.addTarget(_playViewController.slotConfigViewControllerArray[viewControllerIndex], action: "backbuttonWasPressed", forControlEvents: UIControlEvents.TouchUpInside);
            
            // set target for "Swap Button"
            _playViewController.slotConfigViewControllerArray[viewControllerIndex].slotConfigView.swapSoundView.addTarget(_playViewController.slotConfigViewControllerArray[viewControllerIndex], action: "swapButtonWasPressed", forControlEvents: UIControlEvents.TouchUpInside);
            
            //  set the SoundNameLabelView target for previewong the sound
            _playViewController.slotConfigViewControllerArray[viewControllerIndex].slotConfigView.soundNameLabelView.addTarget(_playViewController, action: "previewConfigSound", forControlEvents: UIControlEvents.TouchDown);
            
            // start position increment/decrement target, both minus and plus buttons are assigned to this target
            _playViewController.slotConfigViewControllerArray[viewControllerIndex].slotConfigView.startPositionView.addTarget(_playViewController, action: "soundStartPositionChanged:", forControlEvents: UIControlEvents.TouchDownRepeat);
            
            //  transpose target, both minus and plus buttons are assigned to this target
            _playViewController.slotConfigViewControllerArray[viewControllerIndex].slotConfigView.transposeContainerView.transposeView.addTarget(_playViewController, action: "soundsPitchChanged", forControlEvents: UIControlEvents.TouchDown);
            
            // stretch target for pitch minus/plus buttons
            _playViewController.slotConfigViewControllerArray[viewControllerIndex].slotConfigView.stretchView.addTarget(_playViewController, action: "stretchPitchChanged", forControlEvents: UIControlEvents.TouchDown);
            
            // stretch target for rate minus/plus buttons
            _playViewController.slotConfigViewControllerArray[viewControllerIndex].slotConfigView.stretchView.addTarget(_playViewController, action: "stretchRateChanged", forControlEvents: UIControlEvents.EditingChanged);
            
            // stretch target for overlap minus/plus buttons
            _playViewController.slotConfigViewControllerArray[viewControllerIndex].slotConfigView.stretchView.addTarget(_playViewController, action: "stretchOverlapChanged", forControlEvents: UIControlEvents.ValueChanged);
            
            // decay target for minus/plus buttons
            _playViewController.slotConfigViewControllerArray[viewControllerIndex].slotConfigView.decayContainerView.decayView.addTarget(_playViewController, action: "decayPositionChanged", forControlEvents: UIControlEvents.TouchDown);
            
            //  pan target for minus/plus buttons
            _playViewController.slotConfigViewControllerArray[viewControllerIndex].slotConfigView.panContainerView.panView.addTarget(_playViewController, action: "adjustPan", forControlEvents: UIControlEvents.TouchDown);

            //  pan random target for minus/plus buttons
            _playViewController.slotConfigViewControllerArray[viewControllerIndex].slotConfigView.panContainerView.panRandomView.addTarget(_playViewController, action: "adjustPanRandom", forControlEvents: UIControlEvents.TouchDown);
            
            // volume target for minus/plus buttons
            _playViewController.slotConfigViewControllerArray[viewControllerIndex].slotConfigView.volumeContainerView.volumeView.addTarget(_playViewController, action: "adjustVolume", forControlEvents: UIControlEvents.TouchDown);
            
            // tranpose random target for minus/plus buttons
            _playViewController.slotConfigViewControllerArray[viewControllerIndex].slotConfigView.transposeContainerView.transposeRandomView.addTarget(_playViewController, action: "adjustTranposeRandom", forControlEvents: UIControlEvents.TouchDown);
            
            // set the SlotConfigViewController's targets as being set
            _slotConfigViewControllerTargetsHaveAlreadyBeenSetArray[viewControllerIndex] = true;
        }
    }
    
    // pushes the PlayViewController once the user has entered the needed data to start a new beat making session
    func pushPlayViewController()
    {
        // pop NewViewController
        navigationController?.popViewControllerAnimated(false);
        
        // intialize and push _playViewController
        _playViewController = PlayViewController();
        //  set play view controller's document directory path
        _playViewController.masterDocumentDirectory = _masterDocumentDirectory;
        
        // set game name
        _projectName = _newViewController.newView.projectName;
        _playViewController.projectName = _projectName;
        
        navigationController?.pushViewController(_playViewController, animated: true);
        navigationController?.setNavigationBarHidden(true, animated: false);
    }
    
    //  this method handles the signal sent by th "Save" button in the play view
    //      this method saves the current state of the project
    func saveButtonPressed()
    {
        let fileName: String = "\(_playViewController.playModel.projectName).plist";
        
        let filePath: String = _masterDocumentDirectory.stringByAppendingPathComponent(fileName);
        
        // the outer most dictionary
        var outerDict: NSMutableDictionary = [:];
        
        // slot config dicts
        var slot0Dict: NSMutableDictionary;
        var slot1Dict: NSMutableDictionary = [:];
        var slot2Dict: NSMutableDictionary = [:];
        var slot3Dict: NSMutableDictionary = [:];
        var slot4Dict: NSMutableDictionary = [:];
        
        // set project name
        outerDict.setObject(_playViewController.playModel.projectName, forKey: "Project Name");
        // set the number of bars
        outerDict.setObject(_playViewController.playModel.nBars, forKey: "Number Of Bars");
        // set the BPM
        outerDict.setObject(_playViewController.playModel.BPM, forKey: "BPM");
        // set the master volume
        outerDict.setObject(_playViewController.playModel.masterVolume, forKey: "Master Volume");
        // set state of limiter
        outerDict.setObject(_playViewController.playModel.limiterArmed, forKey: "Limiter Armed");
        
        slot0Dict = saveSlotConfig(0);
        slot1Dict = saveSlotConfig(1);
        slot2Dict = saveSlotConfig(2);
        slot3Dict = saveSlotConfig(3);
        slot4Dict = saveSlotConfig(4);
        
        //  set the 5 slots to a dictionary
        outerDict.setObject(slot0Dict, forKey: "Slot 0");
        outerDict.setObject(slot1Dict, forKey: "Slot 1");
        outerDict.setObject(slot2Dict, forKey: "Slot 2");
        outerDict.setObject(slot3Dict, forKey: "Slot 3");
        outerDict.setObject(slot4Dict, forKey: "Slot 4");
                
        var saveResult = outerDict.writeToFile(filePath, atomically: false);
        
        // if the save was successful...
        if(saveResult == true)
        {
           // save the file path to the filePath array.
            _loadStartModel.projectFilePathsArray!.addObject(filePath);
            
            // save the array of file paths to disk
            var savePathsResult = _loadStartModel.projectFilePathsArray!.writeToFile(_masterDocumentDirectory.stringByAppendingPathComponent("paths.plist"), atomically: false);
            assert(savePathsResult == true)
        }
    }
    
    // set and return the configuration state of a sound slot,
    //  if the sound slot state is nil, returns an empty dictionary.
    private func saveSlotConfig(index: Int) -> NSMutableDictionary
    {
        var retDict: NSMutableDictionary = [:];
        
        // if the current slot in the model is not nil
        if(_playViewController.playModel.soundSlotConfigModelArray[index] != nil)
        {                        
            retDict.setObject(_playViewController.playModel.soundSlotConfigModelArray[index].soundCatagory, forKey: "Sound Catagory");
            retDict.setObject(_playViewController.playModel.soundSlotConfigModelArray[index].soundIndex, forKey: "Sound Index");
            //set the name of the file
            retDict.setObject(_playViewController.playModel.soundSlotConfigModelArray[index].name, forKey: "File Name");
            //  set start position
            retDict.setObject(Int(_playViewController.playModel.soundSlotConfigModelArray[index].startPosition), forKey: "Start Position");
            //  set transpose
            retDict.setObject(_playViewController.playModel.soundSlotConfigModelArray[index].transposeRate, forKey: "Transpose");
            //  set transposeRandom
            retDict.setObject(Int(_playViewController.playModel.soundSlotConfigModelArray[index].transposeRandom), forKey: "Transpose Random");
            //  set stretch pitch
            retDict.setObject(_playViewController.playModel.soundSlotConfigModelArray[index].stretchPitch, forKey: "Stretch Pitch");
            //  set stretch rate
            retDict.setObject(_playViewController.playModel.soundSlotConfigModelArray[index].stretchRate, forKey: "Stretch Rate");
            //  set stretch overlap
            retDict.setObject(_playViewController.playModel.soundSlotConfigModelArray[index].stretchOverlap, forKey: "Stretch Overlap");
            //  set decay length
            retDict.setObject(Int(_playViewController.playModel.soundSlotConfigModelArray[index].decayLength), forKey: "Decay Length");
            //  set pan position
            retDict.setObject(_playViewController.playModel.soundSlotConfigModelArray[index].panPosition, forKey: "Pan Position");
            //  set pan random
            retDict.setObject(_playViewController.playModel.soundSlotConfigModelArray[index].panRandom, forKey: "Pan Random");
            //  set volume
            retDict.setObject(_playViewController.playModel.soundSlotConfigModelArray[index].volume, forKey: "Volume");
            //  set volume random
            retDict.setObject(_playViewController.playModel.soundSlotConfigModelArray[index].volumeRandom, forKey: "Volume Random");
            //  set mute
            retDict.setObject(_playViewController.playModel.soundSlotConfigModelArray[index].muted, forKey: "Muted");
        }
        
        return retDict;
    }

    func loadButtonPressed()
    {
        // save the current sate of the project
        saveButtonPressed();
        
        //  if the load view controller is nil...
        if(_loadViewController == nil)
        {
            _loadViewController = LoadViewController();
        }
        //push the load view controller
        navigationController?.pushViewController(_loadViewController, animated: true);
        
        // pass down the path to document directory
        _loadViewController.masterDocumentDirectory = _masterDocumentDirectory;
    }
    
    // handles the user pressing the "new" button to start a new project
    func newButtonPressed()
    {
        // alert the user
        navigationController?.presentViewController(_playViewController.playView.bottomContainerView.newButtonView.newViewAlert, animated: true, completion: nil);
    }
    
    func renameButtonPressed()
    {
        
    }
    
    //  gets an array made up of all the file paths to all the saved projects on disk.
    private func getSavedFilePaths()
    {
        var x = _masterDocumentDirectory
        
        _loadStartModel?.projectFilePathsArray = NSMutableArray(contentsOfFile: _masterDocumentDirectory.stringByAppendingPathComponent("paths.plist"));
        
        // if there is no file named "paths.plist"....
        if(_loadStartModel?.projectFilePathsArray == nil)
        {
            // make a new NSMutableArray
            let newPathsArray: NSMutableArray = NSMutableArray();
            // then write it to disk
            newPathsArray.writeToFile(_masterDocumentDirectory.stringByAppendingPathComponent("paths.plist"), atomically: false);
        }
    }
    
    // presents the alert view controller in the newview if the user entered an existing project name
    //  target set for this method in "didSelectRowAtIndexPath" of this class
    func presentNewViewAlertController()
    {
        navigationController?.presentViewController(_newViewController.newView.newViewAlert, animated: true, completion: nil);
    }
    
    // handels to user choosing to overwrite a file via the user choosing a project name that exists on disk
    //  target set for this method in "didSelectRowAtIndexPath" of this class
    func overwriteProject()
    {
        // set members in new view just as if the user did not choose and already taken name
        _newViewController.newView.projectName = _newViewController.newView.nameTextField.text;
        _newViewController.newView.numberOfBars = _newViewController.newView.barsTextField.text;
        
        pushPlayViewController();
    }
    
    func cancelOverwrite()
    {
        // clear the name text field
        _newViewController.newView.nameTextField.text = "";
    }
    
    //  loads a game
    private func load()
    {
        // get the dictionary for the project to load
        let loadDict: NSMutableDictionary = NSMutableDictionary(contentsOfFile: _masterDocumentDirectory.stringByAppendingPathComponent(_loadViewController.projectLabels[_loadViewController.selectedIndexPath.item] + ".plist"))!;
        
        // set project name
        _playViewController.playModel.projectName = loadDict.objectForKey("Project Name") as! String;
        let bars = loadDict.objectForKey("Number Of Bars") as! Int;
        // set number of bars
        _playViewController.playModel.nBars = bars;
        

        // if the any of the three major view containers are nil.....
        if(_playViewController.playView.topContainerView == nil || _playViewController.playView.slotTileContainerView == nil || _playViewController.playView.bottomContainerView == nil)
        {
            // intialize the play view
            _playViewController.playView.layoutIfNeeded()
        }
        
        // set BPM
        _playViewController.playModel.BPM = loadDict.objectForKey("BPM") as! Int;
        
        //  set limiter armed
        _playViewController.playModel.limiterArmed = loadDict.objectForKey("Limiter Armed") as! Bool;
        
        //  set master volume in model
        _playViewController.playModel.masterVolume = loadDict.objectForKey("Master Volume") as! Float;
        
        // reintialize the mixer
        _playViewController.mixer = Mixer();
        
        // set master volume in mixer
        _playViewController.mixer.mixer.outputVolume = _playViewController.playModel.masterVolume;
        
        // initialize and load each of the five sound slots
        loadSlot(0, dict: loadDict);
        loadSlot(1, dict: loadDict);
        loadSlot(2, dict: loadDict);
        loadSlot(3, dict: loadDict);
        loadSlot(4, dict: loadDict);
    }
    
    // load a sound slot
    private func loadSlot(index: Int, dict: NSMutableDictionary)
    {
        var modelViewSlotDict: NSMutableDictionary!;
        
        modelViewSlotDict = dict.objectForKey("Slot \(index)") as! NSMutableDictionary;
        
        //  handle the model and the view.
        // if the slot dict is empty
        if(modelViewSlotDict.count != 0)
        {
            // initailize sound slot models on demand
            if(_playViewController.playModel.soundSlotConfigModelArray[index] == nil)
            {
                _playViewController.playModel.soundSlotConfigModelArray[index] = SoundSlotConfigModel();
            }
            
            // first part of index for a loaded sound
            _playViewController.playModel.soundSlotConfigModelArray[index].soundCatagory = modelViewSlotDict.objectForKey("Sound Catagory") as! Int;
            // second part of index for a loaded sound
            _playViewController.playModel.soundSlotConfigModelArray[index].soundIndex = modelViewSlotDict.objectForKey("Sound Index") as! Int;
            
            let fileName = (modelViewSlotDict.objectForKey("File Name") as? String)!;
            // handle file name for model and config view
            _playViewController.playModel.soundSlotConfigModelArray[index].name = fileName;
            _playViewController.playView.slotTileContainerView.slotTileViewArray[index].fileNameLabel.text = fileName;
            
            // initialize slotConfigViewController if nil
            if(_playViewController.slotConfigViewControllerArray[index] == nil)
            {
                _playViewController.slotConfigViewControllerArray[index] = SlotConfigViewController()
            }
            
            // if the given slot's config view is nil
            if(_playViewController.slotConfigViewControllerArray[index].slotConfigView == nil)
            {
                // intialize it
                initializeGivenSlotConfigView(index);
            }
            
            // set the config view as adjustable
            _playViewController.slotConfigViewControllerArray[index].slotConfigView.setControlFlags();
            
            _playViewController.playModel.soundSlotConfigModelArray[index].startPosition = Int64(modelViewSlotDict.objectForKey("Start Position") as! Int);
            _playViewController.slotConfigViewControllerArray[index].slotConfigView.startPositionView.startPosition = Int64(modelViewSlotDict.objectForKey("Start Position") as! Int);

            //  Transpose
            _playViewController.playModel.soundSlotConfigModelArray[index].transposeRate = modelViewSlotDict.objectForKey("Transpose") as! Int;
            _playViewController.slotConfigViewControllerArray[index].slotConfigView.transposeContainerView.transposeView.currentTone = modelViewSlotDict.objectForKey("Transpose") as! Int;
            
            _playViewController.playModel.soundSlotConfigModelArray[index].transposeRandom = UInt32(modelViewSlotDict.objectForKey("Transpose Random") as! Int);
            _playViewController.slotConfigViewControllerArray[index].slotConfigView.transposeContainerView.transposeRandomView.currentRandom = UInt32(modelViewSlotDict.objectForKey("Transpose Random") as! Int);
            
            //  decay
            _playViewController.playModel.soundSlotConfigModelArray[index].decayLength = Int64(modelViewSlotDict.objectForKey("Decay Length") as! Int);
            _playViewController.slotConfigViewControllerArray[index].slotConfigView.decayContainerView.decayView.currentDecay = Int64(modelViewSlotDict.objectForKey("Decay Length") as! Int);
            
            //  pan
            _playViewController.playModel.soundSlotConfigModelArray[index].panPosition = modelViewSlotDict.objectForKey("Pan Position") as! Int;
            _playViewController.slotConfigViewControllerArray[index].slotConfigView.panContainerView.panView.currentPanPosition = modelViewSlotDict.objectForKey("Pan Position") as! Int;
            _playViewController.playModel.soundSlotConfigModelArray[index].panRandom = modelViewSlotDict.objectForKey("Pan Random") as! Int;
            _playViewController.slotConfigViewControllerArray[index].slotConfigView.panContainerView.panRandomView.currentPanRandomPosition = modelViewSlotDict.objectForKey("Pan Random") as! Int;
            
            _playViewController.playModel.soundSlotConfigModelArray[index].volume = modelViewSlotDict.objectForKey("Volume") as! Float;
            _playViewController.slotConfigViewControllerArray[index].slotConfigView.volumeContainerView.volumeView.currentGain = modelViewSlotDict.objectForKey("Volume") as! Float;
            
            _playViewController.playModel.soundSlotConfigModelArray[index].volumeRandom = modelViewSlotDict.objectForKey("Volume Random") as! Float;
            
            _playViewController.playModel.soundSlotConfigModelArray[index].stretchPitch = modelViewSlotDict.objectForKey("Stretch Pitch") as! Int;
            _playViewController.slotConfigViewControllerArray[index].slotConfigView.stretchView.currentPitch = modelViewSlotDict.objectForKey("Stretch Pitch") as! Int;
            
            _playViewController.playModel.soundSlotConfigModelArray[index].stretchRate = modelViewSlotDict.objectForKey("Stretch Rate") as! Float;
            _playViewController.slotConfigViewControllerArray[index].slotConfigView.stretchView.currentRate = modelViewSlotDict.objectForKey("Stretch Rate") as! Float;
            
            _playViewController.playModel.soundSlotConfigModelArray[index].stretchOverlap = modelViewSlotDict.objectForKey("Stretch Overlap") as! Float;
            _playViewController.slotConfigViewControllerArray[index].slotConfigView.stretchView.currentOverlap = modelViewSlotDict.objectForKey("Stretch Overlap") as! Float;
            
            _playViewController.playModel.soundSlotConfigModelArray[index].muted = modelViewSlotDict.objectForKey("Muted") as! Bool;
            
            // set VC's id
            _playViewController.slotConfigViewControllerArray[index].configNumber = index;
            
        }
            // else initialize the VC, and set it's id
        else
        {
            _playViewController.slotConfigViewControllerArray[index] = SlotConfigViewController()
            initializeGivenSlotConfigView(index);
            _playViewController.slotConfigViewControllerArray[index].configNumber = index;

            return;
        }
        
        //  assign this slot's sound to the corresponding audio file in the mixer
        // get the url for this slot's sound
        let url: NSURL =  getURLForMixerSlot(index, catagory: _playViewController.playModel.soundSlotConfigModelArray[index].soundCatagory, row: _playViewController.playModel.soundSlotConfigModelArray[index].soundIndex);
        
        // assign the url to the audiofile in the mixer
        _playViewController.mixer.setSound(index, sound: url);
        
        // handle the mixer
        modelViewSlotDict = dict.objectForKey("Slot \(index)") as! NSMutableDictionary;
        if(modelViewSlotDict != nil)
        {
            //         _startPosition
            _playViewController.mixer.audioFileArray[index].framePosition = Int64(modelViewSlotDict.objectForKey("Start Position") as! Int);
            //        _transposeRate
            _playViewController.mixer.transposeArray[index] = Int64(modelViewSlotDict.objectForKey("Transpose") as! Int);
            //        _transposeRandom
            _playViewController.mixer.tRandomArray[index] = UInt32(modelViewSlotDict.objectForKey("Transpose Random") as! Int);
            //        _decayLength
            _playViewController.mixer.decayArray[index] = Int64(modelViewSlotDict.objectForKey("Decay Length") as! Int);
            //         _panPosition
            _playViewController.mixer.panArray[index] = Int64(modelViewSlotDict.objectForKey("Pan Position") as! Int);
            //        _panRandom
            _playViewController.mixer.pRandomArray[index] = UInt32(modelViewSlotDict.objectForKey("Pan Random") as! UInt);
            //         _volume
            _playViewController.mixer.playerNodeArray[index].volume = modelViewSlotDict.objectForKey("Volume") as! Float;
            //         _stretchPitch
            _playViewController.mixer.stretchArray[index].pitch = modelViewSlotDict.objectForKey("Stretch Pitch") as! Float;
            //         _stretchRate
            _playViewController.mixer.stretchArray[index].rate = modelViewSlotDict.objectForKey("Stretch Rate") as! Float;
            //         _stretchOverlap
            _playViewController.mixer.stretchArray[index].overlap = modelViewSlotDict.objectForKey("Stretch Overlap") as! Float;
        }
    }
    
    //  handles signal sent from MasterVolumeView,
    //      adjusts the overall volume of the project.
    func masterVolumeChanged()
    {
        // adjust model
        _playViewController.playModel.masterVolume = _playViewController.playView.bottomContainerView.masterVolumeView.currentMasterVolume;
        // adjust mixer
        _playViewController.mixer.mixer.outputVolume = _playViewController.playModel.masterVolume
    }
    
    private func initializeGivenSlotConfigView(index: Int)
    {
        //  top level
        _playViewController.slotConfigViewControllerArray[index].slotConfigView = SlotConfigView();
        
        //  mid level
        _playViewController.slotConfigViewControllerArray[index].slotConfigView.soundNameLabelView = SoundNameLabelView();
        _playViewController.slotConfigViewControllerArray[index].slotConfigView.backToPlayView = BackToPlayView();
        _playViewController.slotConfigViewControllerArray[index].slotConfigView.swapSoundView = SwapSoundView();
        _playViewController.slotConfigViewControllerArray[index].slotConfigView.soundNameLabelView = SoundNameLabelView();
        _playViewController.slotConfigViewControllerArray[index].slotConfigView.startPositionView = StartPositionView();
        _playViewController.slotConfigViewControllerArray[index].slotConfigView.transposeContainerView = TransposeContainerView()
        _playViewController.slotConfigViewControllerArray[index].slotConfigView.stretchView = StretchView();
        _playViewController.slotConfigViewControllerArray[index].slotConfigView.decayContainerView = DecayContainerView();
        _playViewController.slotConfigViewControllerArray[index].slotConfigView.panContainerView = PanContainerView();
        _playViewController.slotConfigViewControllerArray[index].slotConfigView.volumeContainerView = VolumeContainerView();
        
//        // inner most guys
        _playViewController.slotConfigViewControllerArray[index].slotConfigView.transposeContainerView.transposeView = TransposeView();
        _playViewController.slotConfigViewControllerArray[index].slotConfigView.transposeContainerView.transposeRandomView = TransposeRandomView();
        _playViewController.slotConfigViewControllerArray[index].slotConfigView.decayContainerView.decayView = DecayView();
        _playViewController.slotConfigViewControllerArray[index].slotConfigView.panContainerView.panView = PanView();
        _playViewController.slotConfigViewControllerArray[index].slotConfigView.panContainerView.panRandomView = PanRandomView();
        _playViewController.slotConfigViewControllerArray[index].slotConfigView.volumeContainerView.volumeView = VolumeView();
   }
    
    // gets a URL for a sound file based upon the catagory and row indexes,
    //  stored in the SoundSlotConfigModel.
    private func getURLForMixerSlot(slot: Int, catagory: Int, row: Int) -> NSURL
    {
        var retURL: NSURL;
        
        // if the swapSoundViewControler for the given slot is not initialized...
        if(_playViewController.slotConfigViewControllerArray[slot].swapSoundViewController == nil)
        {
            //  wake it up
            _playViewController.slotConfigViewControllerArray[slot].swapSoundViewController = SwapSoundViewController();
        }
        
        //  now if the the SounCatagoryViewController for the swapSoundViewController we just initialized,
        //      is not initialized....
        if(_playViewController.slotConfigViewControllerArray[slot].swapSoundViewController.soundCatagoryViewControllerArray[catagory] == nil)
        {
            _playViewController.slotConfigViewControllerArray[slot].swapSoundViewController.soundCatagoryViewControllerArray[catagory] = SoundCatagoryViewController()
        }
        
        //  have the swapSoundViewController we are concerned with assemble the URLs
        //      for the catagory we are concerned with
        _playViewController.slotConfigViewControllerArray[slot].swapSoundViewController.assembleLabelsForSoundCatagory(catagory);
        
        // get the URL we want 
        retURL = _playViewController.slotConfigViewControllerArray[slot].swapSoundViewController.soundCatagoryViewControllerArray[catagory].URLArray[row];
        
        return retURL;
    }
    
    // adds targets for all the controls in the Play view's top view
    //  All methods that handle targets set in this method are in the PlayViewController
    private func addTopViewTargets()
    {
        // set targets associated with the stop and play buttons
        // start
        //  left
        _playViewController.playView.topContainerView.leftStartStopContainerView.startView.addTarget(_playViewController, action: "startButtonChangesStopButton:", forControlEvents: UIControlEvents.TouchUpInside);
        //right
        _playViewController.playView.topContainerView.rightStartStopContainerView.startView.addTarget(_playViewController, action: "startButtonChangesStopButton:", forControlEvents: UIControlEvents.TouchUpInside);
        
        //  stop
        //left
        _playViewController.playView.topContainerView.leftStartStopContainerView.stopView.addTarget(_playViewController, action: "stopButtonChangesStartButton:", forControlEvents: UIControlEvents.TouchUpInside);
        //right
        _playViewController.playView.topContainerView.rightStartStopContainerView.stopView.addTarget(_playViewController, action: "stopButtonChangesStartButton:", forControlEvents: UIControlEvents.TouchUpInside);
        
        //  set the target associated with toggeling the metronome sound
        _playViewController.playView.topContainerView.timeContainerView.metronomeView.addTarget(_playViewController, action: "toggleMetronomeSound", forControlEvents: UIControlEvents.TouchDown);
        
        //  set targets for the record button
        _playViewController.playView.topContainerView.recordView.addTarget(_playViewController, action: "recordButtonDown", forControlEvents: UIControlEvents.TouchDown);
        _playViewController.playView.topContainerView.recordView.addTarget(_playViewController, action: "recordButtonUp", forControlEvents: UIControlEvents.TouchUpInside);
        
        //  set the target responsible for adjusting the tempo
        //      due to user interaction with the TempoView in the TimeContainerView
        _playViewController.playView.topContainerView.timeContainerView.tempoView.addTarget(_playViewController, action: "adjustTempo", forControlEvents: UIControlEvents.TouchDragExit);
    }
    
    // assigns targets to each of the 5 sound tiles in the PlayView
    //  THE METHOD THAT HANDLES THESE SIGNALS is in the PlayViewControllerClass
    private func addSoundSlotTargets()
    {
        for(var pos: Int = 0; pos < 5; pos++)
        {
            // triggering target
            _playViewController.playView.slotTileContainerView.slotTileViewArray[pos].addTarget(_playViewController, action: "soundTileTriggered:", forControlEvents: UIControlEvents.TouchDown);
            // highlighting target
            _playViewController.playView.slotTileContainerView.slotTileViewArray[pos].addTarget(_playViewController, action: "soundTileHighlighted:", forControlEvents: UIControlEvents.TouchDown);
        }
    }
    
    // adds targets for all controlls in the the bottom view of the play view
            //      methods catching these signals are in this class
    private func addBottomViewTargets()
    {
        // set targets for save, load, new, rename, and master volume buttons
        _playViewController.playView.bottomContainerView.configurationButtonView.addTarget(_playViewController, action: "pushSelectedTilesConfigurationView", forControlEvents: UIControlEvents.TouchUpInside);
        _playViewController.playView.bottomContainerView.saveButtonView.addTarget(self, action: "saveButtonPressed", forControlEvents: UIControlEvents.TouchDown);
        _playViewController.playView.bottomContainerView.loadButtonView.addTarget(self, action: "loadButtonPressed", forControlEvents: UIControlEvents.TouchDown);
        _playViewController.playView.bottomContainerView.newButtonView.addTarget(self, action: "newButtonPressed", forControlEvents: UIControlEvents.TouchUpInside);
        _playViewController.playView.bottomContainerView.newButtonView.addTarget(self, action: "newProjectWasChosen", forControlEvents: UIControlEvents.TouchDown);
        _playViewController.playView.bottomContainerView.newButtonView.addTarget(self, action: "newProjectWasNotChosen", forControlEvents: UIControlEvents.ValueChanged);
        _playViewController.playView.bottomContainerView.renameButtonView.addTarget(self, action: "renameButtonPressed", forControlEvents: UIControlEvents.TouchDown);
        _playViewController.playView.bottomContainerView.masterVolumeView.addTarget(self, action: "masterVolumeChanged", forControlEvents: UIControlEvents.TouchDownRepeat);
    }
    
    // handles the user chooing to start a new game via the play view
    func newProjectWasChosen()
    {
        // save the current project
        saveButtonPressed();
        // pop too root
        navigationController?.popToRootViewControllerAnimated(false);
        
        // if the new view controller is nil
        if(_newViewController == nil)
        {
            _newViewController = NewViewController();
        }
        
        navigationController?.pushViewController(_newViewController, animated: true);
    }

    // handles the user not choosing to start a new game via the play view
    func newProjectWasNotChosen()
    {
        // do nothing
    }
}
