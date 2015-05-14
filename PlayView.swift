//
//  PlayView.swift
//  FInalProject
//
//  Created by Budge on 5/1/15.
//  Copyright (c) 2015 Budge. All rights reserved.
//

import UIKit

// contains all sub views of the play view
// instance of this class is owned by the PlayViewController
class PlayView: UIView
{
    private var _topContainerView: TopContainerView! = nil;
    private var _slotTileContainerView: SlotTileContainerView! = nil;
    private var _bottomContainerView: BottomContainerView! = nil;
    
    //accessors 
    var topContainerView: TopContainerView!
    {
        get {return _topContainerView}
        set { _topContainerView = newValue }
    }
    var slotTileContainerView: SlotTileContainerView!
    {
        get {return _slotTileContainerView }
        set { _slotTileContainerView = newValue }
    }
    var bottomContainerView: BottomContainerView!
    {
        get { return _bottomContainerView }
        set { _bottomContainerView = newValue }
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame);
        self.frame = frame;
    }
    required init(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // divide the screen amongst the three major sections of the PlayView
    override func layoutSubviews()
    {
        // all sub views will be split from this rect
        var rect: CGRect = bounds;
        
        _topContainerView = TopContainerView();
        _slotTileContainerView = SlotTileContainerView();
        _bottomContainerView = BottomContainerView();
        
        (_bottomContainerView.frame , rect) = rect.rectsByDividing(rect.height * 0.1, fromEdge: CGRectEdge.MaxYEdge);
        (_slotTileContainerView.frame , _topContainerView.frame) = rect.rectsByDividing(rect.height * 0.65, fromEdge: CGRectEdge.MaxYEdge);
        
        addSubview(_topContainerView);
        addSubview(_slotTileContainerView);
        addSubview(_bottomContainerView);
    }
}
