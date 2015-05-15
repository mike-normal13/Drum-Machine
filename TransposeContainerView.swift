//
//  TransposeContainerView.swift
//  FInalProject
//
//  Created by Budge on 5/1/15.
//  Copyright (c) 2015 Budge. All rights reserved.
//

import UIKit

// holds the controls responsible for the adjusting the pitch of a sample
//  instace of this class is owned by the SlotConfigView
class TransposeContainerView: UIView
{
    private var _transposeView: TransposeView! = nil;
    private var _transposeRandomView: TransposeRandomView! = nil;
    
    // accessors
    var transposeView: TransposeView
    {
        get { return _transposeView }
        set { _transposeView = newValue }
    }
    var transposeRandomView: TransposeRandomView
        {
        get { return _transposeRandomView }
        set { _transposeRandomView = newValue }
    }
    
    override func layoutSubviews()
    {
        var rect = bounds;
        
        _transposeView = TransposeView(frame: bounds)
        _transposeRandomView = TransposeRandomView(frame: bounds);
        
        (_transposeView.frame, _transposeRandomView.frame) = rect.rectsByDividing(rect.height / 2, fromEdge: CGRectEdge.MinYEdge);
                
        addSubview(_transposeView);
        addSubview(_transposeRandomView);
    }
}
