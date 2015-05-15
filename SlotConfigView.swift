//
//  SlotConfigView.swift
//  FInalProject
//
//  Created by Budge on 5/1/15.
//  Copyright (c) 2015 Budge. All rights reserved.
//

import UIKit

// each of the 5 SlotConfigViewControllers will own an instance of this class
// the container for the slot configuration view
class SlotConfigView: UIView
{
    // view members
    //  top
    private var _backToPlayView: BackToPlayView! = nil
    private var _swapSoundView: SwapSoundView! = nil
    private var _soundNameLabelView: SoundNameLabelView! = nil

    //  bottom
    private var _startPositionView: StartPositionView! = nil;
    private var _stretchView: StretchView! = nil;
    private var _previewView: PreviewView! = nil;
    
    // container view members
    private var _transposeContainerView: TransposeContainerView! = nil
    private var _decayContainerView: DecayContainerView! = nil;
    private var _panContainerView: PanContainerView! = nil;
    private var _volumeContainerView: VolumeContainerView! = nil;
    
    // layout dividers
    // outer divider
    private var _rect: CGRect = CGRect(); //bounds;
    // top division
    private var _topRect: CGRect = CGRect()
    // middle division
    private var _bottomRect: CGRect = CGRect();
    
    // space between the go back button and the swap button
    private var _goBackSwapSpace: CGRect = CGRect();
    
    private var _topPortion: CGFloat = 0
    private var _spaceBetweenGoAndSwap: CGFloat = 0
    private var _bottomMakeShiftPortion: CGFloat = 0
    
