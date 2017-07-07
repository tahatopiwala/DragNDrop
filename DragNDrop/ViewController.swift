//
//  ViewController.swift
//  DragNDrop
//
//  Created by Taha Topiwala on 7/6/17.
//  Copyright © 2017 Taha Topiwala Publication. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let transitionDuration = 0.5
    
    var fileViewOriginalPoint: CGPoint!
    
    @IBOutlet weak var file: UIImageView! {
        didSet {
            file.isUserInteractionEnabled = true
            file.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(ViewController.panGesture(sender:))))
            fileViewOriginalPoint = file.frame.origin
        }
    }
    
    @IBOutlet weak var trash: UIImageView! {
        didSet {
            trash.isUserInteractionEnabled = true
        }
    }
    
    @IBAction func resetImage(_ sender: Any) {
        resetLayout()
    }
    
    override func viewDidLoad() {
        view.bringSubview(toFront: file)
    }
    
    @objc func panGesture(sender: UIPanGestureRecognizer) {
        
        let fileView = sender.view!
        
        switch sender.state {
        case .began:
            
            handleBeginPan()
            
            break
        case .changed:
            
            handleChangedPan(fileView, sender)
            
            break
        case .ended:
            
            handleEndPan(fileView)
            
            break
        default:
            break
        }
    }
}

// Pan Handle Methods

extension ViewController {
    
    fileprivate func handleBeginPan() {
        return UIView.animate(withDuration: transitionDuration, animations: {
            self.trash.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.file.alpha = 0.5
        })
    }
    
    fileprivate func handleChangedPan(_ view: UIView, _ sender: UIPanGestureRecognizer) {
        
        let transition = sender.translation(in: view)
        
        view.center = CGPoint(x: file.center.x + transition.x, y: file.center.y + transition.y)
        
        sender.setTranslation(CGPoint.zero, in: view)
    }
    
    fileprivate func handleEndPan(_ fileView: UIView) {
        if fileView.frame.intersects(trash.frame) {
            UIView.animate(withDuration: transitionDuration, animations: {
                self.trash.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.file.alpha = 0
            })
        } else {
            resetLayout()
        }
    }
    
    fileprivate func resetLayout() {
        UIView.animate(withDuration: transitionDuration, animations: {
            self.trash.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.file.frame.origin = self.fileViewOriginalPoint
            self.file.alpha = 1
        })
    }
}

