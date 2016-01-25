//
//  DKBottomBarConfiguration.swift
//  Bottom-Bar
//
//  Created by Yordi Lorenzo de Kleijn on 13/01/16.
//  Copyright © 2016 De Kleijn Development. All rights reserved.
//

import UIKit

enum DKBottomBarViewControllerPanGestureAttachment {
    case Bar, View, LeftButton, CenterButton, RightButton
}

class DKBottomBarViewControllerConfiguration: NSObject {
    
    var topBarHeight                : CGFloat?
    var topBarBackgroundColor       : UIColor?
    
    var topBarShadow                : Bool?
    
    var overlayViewBackgroundColor  : UIColor?
    var overlayViewMaxOpacity       : CGFloat?
    
    var maxTopTreshold              : CGFloat?
    var velocityNegativeTreshold    : CGFloat?
    var velocityPositiveTreshold    : CGFloat?
    var panGestureAttachment        : DKBottomBarViewControllerPanGestureAttachment?
    
    var leftButtonDimensions        : CGRect?
    var centerButtonDimensions      : CGRect?
    var rightButtonDimensions       : CGRect?
    
    var leftButtonImagePath         : String?
    var centerButtonImagePath       : String?
    var rightButtonImagePath        : String?
    
    var debug                       : Bool?
    
    var duration                    : NSTimeInterval?
    var delay                       : NSTimeInterval?
    var springDamping               : CGFloat?
    var initialSpringVelocity       : CGFloat?
    var options                     : UIViewAnimationOptions?
    
    override init() {
        super.init()
    }
    
    static func standardConfiguration() -> DKBottomBarViewControllerConfiguration {
        let configuration = DKBottomBarViewControllerConfiguration()
        configuration.topBarHeight = 60.0
        configuration.topBarBackgroundColor = UIColor(red: 44.0 / 255.0, green: 62.0 / 255.0, blue: 80.0 / 255.0, alpha: 1.0)
        
        configuration.topBarShadow = true
        
        configuration.overlayViewBackgroundColor = UIColor.blackColor()
        configuration.overlayViewMaxOpacity = 0.8
        configuration.maxTopTreshold = 85.0
        configuration.velocityNegativeTreshold = -600
        configuration.velocityPositiveTreshold = 600
        configuration.panGestureAttachment = .View
        
        configuration.leftButtonDimensions = CGRectMake(15, 0, 30, 30)
        configuration.centerButtonDimensions = CGRectMake(10, 0, 45, 45)
        configuration.rightButtonDimensions = CGRectMake(15, 0, 25, 25)
        configuration.leftButtonImagePath = "logo-dark"
        configuration.centerButtonImagePath = "logo-dark"
        configuration.centerButtonImagePath = "logo-dark"
        
        configuration.debug = false
        
        configuration.duration = 0.6
        configuration.delay = 0.0
        configuration.springDamping = 0.8
        configuration.initialSpringVelocity = 0.7
        configuration.options = []
        
        return configuration
    }
}