//
//  ViewController.swift
//  codepath-lab-4
//
//  Created by Jeremiah Lee on 2/24/16.
//  Copyright © 2016 Codepath. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var trayView: UIView!
    @IBOutlet var panGestureRecognizer: UIPanGestureRecognizer!
    
    var trayOriginalCenter: CGPoint!
    var trayPositionWhenOpen: CGPoint!
    var trayPositionWhenClosed: CGPoint!
    var trayIsOpen: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        trayPositionWhenClosed = CGPoint(x: trayView.center.x, y: trayView.center.y + 150)
        trayPositionWhenOpen = CGPoint(x: trayView.center.x, y: trayView.center.y)
        
        trayView.center = trayPositionWhenClosed
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onTrayTap(sender: AnyObject) {
        toggleTray(CGFloat(1.0))
    }
    
    @IBAction func onTrayPanGesture(sender: UIPanGestureRecognizer) {
        // Absolute (x,y) coordinates in parent view (parentView should be
        // the parent view of the tray)
        
        if panGestureRecognizer.state == UIGestureRecognizerState.Began {
            trayOriginalCenter = trayView.center
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Changed {
            let translation = panGestureRecognizer.translationInView(trayView)
            trayView.center = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + translation.y)
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Ended {
            let velocity = panGestureRecognizer.velocityInView(trayView)
            toggleTray(velocity.y)
        }
    }
    
    func toggleTray(velocity: CGFloat) {
        UIView.animateWithDuration(NSTimeInterval(0.5), delay: NSTimeInterval(0.0), usingSpringWithDamping: CGFloat(1.0), initialSpringVelocity: velocity, options: UIViewAnimationOptions.TransitionNone,
            animations: { () -> Void in
                if self.trayIsOpen {
                    self.trayView.center = self.trayPositionWhenClosed
                } else {
                    self.trayView.center = self.trayPositionWhenOpen
                }
                self.trayIsOpen = !self.trayIsOpen
            }) { (Bool) -> Void in }
    }
}

