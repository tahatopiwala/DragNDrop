//
//  ViewController.swift
//  DragNDrop
//
//  Created by Taha Topiwala on 7/6/17.
//  Copyright © 2017 Taha Topiwala Publication. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
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
        UIView.animate(withDuration: 0.5) {
            self.file.alpha = 1
            self.file.frame.origin = self.fileViewOriginalPoint
        }
    }
    
    override func viewDidLoad() {
        view.bringSubview(toFront: file)
    }
    
    fileprivate func handlePan(_ view: UIView, _ sender: UIPanGestureRecognizer) {
        
        let transition = sender.translation(in: view)
        
        view.center = CGPoint(x: file.center.x + transition.x, y: file.center.y + transition.y)
        
        sender.setTranslation(CGPoint.zero, in: view)
    }
    
    fileprivate func handleEndPan(_ fileView: UIView) {
        if fileView.frame.intersects(trash.frame) {
            UIView.animate(withDuration: 0.5, animations: {
                self.file.alpha = 0
            })
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.file.frame.origin = self.fileViewOriginalPoint
            })
        }
    }
    
    @objc func panGesture(sender: UIPanGestureRecognizer) {
        
        let fileView = sender.view!
        
        switch sender.state {
        case .changed, .began:
            
            handlePan(fileView, sender)
            
            break
        case .ended:
            
            handleEndPan(fileView)
            
            break
        default:
            break
        }
    }
}

