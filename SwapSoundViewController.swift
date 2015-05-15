//
//  SwapSoundViewController.swift
//  FInalProject
//
//  Created by Budge on 5/1/15.
//  Copyright (c) 2015 Budge. All rights reserved.
//

import UIKit

// instance of this class will be owned by the SlotConfigViewController
// lets the user choose a catagory of sound to choose to swap sounds from
class SwapSoundViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    //  the SlotConfigurationContoller can use this to tell which sound catagory was chosen
    private var _selectedIndexPath: NSIndexPath! = nil
    //  array of SoundCatagoryViewControllers
    private var _soundCatagoryViewControllerArray: [SoundCatagoryViewController!] = [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil];
    // 12 catagories
    private var _soundCatagoryLabels: [String] = ["Snare", "Kick", "Hi-hat", "Snap", "Clap", "Rim", "Block/Clave", "Cymbal", "Conga/Bongo", "Tamborine", "Tom", "Triangle"];
    
    // accessors
    var catagoryTable: UITableView { return view as! UITableView }
    var soundCatagoryViewControllerArray: [SoundCatagoryViewController!]
    {
        get { return _soundCatagoryViewControllerArray }
        set { _soundCatagoryViewControllerArray = newValue }
    }
    var selectedIndexPath: NSIndexPath! { return _selectedIndexPath }
    
    override func loadView()
    {
        view = UITableView();
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad();
        catagoryTable.dataSource = self;
        catagoryTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Catagory Option Cell");
        catagoryTable.delegate = self;
        title = "Choose Sound Type";
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("Catagory Option Cell") as! UITableViewCell;
        
        // display the options available to the user
        cell.textLabel?.text = _soundCatagoryLabels[indexPath.row] as String;
        
        return cell;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 12;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        _selectedIndexPath = indexPath
        
        // if the selected sound catagory view contorller has not been initialized...
        if(_soundCatagoryViewControllerArray[_selectedIndexPath.item] == nil)
        {
            // initialize view controller
            _soundCatagoryViewControllerArray[_selectedIndexPath.item] = SoundCatagoryViewController();
            // set the title of the view controller
            _soundCatagoryViewControllerArray[_selectedIndexPath.item].title = "Choose \(_soundCatagoryLabels[_selectedIndexPath.item])";
            
            // set the view controller's index member **************
            _soundCatagoryViewControllerArray[_selectedIndexPath.item].controllerIndex = _selectedIndexPath.item;
            
            // gather and parse all file names of the selected catagory
            //      and set names as corresponding view controller's cell labels
            assembleLabelsForSoundCatagory(_selectedIndexPath.item);
        }

        // push the selected view controller
        navigationController?.pushViewController(_soundCatagoryViewControllerArray[_selectedIndexPath.item], animated: true);
    }
    
    // method assembles labels for a choosen sound catagory
    //      and sets the chosen catagory's cell label array
    func assembleLabelsForSoundCatagory(catagoryIndex: Int)
    {
        var catagoryString: String = catagoryIndex.description;
        
        var fileNamesLower: NSArray;
        var fileNamesUpper: NSArray;
        
        //  Will be set to the SoundCatagorieViewController's cell labels
        var parsedFileNameArray: [String] = []
        var URLArray: [NSURL] = [];
        
        var splitLowerFileNameArray: [String];
        var splitUpperFileNameArray: [String];
        
        fileNamesLower = NSBundle.mainBundle().URLsForResourcesWithExtension("wav", subdirectory: catagoryString)!;
        fileNamesUpper = NSBundle.mainBundle().URLsForResourcesWithExtension("WAV", subdirectory: catagoryString)!;
        
        for fileName in fileNamesLower
        {
            // place full URL
            URLArray.append(fileName as! NSURL);
            // parse and place
            splitLowerFileNameArray = fileName.description.componentsSeparatedByString("-")
            parsedFileNameArray.append(splitLowerFileNameArray[0].stringByRemovingPercentEncoding!);
        }
        for fileName in fileNamesUpper
        {
            // place full URL
            URLArray.append(fileName as! NSURL);
            //  parse and place;
            splitUpperFileNameArray = fileName.description.componentsSeparatedByString("-");
            parsedFileNameArray.append(splitUpperFileNameArray[0].stringByRemovingPercentEncoding!);
        }
        
        // set the parsed file name array to the SoundCatagoryViewController's cell labels.
        _soundCatagoryViewControllerArray[catagoryIndex].soundLabels = parsedFileNameArray;
        // set the URL array...
        _soundCatagoryViewControllerArray[catagoryIndex].URLArray = URLArray;
    }
}
