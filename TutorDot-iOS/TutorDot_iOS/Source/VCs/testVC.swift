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
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    enum CardViewState {
          case expanded
          case normal
      }

      // default card view state is normal
      var cardViewState : CardViewState = .normal

      // to store the card view top constraint value before the dragging start
      // default is 30 pt from safe area top
      var cardPanStartingTopConstant : CGFloat = 30.0
    var cardPanStartingTopConstraint : CGFloat = 0.0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        let gesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGestureRecognizer(_:)))
        //            panView.addGestureRecognizer(gesture)
        
        // add pan gesture recognizer to the view controller's view (the whole screen)
        let viewPan = UIPanGestureRecognizer(target: self, action: #selector(viewPanned(_:)))
        
        // by default iOS will delay the touch before recording the drag/pan information
        // we want the drag gesture to be recorded down immediately, hence setting no delay
        viewPan.delaysTouchesBegan = false
        viewPan.delaysTouchesEnded = false
        
        self.view.addGestureRecognizer(viewPan)
        
    }
    private func showCard(atState: CardViewState = .normal) {
       
      // ensure there's no pending layout changes before animation runs
      self.view.layoutIfNeeded()
      
      // set the new top constraint value for card view
      // card view won't move up just yet, we need to call layoutIfNeeded()
      // to tell the app to refresh the frame/position of card view
      if let safeAreaHeight = UIApplication.shared.keyWindow?.safeAreaLayoutGuide.layoutFrame.size.height,
        let bottomPadding = UIApplication.shared.keyWindow?.safeAreaInsets.bottom {
        
        if atState == .expanded {
          // if state is expanded, top constraint is 30pt away from safe area top
          topConstraint.constant = 30.0
        } else {
            topConstraint.constant = (safeAreaHeight + bottomPadding) / 2.0
        }
        
        cardPanStartingTopConstraint = topConstraint.constant
      }
      
      // move card up from bottom
      // create a new property animator
      let showCard = UIViewPropertyAnimator(duration: 0.25, curve: .easeIn, animations: {
        self.view.layoutIfNeeded()
      })
      
      // show dimmer view
      // this will animate the dimmerView alpha together with the card move up animation
//      showCard.addAnimations {
//        self.dimmerView.alpha = 0.7
//      }
      
      // run the animation
      showCard.startAnimation()
    }
    
    @IBAction func viewPanned(_ panRecognizer: UIPanGestureRecognizer) {
      // how much has user dragged
      let translation = panRecognizer.translation(in: self.view)
      
      switch panRecognizer.state {
      case .began:
        cardPanStartingTopConstant = topConstraint.constant
      case .changed :
        if self.cardPanStartingTopConstant + translation.y > 30.0 {
            self.topConstraint.constant = self.cardPanStartingTopConstraint + translation.y
        }
      case .ended :
        if let safeAreaHeight = UIApplication.shared.keyWindow?.safeAreaLayoutGuide.layoutFrame.size.height,
          let bottomPadding = UIApplication.shared.keyWindow?.safeAreaInsets.bottom {
          
          if self.topConstraint.constant < (safeAreaHeight + bottomPadding) * 0.25 {
            // show the card at expanded state
            showCard(atState: .expanded)
          } else if self.topConstraint.constant < (safeAreaHeight) - 70 {
            // show the card at normal state
            showCard(atState: .normal)
          }
        }
      default:
        break
      }
    }
    
    
    
    //    private var originalX: CGFloat = 0.0
    //    private var originalY: CGFloat = 0.0
    
    //    @objc func handlePanGestureRecognizer(_ pan: UIPanGestureRecognizer) {
    //
    //        guard let panView = pan.view else {
    //            return
    //        }
    //
    //        // Make sure, the gastureRecognizer's view the topmost view
    //        self.view.bringSubviewToFront(panView)
    //
    //        // Find coordinates of the gesture recognizer event on the screen
    //        var translatedPoint = pan.translation(in: self.view)
    //
    //        // The dragging has just started, lets remember the inital positions
    //        //let translation = pan.translation(in: panView)
    //
    //        if pan.state == .began {
    //            originalX = panView.center.x
    //            originalY = panView.center.y
    //            //print("here", originalX, originalY)
    //            //panHeight.constant = panHeight.constant + translation.y
    //            pan.setTranslation(CGPoint.zero, in: panView)
    //        }
    //
    //        // increase the coordinates of the gesturerecognizers view by the dragging movement's y coordinate
    //        translatedPoint = CGPoint(x: originalX, y: originalY + translatedPoint.y)
    //
    //        UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseInOut], animations: {
    //            pan.view?.center = translatedPoint
    //        } , completion: nil)
    //
    //
    //    }
    
}
