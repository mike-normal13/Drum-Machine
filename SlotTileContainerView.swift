//
//  SlotTileContainerView.swift
//  FInalProject
//
//  Created by Budge on 5/1/15.
//  Copyright (c) 2015 Budge. All rights reserved.
//

import UIKit

// contains the tiles that trigger the sounds
// instance of this class is owned by the PlayView
class SlotTileContainerView: UIView
{
    private var _slotTileViewArray: [SlotTileView!] = [nil, nil, nil, nil, nil];
    
    // accessors
    var slotTileViewArray: [SlotTileView!]
    {
        get {return _slotTileViewArray}
        set {_slotTileViewArray = newValue}
    }
    
    override func layoutSubviews()
    {        
        var rect = bounds;
        let portion  = rect.width / 5;
        
        initializeSlotArray();
        
        (_slotTileViewArray[0].frame, rect) = rect.rectsByDividing(portion, fromEdge: CGRectEdge.MinXEdge);
        (_slotTileViewArray[1].frame, rect) = rect.rectsByDividing(portion, fromEdge: CGRectEdge.MinXEdge);
        (_slotTileViewArray[2].frame, rect) = rect.rectsByDividing(portion, fromEdge: CGRectEdge.MinXEdge);
        (_slotTileViewArray[3].frame, _slotTileViewArray[4].frame) = rect.rectsByDividing(portion, fromEdge: CGRectEdge.MinXEdge);
        
        for(var pos: Int = 0; pos < 5; pos++)
        {
            addSubview(_slotTileViewArray[pos]);
            _slotTileViewArray[pos].addSubview(_slotTileViewArray[pos].fileNameLabel);
        }
    }
    
    // initializes the slot views and sets thier slot numbers, and label text
    private func initializeSlotArray()
    {
        for(var pos: Int = 0; pos < 5; pos++)
        {
            _slotTileViewArray[pos] = SlotTileView(frame: bounds);
            _slotTileViewArray[pos].slotNumber = pos;
            _slotTileViewArray[pos].fileNameLabelText = "No File Loaded...";
        }
    }
}
