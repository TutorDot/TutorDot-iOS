//
//  testVC.swift
//  TutorDot_iOS
//
//  Created by Sehwa Ryu on 2020/10/01.
//  Copyright © 2020 Sehwa Ryu. All rights reserved.
//

import UIKit

class testVC: UIViewController {

    @IBOutlet weak var panView: UIView!
    @IBOutlet weak var panHeight: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGestureRecognizer(_:)))
            panView.addGestureRecognizer(gesture)
        
        
        //let gesture = UIPanGestureRecognizer(target: self, action: #selector(self.pan(_:)))
            //panView.addGestureRecognizer(gesture)

        // Do any additional setup after loading the view.
    }
    
//    @objc func pan(_ pan: UIPanGestureRecognizer) {
//        let translation = pan.translation(in: panView)
//        if pan.state == .began {
//        } else if pan.state == .changed {
//            panHeight.constant = panHeight.constant - translation.y
//            pan.setTranslation(CGPoint.zero, in: panView)
//        } else if pan.state == .ended {
//            panHeight.constant = panHeight.constant - translation.y
//        }
//    }
    
    private var originalX: CGFloat = 0.0
    private var originalY: CGFloat = 0.0

    @objc func handlePanGestureRecognizer(_ pan: UIPanGestureRecognizer) {

        guard let panView = pan.view else {
            return
        }

        // Make sure, the gastureRecognizer's view the topmost view
        self.view.bringSubviewToFront(panView)

        // Find coordinates of the gesture recognizer event on the screen
        var translatedPoint = pan.translation(in: self.view)

        // The dragging has just started, lets remember the inital positions
        if pan.state == .began {
            originalX = panView.center.x
            originalY = panView.center.y
        }

        // increase the coordinates of the gesturerecognizers view by the dragging movement's y coordinate
        translatedPoint = CGPoint(x: originalX, y: originalY + translatedPoint.y)

        UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseInOut], animations: {
            pan.view?.center = translatedPoint
        } , completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
