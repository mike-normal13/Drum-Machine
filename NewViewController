//
//  NewViewController.swift
//  FInalProject
//
//  Created by Budge on 5/1/15.
//  Copyright (c) 2015 Budge. All rights reserved.
//

import UIKit

// this class controls the view that lets the user make a new beat config project
//  instance of this class is owned by the LoadStartViewController
class NewViewController: UIViewController
{
    // view accessor
    var newView: NewView { return view as! NewView }
    
    override func loadView()
    {
        // intialize view
        view = NewView(frame: parentViewController!.view.bounds);
        navigationController?.title = "Start Making A Beat";
    }
}