    //accessors
    var backToPlayView: BackToPlayView
    {
        get {return _backToPlayView}
        set { _backToPlayView = newValue}
    }
    var swapSoundView: SwapSoundView
        {
        get {return _swapSoundView}
        set { _swapSoundView = newValue}
    }
    var soundNameLabelView: SoundNameLabelView
        {
        get {return _soundNameLabelView}
        set { _soundNameLabelView = newValue}
    }
    var startPositionView: StartPositionView
        {
        get {return _startPositionView}
        set { _startPositionView = newValue}
    }
    var stretchView: StretchView
        {
        get {return _stretchView}
        set { _stretchView = newValue}
    }
    var transposeContainerView: TransposeContainerView
        {
        get {return _transposeContainerView}
        set { _transposeContainerView = newValue}
    }
    var decayContainerView: DecayContainerView
        {
        get {return _decayContainerView}
        set { _decayContainerView = newValue}
    }
    var panContainerView: PanContainerView
        {
        get {return _panContainerView}
        set { _panContainerView = newValue}
    }
    var volumeContainerView: VolumeContainerView
        {
        get {return _volumeContainerView}
        set { _volumeContainerView = newValue}
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.frame = frame;
        
        _rect = bounds;
        
        // split off top and bottom
        (_topRect, _bottomRect) = _rect.rectsByDividing(_rect.height * 0.27, fromEdge: CGRectEdge.MinYEdge);
        
        _backToPlayView = BackToPlayView(frame: _topRect)
        _swapSoundView = SwapSoundView(frame: _topRect);
        _soundNameLabelView = SoundNameLabelView(frame: _topRect);
        
        _topPortion = _rect.width * 0.14; // swap, name
        
        _spaceBetweenGoAndSwap = _rect.width * 0.15;
         _bottomMakeShiftPortion = _rect.width / 6;
        
        // intialize bottom subviews
        _startPositionView = StartPositionView(frame: _bottomRect);              //  start
        _startPositionView.backgroundColor = UIColor.grayColor();
        _transposeContainerView = TransposeContainerView();                     //  transpose
        _transposeContainerView.transposeView = TransposeView(frame: _bottomRect);
        _stretchView = StretchView(frame: _bottomRect);                          //  stretch
        _stretchView.backgroundColor = UIColor.grayColor();
        _decayContainerView = DecayContainerView(frame: _bottomRect);            //  decay
        _decayContainerView.backgroundColor = UIColor.grayColor();
        _panContainerView = PanContainerView();                                 //  pan
        _panContainerView.panView = PanView(frame: _bottomRect);
        _volumeContainerView = VolumeContainerView();                           //  volume
        _volumeContainerView.volumeView = VolumeView(frame: _bottomRect);
        
        var o = 0;
    }
    required init(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func layoutSubviews()
    {
        //  devide and place top subiews
        // split off go back button
        (_backToPlayView.frame, _topRect) = _topRect.rectsByDividing(_spaceBetweenGoAndSwap, fromEdge: CGRectEdge.MinXEdge)
        // split off space between buttons
        (_goBackSwapSpace, _topRect) = _topRect.rectsByDividing(_topPortion, fromEdge: CGRectEdge.MinXEdge);
        // split of Swap button
        (_swapSoundView.frame, _soundNameLabelView.frame) = _topRect.rectsByDividing(_topPortion, fromEdge: CGRectEdge.MinXEdge);
        
        //  Split off and place bottom subviews
        //  Split off start control
        (_startPositionView.frame, _bottomRect) = _bottomRect.rectsByDividing(_bottomMakeShiftPortion, fromEdge: CGRectEdge.MinXEdge);
        //  Split off transpose controls
        (_transposeContainerView.frame, _bottomRect) = _bottomRect.rectsByDividing(_bottomMakeShiftPortion, fromEdge: CGRectEdge.MinXEdge);
        //  split off stretch view
        (_stretchView.frame, _bottomRect) = _bottomRect.rectsByDividing(_bottomMakeShiftPortion, fromEdge: CGRectEdge.MinXEdge);
        // split of decay view
        (_decayContainerView.frame, _bottomRect) = _bottomRect.rectsByDividing(_bottomMakeShiftPortion, fromEdge: CGRectEdge.MinXEdge);
        // split off pan container
        (_panContainerView.frame, _volumeContainerView.frame) = _bottomRect.rectsByDividing(_bottomMakeShiftPortion, fromEdge: CGRectEdge.MinXEdge);
        
        // add all subviews
        //      top subviews
        addSubview(_backToPlayView)
        _backToPlayView.addSubview(_backToPlayView.goBackLabel);
        addSubview(_swapSoundView);
        _swapSoundView.addSubview(_swapSoundView.swapLabel);
        addSubview(_soundNameLabelView);
        
        //  bottom subviews
        addSubview(_startPositionView);
        addSubview(_transposeContainerView);
        addSubview(_stretchView);
        addSubview(_decayContainerView);
        addSubview(_panContainerView);
        addSubview(_volumeContainerView);
    }
    
    // sets all the _soundIsLoaded flags to true once a sound is loaded
    //  this method is called in the delegate method in LoadStartViewController
    func setControlFlags()
    {
        _soundNameLabelView.soundIsLoaded = true;
        _startPositionView.soundIsLoaded = true;
        _transposeContainerView.transposeView.soundIsLoaded = true;
        _transposeContainerView.transposeRandomView.soundIsLoaded = true;
        _stretchView.soundIsLoaded = true;
        _decayContainerView.decayView.soundIsLoaded = true;
        _panContainerView.panView.soundIsLoaded = true;
        _panContainerView.panRandomView.soundIsLoaded = true;
        _volumeContainerView.volumeView.soundIsLoaded = true;
    }
    
    func resetControlFlags()
    {
        _soundNameLabelView.soundIsLoaded = false;
        _startPositionView.soundIsLoaded = false;
        _transposeContainerView.transposeView.soundIsLoaded = false;
        _transposeContainerView.transposeRandomView.soundIsLoaded = false;
        _stretchView.soundIsLoaded = false;
        _decayContainerView.decayView.soundIsLoaded = false;
        _panContainerView.panView.soundIsLoaded = false;
        _panContainerView.panRandomView.soundIsLoaded = false;
        _volumeContainerView.volumeView.soundIsLoaded = false;
        _volumeContainerView.volumeView.soundIsLoaded = false;
    }
}
