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
    
    var newlyCreatedFace: UIImageView!
    var newFaceCenter: CGPoint!
    
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
        UIView.animateWithDuration(NSTimeInterval(0.5), delay: NSTimeInterval(0.0), usingSpringWithDamping: CGFloat(1.0), initialSpringVelocity: velocity, options: UIViewAnimationOptions.TransitionCurlUp,
            animations: { () -> Void in
                if self.trayIsOpen {
                    self.trayView.center = self.trayPositionWhenClosed
                } else {
                    self.trayView.center = self.trayPositionWhenOpen
                }
                self.trayIsOpen = !self.trayIsOpen
            }) { (Bool) -> Void in }
    }
    
    @IBAction func createNewFace(sender: AnyObject) {
        let pgr = sender as! UIPanGestureRecognizer
        if pgr.state == UIGestureRecognizerState.Began {
            // Gesture recognizers know the view they are attached to
            let imageView = pgr.view as! UIImageView
            
            // Create a new image view that has the same image as the one currently panning
            newlyCreatedFace = UIImageView(image: imageView.image)
            
            // Add the new face to the tray's parent view.
            view.addSubview(newlyCreatedFace)
            
            // Initialize the position of the new face.
            newlyCreatedFace.center = imageView.center
            newFaceCenter = imageView.center
            
            // Since the original face is in the tray, but the new face is in the
            // main view, you have to offset the coordinates
            newlyCreatedFace.center.y += trayView.frame.origin.y
        } else if pgr.state == UIGestureRecognizerState.Changed {
            let translation = pgr.translationInView(newlyCreatedFace)
            newlyCreatedFace.center = CGPoint(x: newFaceCenter.x + translation.x, y: newFaceCenter.y + translation.y)
        }
    }
}