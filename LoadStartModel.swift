//
//  LoadStartModel.swift
//  FInalProject
//
//  Created by Budge on 5/1/15.
//  Copyright (c) 2015 Budge. All rights reserved.
//

import Foundation

// instance of this class is owned by the LoadStartViewController
class LoadStartModel
{
    private var _projectFilePathsArray: NSMutableArray? = [];
    
    //  accessors
    var projectFilePathsArray: NSMutableArray?
    {
        get { return _projectFilePathsArray }
        set { _projectFilePathsArray = newValue }
    }
}
