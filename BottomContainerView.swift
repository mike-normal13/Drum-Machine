//
//  BottomContainerView.swift
//  FInalProject
//
//  Created by Budge on 5/1/15.
//  Copyright (c) 2015 Budge. All rights reserved.
//

import UIKit

// holds all views along the bottom of the play view
// instance of this class belongs to the PlayView
class BottomContainerView: UIView
{
    // subviews
    private var _configurationButtonView: ConfigurationButtonView! = nil;
    private var _saveButtonView: SaveButtonView! = nil;
    private var _newButtonView: NewButtonView! = nil;
    private var _loadButtonView: LoadButtonView! = nil;
    private var _renameButtonView: RenameButtonView! = nil;
    private var _masterVolumeView: MasterVolumeView! = nil;

    //accessors
    var configurationButtonView: ConfigurationButtonView
    {
        get {return _configurationButtonView}
        set {_configurationButtonView = newValue}
    }
    var saveButtonView: SaveButtonView
    {
        get {return _saveButtonView}
        set {_saveButtonView = newValue}
    }
    var newButtonView:NewButtonView
    {
        get {return _newButtonView}
        set {_newButtonView = newValue}
    }
    var loadButtonView: LoadButtonView
    {
        get{ return _loadButtonView}
        set { _loadButtonView = newValue }
    }
    var renameButtonView: RenameButtonView
    {
        get {return _renameButtonView}
        set { _renameButtonView = newValue}
    }
    var masterVolumeView: MasterVolumeView
    {
        get {return _masterVolumeView}
        set { _masterVolumeView = newValue}
    }

    override init(frame: CGRect)
    {
        super.init(frame: frame);
        self.frame = frame;
        
        _configurationButtonView = ConfigurationButtonView(frame: frame);
        _saveButtonView = SaveButtonView(frame: frame);
        _loadButtonView = LoadButtonView(frame: frame);
        _newButtonView = NewButtonView(frame: frame);
        _renameButtonView = RenameButtonView(frame: frame);
        _masterVolumeView = MasterVolumeView(frame: frame);
    }
    required init(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func layoutSubviews()
    {
        var rect = bounds;
        let portion = rect.width / 6;
                
        // layout
        (_configurationButtonView.frame, rect) = rect.rectsByDividing(portion, fromEdge: CGRectEdge.MinXEdge);
        (_saveButtonView.frame, rect) = rect.rectsByDividing(portion, fromEdge: CGRectEdge.MinXEdge);
        (_loadButtonView.frame, rect) = rect.rectsByDividing(portion, fromEdge: CGRectEdge.MinXEdge);
        (_newButtonView.frame, _masterVolumeView.frame) = rect.rectsByDividing(portion, fromEdge: CGRectEdge.MinXEdge);
        
        // set
        addSubview(_configurationButtonView);
        _configurationButtonView.addSubview(_configurationButtonView.cLabel);
        
        addSubview(_saveButtonView);
        _saveButtonView.addSubview(_saveButtonView.saveLabel);
        
        addSubview(_loadButtonView);
        _loadButtonView.addSubview(_loadButtonView.loadLabel);
        
        addSubview(_newButtonView);
        _newButtonView.addSubview(_newButtonView.newLabel);
        
        addSubview(_masterVolumeView);
    }
}
