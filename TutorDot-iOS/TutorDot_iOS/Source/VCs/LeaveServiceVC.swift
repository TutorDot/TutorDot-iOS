//
//  LeaveServiceVC.swift
//  TutorDot_iOS
//
//  Created by 최인정 on 2020/07/09.
//  Copyright © 2020 Sehwa Ryu. All rights reserved.
//

import UIKit
import os

class LeaveServiceVC: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    let images: [String] = ["servivcebye1ImgIllust", "servivcebye2ImgIllust", "servivcebye3ImgIllust"]
    let titles: [String] = ["저희의 서비스가 부족했나 봐요", "그동안 튜터닷을 이용해주셔서 감사합니다", "언제든 튜터닷을 다시 찾아주세요"]
   
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var serviceLeaveButton: UIButton!
    @IBOutlet weak var cancelButtonBottom: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cancelButton.layer.cornerRadius = 8
        serviceLeaveButton.layer.cornerRadius = 8
        
        setPageControl()
        setButtons()
        
        // Gesture register
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(LeaveServiceVC.respondToSwipeGesture(_:)))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(LeaveServiceVC.respondToSwipeGesture(_:)))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
    }
    
    func setPageControl(){
        pageController.numberOfPages = images.count
        pageController.currentPage = 0
        pageController.pageIndicatorTintColor = UIColor.indicateGray
        pageController.currentPageIndicatorTintColor = UIColor.cornflowerBlue
        
        imageView.image = UIImage(named: images[0])
        titleLabel.text = titles[0]

    }
    
    func setButtons(){
        serviceLeaveButton.isHidden = true
        cancelButtonBottom.constant = 36
    }
    
    @objc func respondToSwipeGesture(_ gesture: UIGestureRecognizer) {
        // 만일 제스쳐가 있다면
        if let swipeGesture = gesture as? UISwipeGestureRecognizer{
                
            // 발생한 이벤트가 각 방향의 스와이프 이벤트라면
            // pageControl이 가르키는 현재 페이지에 해당하는 이미지를 imageView에 할당
            switch swipeGesture.direction {
                case UISwipeGestureRecognizer.Direction.left :
                    pageController.currentPage += 1
                    imageView.image = UIImage(named: images[pageController.currentPage])
                    titleLabel.text = titles[pageController.currentPage]
                   
                case UISwipeGestureRecognizer.Direction.right :
                    pageController.currentPage -= 1
                    imageView.image = UIImage(named: images[pageController.currentPage])
                    titleLabel.text = titles[pageController.currentPage]
                    
                default:
                    break
            }
        }
        checkLastPage()
    }
    @IBAction func nextButtonDidTap(_ sender: Any) {
        pageController.currentPage += 1
        imageView.image = UIImage(named: images[pageController.currentPage])
        titleLabel.text = titles[pageController.currentPage]
        checkLastPage()
    }
    
    @IBAction func pageChanged(_ sender: Any) {
        imageView.image = UIImage(named: images[pageController.currentPage])
        titleLabel.text = titles[pageController.currentPage]
        checkLastPage()
    }
    
    func checkLastPage(){
        if pageController.currentPage == pageController.numberOfPages-1 {
            
            serviceLeaveButton.isHidden = false
            cancelButtonBottom.constant = 94
            nextButton.isHidden = true
        } else {
            serviceLeaveButton.isHidden = true
            cancelButtonBottom.constant = 36
            nextButton.isHidden = false
        }
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.0, options: [], animations: {
            self.view.layoutIfNeeded()
        })
    }
    @IBAction func backButtonDidTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancelButtonDidTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func leaveServiceButtonDidTap(_ sender: Any) {
        
        MypageService.MypageServiceShared.deleteUser() { networkResult in
            switch networkResult {
            case .success:
                
                //login VC로 이동 준비
                let loginStoryboard = UIStoryboard.init(name: "Login", bundle: nil)
                guard let loginVC = loginStoryboard.instantiateViewController(identifier: "LoginVC") as? LoginVC  else { return }
                loginVC.modalPresentationStyle = .fullScreen
                
                
                // 서비스 탈퇴 성공 alert
                let alert = UIAlertController(title: "완료", message: "서비스 탈퇴가 완료되었습니다.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: {_ in self.present(loginVC, animated: true, completion: nil)}))
                
                self.present(alert, animated: true, completion: nil)
                
                        
            case .requestErr(let message):
                os_log(message as! StaticString , log: .mypage)
            case .pathErr:
                os_log("PathErr", log: .mypage)
            case .networkFail:
                os_log("networkFail", log: .mypage)
            case .serverErr:
                os_log("ServerErr", log: .mypage)

            }
            
        }

    }
    
}
