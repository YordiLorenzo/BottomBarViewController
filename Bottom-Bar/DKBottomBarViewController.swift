//
//  PullBarViewController.swift
//  Pull Bar
//
//  Created by Yordi Lorenzo de Kleijn on 05/01/16.
//  Copyright © 2016 De Kleijn Development. All rights reserved.
//

import UIKit

protocol DKBottomBarViewControllerDelegate {
    func bottomBarViewControllerDidChangeProgress(progress : CGFloat) -> Void
    func bottomBarViewControllerShow() -> Void
    func bottomBarViewControllerHide() -> Void
    func bottomBarViewControllerDidReachTop() -> Void
    func bottomBarViewControllerDidReachBottom() -> Void
    
    func bottomBarViewControllerTraversal(traversal : CGPoint, velocity : CGPoint) -> Void
    
    func bottomBarViewControllerLeftButtonPressed(button : UIImageView) -> Void
    func bottomBarViewControllerCenterButtonPressed(button : UIImageView) -> Void
    func bottomBarViewControllerRightButtonPressed(button : UIImageView) -> Void
    
    func bottomBarViewControllerDidSetContentView(contentView : UIView, horizontalConstraints : [NSLayoutConstraint], verticalConstraints : [NSLayoutConstraint]) -> Void
}

extension DKBottomBarViewControllerDelegate {
    func bottomBarViewControllerDidChangeProgress(progress : CGFloat) {}
    func bottomBarViewControllerShow() {}
    func bottomBarViewControllerHide() {}
    func bottomBarViewControllerDidReachTop() {}
    func bottomBarViewControllerDidReachBottom() {}
    
    func bottomBarViewControllerTraversal(traversal : CGPoint, velocity : CGPoint) {}
    
    func bottomBarViewControllerLeftButtonPressed(button : UIImageView) {}
    func bottomBarViewControllerCenterButtonPressed(button : UIImageView) {}
    func bottomBarViewControllerRightButtonPressed(button : UIImageView) {}
    
    func bottomBarViewControllerDidSetContentView(contentView : UIView, horizontalConstraints : [NSLayoutConstraint], verticalConstraints : [NSLayoutConstraint]) {}
}

class DKBottomBarViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var delegate : DKBottomBarViewControllerDelegate?
    
    // Internal variables
    private var prevY : CGFloat = 0.0
    
    // Internal views
    private var topBarView : UIView!
    
    // Top margin constraint for this viewcontroller seen from the parent view controller
    private var vTopMarginConstraint : NSLayoutConstraint!
    
    // Configurable top bar buttons
    var leftButton : UIImageView!
    var centerButton : UIImageView!
    var rightButton : UIImageView!
    
    private var overlayView : UIView?
    
    var configuration : DKBottomBarViewControllerConfiguration!
    
    init(configuration : DKBottomBarViewControllerConfiguration) {
        
        self.configuration = configuration
        
        super.init(nibName: nil, bundle: nil)
        
        setupView()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.view.backgroundColor = UIColor.whiteColor()
        self.view.translatesAutoresizingMaskIntoConstraints = false
        
        if self.configuration.topBarShadow! {
            self.view.layer.shadowColor = UIColor.blackColor().CGColor
            self.view.layer.shadowOpacity = 0.7
            self.view.layer.shadowRadius = 6.0
            self.view.layer.shadowOffset = CGSizeMake(0.0, 0.0)
            self.view.layer.shadowPath = UIBezierPath(rect: self.view.bounds).CGPath
        }
        
        topBarView = UIView()
        topBarView.translatesAutoresizingMaskIntoConstraints = false
        topBarView.backgroundColor = self.configuration.topBarBackgroundColor!
        
        leftButton = UIImageView()
        leftButton.userInteractionEnabled = true
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        leftButton.contentMode = .ScaleAspectFit
        leftButton.image = UIImage(named: self.configuration.leftButtonImagePath!)
        leftButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "bottomBarLeftButtonPressed:"))
        
        centerButton = UIImageView()
        centerButton.userInteractionEnabled = true
        centerButton.translatesAutoresizingMaskIntoConstraints = false
        centerButton.contentMode = .ScaleAspectFit
        centerButton.image = UIImage(named: self.configuration.centerButtonImagePath!)
        centerButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "bottomBarCenterButtonPressed:"))
        
        rightButton = UIImageView()
        rightButton.userInteractionEnabled = true
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        rightButton.contentMode = .ScaleAspectFit
        rightButton.image = UIImage(named: self.configuration.rightButtonImagePath!)
        rightButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "bottomBarRightButtonPressed:"))
        
        topBarView.addSubview(leftButton)
        topBarView.addSubview(centerButton)
        topBarView.addSubview(rightButton)
        
        self.view.addSubview(topBarView)
    }
    
    private func setupConstraints() {
        let views = [
            "topBarView" : self.topBarView,
            "leftButton" : self.leftButton,
            "centerButton" : self.centerButton,
            "rightButton" : self.rightButton
        ]
        
        let metrics = [
            "topBarHeight" : self.configuration.topBarHeight!,
            "leftButtonWidth" : self.configuration.leftButtonDimensions!.size.width,
            "centerButtonWidth" : self.configuration.centerButtonDimensions!.size.width,
            "rightButtonWidth" : self.configuration.rightButtonDimensions!.size.width,
            
            "leftButtonHeight" : self.configuration.leftButtonDimensions!.size.height,
            "centerButtonHeight" : self.configuration.centerButtonDimensions!.size.height,
            "rightButtonHeight" : self.configuration.rightButtonDimensions!.size.height,
            
            "leftButtonHorizontalSpacing" : self.configuration.leftButtonDimensions!.origin.x,
            "rightButtonHorizontalSpacing" : self.configuration.leftButtonDimensions!.origin.x
        ]
        
        // Button horizontal constraints
        self.topBarView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-leftButtonHorizontalSpacing-[leftButton(leftButtonWidth)]", options: [], metrics: metrics, views: views))
        self.topBarView.addConstraint(NSLayoutConstraint(item: self.centerButton, attribute: .CenterX, relatedBy: .Equal, toItem: self.topBarView, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        
        self.topBarView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[centerButton(centerButtonWidth)]", options: [], metrics: metrics, views: views))
        self.topBarView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[rightButton(rightButtonWidth)]-rightButtonHorizontalSpacing-|", options: [], metrics: metrics, views: views))
        
        // Button vertical constraints
        self.topBarView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[leftButton(leftButtonHeight)]", options: [], metrics: metrics, views: views))
        self.topBarView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[centerButton(centerButtonHeight)]", options: [], metrics: metrics, views: views))
        self.topBarView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[rightButton(rightButtonHeight)]", options: [], metrics: metrics, views: views))
        
        self.topBarView.addConstraint(NSLayoutConstraint(item: self.leftButton, attribute: .CenterY, relatedBy: .Equal, toItem: self.topBarView, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
        self.topBarView.addConstraint(NSLayoutConstraint(item: self.centerButton, attribute: .CenterY, relatedBy: .Equal, toItem: self.topBarView, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
        self.topBarView.addConstraint(NSLayoutConstraint(item: self.rightButton, attribute: .CenterY, relatedBy: .Equal, toItem: self.topBarView, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
        
        // Add the constraints
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[topBarView(topBarHeight)]", options: [], metrics: metrics, views: views));
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[topBarView]|", options: [], metrics: nil, views: views));
    }
    
    private func calculateProgress() {
        let screenHeight = UIScreen.mainScreen().bounds.height
        
        let normalizedHeight = screenHeight - self.configuration.topBarHeight! - self.configuration.maxTopTreshold!
        var percentage = (1 - (self.vTopMarginConstraint.constant - self.configuration.maxTopTreshold!) / normalizedHeight) * 100
        
        if percentage > 100 || percentage == 100 {
            percentage = 100
            
            bottomBarShow()
        }
        
        if percentage < 0 || percentage == 0 {
            percentage = 0
            
            bottomBarHide()
        }
        
        bottomBarProgressDidChange(percentage)
    }
    
    internal func didPan(panGestureRecognizer : UIPanGestureRecognizer) {
        // Get the absolute screen height
        let screenHeight = UIScreen.mainScreen().bounds.height
        
        // Get the current translation in points
        let translation : CGPoint = panGestureRecognizer.translationInView(self.view)
        // Translation on Y axis
        let translationY = translation.y
        
        // Get the current velocity (speed of the movement) in points / s
        let velocity = panGestureRecognizer.velocityInView(self.view);
        
        // Get the current velocity on the Y axis
        let velocityY = velocity.y
        
        // Calculate delta
        let deltaY = prevY - translationY
        
        // Set prevY to currentY after calculating!
        prevY = translationY
        
        // Call delegate method
        self.delegate?.bottomBarViewControllerTraversal(translation, velocity: velocity)
        
        if panGestureRecognizer.state == .Began { // Do something with the overlay view
            if self.overlayView!.hidden {
                self.overlayView!.hidden = false
            }
        }
        
        if panGestureRecognizer.state == .Ended {
            let isPastHalfwayPoint = self.vTopMarginConstraint!.constant > screenHeight / 2
            let isVelocityNegativeDecisive = velocityY <= self.configuration.velocityNegativeTreshold!
            let isVelocityPositiveDecisive = velocityY >= self.configuration.velocityPositiveTreshold!
            
            
            if isPastHalfwayPoint {
                if isVelocityNegativeDecisive {
                    self.vTopMarginConstraint.constant = self.configuration.maxTopTreshold!
                } else {
                    self.vTopMarginConstraint.constant = screenHeight - self.configuration.topBarHeight!
                }
            } else {
                if isVelocityPositiveDecisive {
                    self.vTopMarginConstraint.constant = screenHeight - self.configuration.topBarHeight!
                } else {
                    self.vTopMarginConstraint.constant = self.configuration.maxTopTreshold!
                }
            }
            
            UIView.animateWithDuration(self.configuration.duration!,
                delay: self.configuration.delay!,
                usingSpringWithDamping: self.configuration.springDamping!,
                initialSpringVelocity: self.configuration.initialSpringVelocity!,
                options:self.configuration.options!,
                animations: { () -> Void in
                    
                    self.view.layoutIfNeeded()
                
                    // Animate alpha if the animation is automatically completed
                    if self.vTopMarginConstraint.constant == self.configuration.maxTopTreshold! {
                        self.overlayView!.alpha = 1.0 - self.getAlphaNegativeDifference()
                        self.view.layer.shadowOffset = CGSizeMake(0.0, -6.0)
                    } else {
                        self.overlayView!.alpha = 0
                        self.view.layer.shadowOffset = CGSizeMake(0.0, 0.0)
                    }
                }, completion: { Void in
                    // Set the overlayView to hidden when the topbarview is completely down
                    if self.overlayView!.alpha == 0 {
                        self.overlayView!.hidden = true
                    }
            })
            
            prevY = 0
        } else { // If it has not ended, just alter the constant of the constraint to fake a smooth transition between points
            let didReachTop = self.vTopMarginConstraint.constant < self.configuration.maxTopTreshold!
            let didReachBottom = self.vTopMarginConstraint.constant > (screenHeight - self.configuration.topBarHeight!)
            
            if didReachTop || didReachBottom {
                if didReachTop {
                    bottomBarDidReachTop()
                } else {
                    bottomBarDidReachBottom()
                }
            } else {
                self.vTopMarginConstraint.constant -= deltaY
            }
        }
        
        calculateProgress()
        
    }
    
    private func getAlphaNegativeDifference() -> CGFloat {
        return 1 - self.configuration.overlayViewMaxOpacity!
    }
    
    // MARK: Delegate proxies
    internal func bottomBarLeftButtonPressed(sender : UITapGestureRecognizer) {
        self.delegate?.bottomBarViewControllerLeftButtonPressed(sender.view as! UIImageView)
    }
    
    internal func bottomBarCenterButtonPressed(sender : UITapGestureRecognizer) {
        self.delegate?.bottomBarViewControllerCenterButtonPressed(sender.view as! UIImageView)
    }
    
    internal func bottomBarRightButtonPressed(sender : UITapGestureRecognizer) {
        self.delegate?.bottomBarViewControllerRightButtonPressed(sender.view as! UIImageView)
    }
    
    internal func bottomBarDidReachTop() {
        self.delegate?.bottomBarViewControllerDidReachTop()
    }
    
    internal func bottomBarDidReachBottom() {
        self.delegate?.bottomBarViewControllerDidReachBottom()
    }
    
    internal func bottomBarHide() {
        self.delegate?.bottomBarViewControllerHide()
    }
    
    internal func bottomBarShow() {
        self.delegate?.bottomBarViewControllerShow()
    }
    
    internal func bottomBarTraversal(traversal : CGPoint, velocity : CGPoint) {
        self.delegate?.bottomBarViewControllerTraversal(traversal, velocity: velocity)
    }
    
    internal func bottomBarProgressDidChange(progress : CGFloat) {
        // Set alpha with progress
        self.overlayView!.alpha = (progress / 100) - self.getAlphaNegativeDifference()
        self.view.layer.shadowOffset = CGSizeMake(0.0, (progress / 10))
        
        self.delegate?.bottomBarViewControllerDidChangeProgress(progress)
    }
    
    // MARK: External Methods
    
    func setContentView(object : AnyObject) {
        let contentView = object as! UIView
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.backgroundColor = contentView.backgroundColor
        
        if self.configuration.debug! {
            contentView.layer.borderColor = UIColor.blackColor().CGColor
            contentView.layer.borderWidth = 1.0
        }
        
        let screenHeight = UIScreen.mainScreen().bounds.height
        
        self.view.addSubview(contentView)
        
        let views = ["contentView" : contentView]
        let metrics = ["contentViewVerticalTopMargin" : self.configuration.topBarHeight!, "contentViewHeight" : (screenHeight - self.configuration.maxTopTreshold! - self.configuration.topBarHeight!)]
        
        var horizontalConstraints : [NSLayoutConstraint]
        var verticalConstraints : [NSLayoutConstraint]
        
        horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[contentView]|", options: [], metrics: nil, views: views)
        verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-contentViewVerticalTopMargin-[contentView(contentViewHeight)]", options: [], metrics: metrics, views: views)
        
        self.view.addConstraints(horizontalConstraints)
        self.view.addConstraints(verticalConstraints)
        
        self.delegate?.bottomBarViewControllerDidSetContentView(contentView, horizontalConstraints: horizontalConstraints, verticalConstraints: verticalConstraints)
    }
    
    // Needs to be called as no 1
    func addToParentViewController(viewController : UIViewController) {
        // Get the screen height
        let screenHeight = UIScreen.mainScreen().bounds.height
        
        // Add the translucent overlay view
        self.overlayView = UIView()
        self.overlayView!.translatesAutoresizingMaskIntoConstraints = false
        self.overlayView!.backgroundColor = self.configuration.overlayViewBackgroundColor!
        self.overlayView!.alpha = 0
        self.overlayView!.hidden = true
        
        viewController.view.addSubview(overlayView!)
        
        // Move it to the parent view controller
        viewController.view.addSubview(self.view)
        self.didMoveToParentViewController(viewController)
        
        // Views
        let views = ["pullBarView" : self.view, "overlayView" : self.overlayView];
        // Metrics
        let metrics = ["height" : screenHeight, "vMargin" : screenHeight - self.configuration.topBarHeight!]
        
        // Constraints for overlay view
        viewController.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[overlayView]|", options: [], metrics: nil, views: views))
        viewController.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[overlayView]|", options: [], metrics: nil, views: views))
        
        // Constraints for pullBarView on the parent view
        viewController.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[pullBarView]|", options: [], metrics: nil, views: views))
        
        let vConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-vMargin-[pullBarView(height)]", options: [], metrics: metrics, views: views)
        
        // Get the constraint for the vMargin
        self.vTopMarginConstraint = vConstraints[0]
        
        viewController.view.addConstraints(vConstraints)
    }
    
    // Needs to be called as no 2
    func addGestureRecognizer() {
        let panGestureRecognizer : UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: "didPan:")
        panGestureRecognizer.delegate = self
        
        switch (self.configuration.panGestureAttachment!) {
        case .Bar:
            self.topBarView.addGestureRecognizer(panGestureRecognizer)
            break
        case .View:
            self.view.addGestureRecognizer(panGestureRecognizer)
            break
        case .LeftButton:
            self.leftButton.addGestureRecognizer(panGestureRecognizer)
            break
        case .CenterButton:
            self.centerButton.addGestureRecognizer(panGestureRecognizer)
            break
        case .RightButton:
            self.rightButton.addGestureRecognizer(panGestureRecognizer)
            break
        }
    }
}
