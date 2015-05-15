//
//  SlotConfigViewController.swift
//  FInalProject
//
//  Created by Budge on 5/1/15.
//  Copyright (c) 2015 Budge. All rights reserved.
//

import UIKit

// controlls the sound slot configuration view
//  5 instances of this class will be owned by the PlayViewController
class SlotConfigViewController: UIViewController
{
    // number the PlayViewController uses to identify the SlotConfigViewController
    private var _configNumber: Int = 0;
    
    //  TODO pushing this will be a little tricky......
    // swap sound view controller member
    private var _swapSoundViewController: SwapSoundViewController! = nil;
    // the sound that pressing pressing a tile will produce
    private var _currentLoadedSound: NSURL! = nil;
    
    // indicates whether all of self's targets have been set
    private var _targetsHaveBeenSet: Bool = false;
        
    // view member
    private var _slotConfigView: SlotConfigView! = nil;
    
    //accessors
    var configNumber: Int
    {
        get { return _configNumber }
        set { _configNumber = newValue }
    }
    var slotConfigView: SlotConfigView!
    {
        get { return _slotConfigView }
        set { _slotConfigView = newValue }
    }
    var currentLoadedSound: NSURL
    {
        get { return _currentLoadedSound }
        set { _currentLoadedSound = newValue}
    }
    var swapSoundViewController: SwapSoundViewController!
    {
        get { return _swapSoundViewController }
        set { _swapSoundViewController = newValue }
    }
    //  TODO: when do we send this back to false???
    var targetsHaveBeenSet: Bool
    {
        get { return _targetsHaveBeenSet }
        set { _targetsHaveBeenSet = newValue}
    }
    
    override func loadView()
    {
        _slotConfigView = SlotConfigView(frame: parentViewController!.view.frame);
        view = _slotConfigView;
    }
        
    // handles the user presssing the "Back" button
    //  target was set in the LoadStartViewController
    func backbuttonWasPressed()
    {
        // pop back to the play view
        navigationController?.popViewControllerAnimated(true);
    }
    
    // handles user pushing the swap button
    //  target was set in the LoadStartViewController
    func swapButtonWasPressed()
    {
        // if the SwapSoundViewController has not been initialized...
        if(_swapSoundViewController == nil)
        {
            _swapSoundViewController = SwapSoundViewController();
        }
        
        // push the SoundCatagoryViewController
        navigationController?.pushViewController(_swapSoundViewController, animated: true);
        navigationController?.setNavigationBarHidden(false, animated: true);
    }
    
    // this function is called by the navigation view controller delegate method in LoadStartViewController
    //      once a user selects a sound to load from a sound catagory view controller.
    //      This function also returns the sound in question.
    //          so the LoadStartViewController can update the model.
    func setSlotSound() -> NSURL?
    {
        // check for the flag
        // only attempt to set the value if the swapSoundViewContoller has allready been shown,
        //      and the user selected a catagory to choose from.
        if(_swapSoundViewController?.selectedIndexPath != nil)
        {
            if(_swapSoundViewController.soundCatagoryViewControllerArray[_swapSoundViewController.selectedIndexPath.item].soundWasChosen == true)
            {
                _currentLoadedSound = _swapSoundViewController.soundCatagoryViewControllerArray[_swapSoundViewController.selectedIndexPath.item].chosenSound;
            }
                return _currentLoadedSound;
        }
        return nil;
    }
}
