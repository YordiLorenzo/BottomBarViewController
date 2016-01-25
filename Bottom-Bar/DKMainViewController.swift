//
//  ViewController.swift
//  Pull Bar v2
//
//  Created by Yordi Lorenzo de Kleijn on 08/01/16.
//  Copyright © 2016 De Kleijn Development. All rights reserved.
//

import UIKit
import MapKit
class DKMainViewController: UIViewController, DKBottomBarViewControllerDelegate {
    
    var bottomBarViewController : DKBottomBarViewController?
    var statusBarStyle : UIStatusBarStyle = UIStatusBarStyle.Default
    var vTopMarginConstraint : NSLayoutConstraint?
    var mapView : MKMapView?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        setupBottomBarViewController()
        
        mapView = MKMapView(frame: CGRectZero)
        mapView!.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(mapView!)
        
        let views = ["mapView" : mapView!]
        let metrics = ["mapViewBottomMargin" : bottomBarViewController!.configuration.topBarHeight!]
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[mapView]|", options: [], metrics: nil, views: views))
        
        let constraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[mapView]-mapViewBottomMargin-|", options: [], metrics: metrics, views: views)
        self.view.addConstraints(constraints)
        vTopMarginConstraint = constraints[0]
        
        print(vTopMarginConstraint)
        
        let regionSpan : CLLocationDistance = 3000;
        let adjustedRegion = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(52.3950895,4.8530539), regionSpan, regionSpan)
        
        self.mapView!.setRegion(adjustedRegion, animated: true)
        self.view.sendSubviewToBack(mapView!)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupBottomBarViewController() -> Void {
        let configuration = DKBottomBarViewControllerConfiguration.standardConfiguration()
        configuration.leftButtonImagePath = "menu"
        configuration.rightButtonImagePath = "close"
        
        bottomBarViewController = DKBottomBarViewController(configuration: configuration)
        bottomBarViewController!.addToParentViewController(self)
        bottomBarViewController!.addGestureRecognizer()
        bottomBarViewController!.delegate = self
        
        let view = UIView()
        view.backgroundColor = UIColor.whiteColor()
        bottomBarViewController!.setContentView(view)
    }
    
    //MARK: DKBottomBarViewControllerDelegate
    
    func bottomBarViewControllerDidChangeProgress(progress: CGFloat) {
        print(progress)
    }
    
    func bottomBarViewControllerLeftButtonPressed(button : UIImageView) {
        print(button)
    }
    
    func bottomBarViewControllerCenterButtonPressed(button : UIImageView) {
        print(button)
    }
    
    func bottomBarViewControllerRightButtonPressed(button : UIImageView) {
        print(button)
    }
    
    func bottomBarViewControllerShow() {
        self.statusBarStyle = UIStatusBarStyle.LightContent
        updateStatusBar()
    }
    
    func bottomBarViewControllerHide() {
        self.statusBarStyle = UIStatusBarStyle.Default
        updateStatusBar()
    }
    
    func bottomBarViewControllerDidSetContentView(contentView: UIView, horizontalConstraints: [NSLayoutConstraint], verticalConstraints: [NSLayoutConstraint]) {
        
    }
    
    func bottomBarViewControllerTraversal(traversal: CGPoint, velocity: CGPoint) {
        print(traversal)
        print(velocity)
    }
    
    //MARK: Status bar style
    
    
    private func updateStatusBar() {
        UIView.animateWithDuration(0.33) { () -> Void in
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    override func preferredStatusBarUpdateAnimation() -> UIStatusBarAnimation {
        return UIStatusBarAnimation.Fade
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return statusBarStyle
    }
}

