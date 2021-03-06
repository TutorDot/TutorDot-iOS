//
//  OnboardingNewVC.swift
//  TutorDot_iOS
//
//  Created by Sehwa Ryu on 2020/11/28.
//  Copyright © 2020 Sehwa Ryu. All rights reserved.
//

import UIKit

class OnboardingNewVC: UIViewController {
    static let identifier: String = "OnboardingNewVC"
    
    @IBOutlet weak var onboardingCollectionView: UICollectionView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    private var onboardingImageList : [OnboardingImage] = []
    @IBOutlet weak var collectionViewRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionViewLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionViewToTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var pageControltoCollectionView: NSLayoutConstraint!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var collectionViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var signUpButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var signUpButtonToPageControlConstraint: NSLayoutConstraint!
    @IBOutlet weak var signUpButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(onboardingCollectionView.frame.size.width, onboardingCollectionView.frame.size.height, "높이 너비1")
        onboardingCollectionView.delegate = self
        onboardingCollectionView.dataSource = self
        setImage()
        pageControl.pageIndicatorTintColor = .lightPeriwinkle
        pageControl.currentPageIndicatorTintColor = UIColor.battleshipGrey
        setHeight()
        setView()
        signUpButton.isHidden = true
        checkLastPage()
        print(self.view.frame.size.height,self.view.frame.size.width, "11 pro max")
        // 11 pro max : 896
        // 12 pro : 844, 390
        // promax
        if self.view.frame.size.height > 850 {
            onboardingCollectionView.frame.size.height = 551
            onboardingCollectionView.frame.size.width = 414
            collectionViewHeightConstraint.constant = 551
            collectionViewWidthConstraint.constant = 414
            pageControltoCollectionView.constant = 60
        // se
        } else if self.view.frame.size.height < 700 {
            onboardingCollectionView.frame.size.height = 502
            onboardingCollectionView.frame.size.width = 375
            pageControltoCollectionView.constant = 15
        // 12 pro
        } else if self.view.frame.size.height == 844 && self.view.frame.size.width == 390 {
            print("success")
            onboardingCollectionView.frame.size.height = 521
            onboardingCollectionView.frame.size.width = 390
            collectionViewHeightConstraint.constant = 521
            collectionViewWidthConstraint.constant = 390
            pageControltoCollectionView.constant = 40
        // 11 pro
        } else {
            onboardingCollectionView.frame.size.height = 502
            onboardingCollectionView.frame.size.width = 375
            pageControltoCollectionView.constant = 40
        }
        //
        print(onboardingCollectionView.frame.size.width, onboardingCollectionView.frame.size.height, "높이 너비2")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if self.view.frame.size.height > 850 {
            onboardingCollectionView.frame.size.height = 551
            onboardingCollectionView.frame.size.width = 414
        } else {
            onboardingCollectionView.frame.size.height = 502
            onboardingCollectionView.frame.size.width = 375
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if self.view.frame.size.height > 850 {
            onboardingCollectionView.frame.size.height = 551
            onboardingCollectionView.frame.size.width = 414
        } else {
            onboardingCollectionView.frame.size.height = 502
            onboardingCollectionView.frame.size.width = 375
        }
        print(onboardingCollectionView.frame.size.width, onboardingCollectionView.frame.size.height, "높이 너비3")
    }
    
    func setHeight() {
        // SE
        if (self.view.frame.size.height) < 700 {
            onboardingCollectionView.frame.size.height = 510
            collectionViewToTopConstraint.constant = 60
        } else if (self.view.frame.size.height) > 700 && (self.view.frame.size.height) < 800 {
            onboardingCollectionView.frame.size.height = 510
            collectionViewToTopConstraint.constant = 100
            pageControltoCollectionView.constant = 40
            
        } else {
            onboardingCollectionView.frame.size.height = 551
            onboardingCollectionView.frame.size.width = 414
        }
    }
    
    func setView() {
        signUpButton.backgroundColor = UIColor.softBlue
        signUpButton.titleLabel?.textColor = UIColor.white
        signUpButton.layer.cornerRadius = 10
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        // 11 pro max
        if self.view.frame.size.height > 850 {
            onboardingCollectionView.frame.size.height = 551
            onboardingCollectionView.frame.size.width = 414
        // 12 pro
        } else if self.view.frame.size.height == 844 && self.view.frame.size.width == 390 {
            onboardingCollectionView.frame.size.height = 521
            onboardingCollectionView.frame.size.width = 390
        // SE, 11 pro
        } else {
            onboardingCollectionView.frame.size.height = 502
            onboardingCollectionView.frame.size.width = 375
        }
        let width = onboardingCollectionView.frame.size.width
        let height = onboardingCollectionView.frame.size.height
        print(width, height, "높이너비 셀")
        layout.itemSize = CGSize(width: width, height: height)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        onboardingCollectionView.collectionViewLayout = layout
    }
    
    func setImage() {
        let image1 = OnboardingImage(imageName: "onboardingImgStart")
        let image2 = OnboardingImage(imageName: "onboardingImgCalender")
        let image3 = OnboardingImage(imageName: "onboardingImgClassLog")
        let image4 = OnboardingImage(imageName: "onboardingImgQuestion")
        let image5 = OnboardingImage(imageName: "onboardingImgNotice")
        
        onboardingImageList = [image1, image2, image3, image4, image5]
    }
    
    
    @IBAction func signUpButton(_ sender: Any) {
        let tabbarStoryboard = UIStoryboard.init(name: "Login", bundle: nil)
        guard let mainView = tabbarStoryboard.instantiateViewController(identifier:"LoginVC") as?
                LoginVC else { return }
        mainView.modalPresentationStyle = .fullScreen
        self.present(mainView, animated: true, completion: nil)
    }

    
    func checkLastPage(){
        
    }
    
    
}

extension OnboardingNewVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pageControl.numberOfPages = onboardingImageList.count
        return onboardingImageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let imageCell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingNewCollectionViewCell.identifier, for: indexPath) as? OnboardingNewCollectionViewCell else { return UICollectionViewCell()}
        imageCell.set(onboardingImageList[indexPath.row])
        return imageCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if self.view.frame.size.height > 850 {
            pageControl?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
            print(scrollView.contentOffset.x, scrollView.frame.width, self.view.frame.size.height, "여기")
        } else {
            pageControl?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
            print(scrollView.contentOffset.x, scrollView.frame.width, self.view.frame.size.height, "여기")
        }
        
        
        print(pageControl.currentPage, "지금 페이지")
        // 마지막 페이지일때
        if pageControl.currentPage == pageControl.numberOfPages - 1 {
            signUpButton.isHidden = false
            // pro
            if (self.view.frame.size.height) > 700 && self.view.frame.size.height < 840 {
                collectionViewToTopConstraint.constant = 60
                pageControltoCollectionView.constant = 20
            //pro max
            } else if self.view.frame.size.height > 850 {
                collectionViewToTopConstraint.constant = 80
                pageControltoCollectionView.constant = 20
            // 12 pro
            } else if self.view.frame.size.height == 844 && self.view.frame.size.width == 390 {
                collectionViewToTopConstraint.constant = 100
                pageControltoCollectionView.constant = 30
            // SE
            } else {
                collectionViewToTopConstraint.constant = 30
                pageControltoCollectionView.constant = 5
                signUpButtonToPageControlConstraint.constant = 7
            }
        } else {
            signUpButton.isHidden = true
            //pro
            if (self.view.frame.size.height) > 700 && (self.view.frame.size.height) < 840 {
                onboardingCollectionView.frame.size.height = 510
                collectionViewToTopConstraint.constant = 100
                pageControltoCollectionView.constant = 40
            } else if self.view.frame.size.height > 850{
                onboardingCollectionView.frame.size.height = 551
                collectionViewToTopConstraint.constant = 100
                pageControltoCollectionView.constant = 60
            // 12 pro
            } else if self.view.frame.size.height == 844 && self.view.frame.size.width == 390{
                onboardingCollectionView.frame.size.height = 521
                collectionViewToTopConstraint.constant = 120
                pageControltoCollectionView.constant = 40
            } else {
                onboardingCollectionView.frame.size.height = 510
                collectionViewToTopConstraint.constant = 60
                pageControltoCollectionView.constant = 15
            }
        }
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.0, options: [], animations: {
            self.view.layoutIfNeeded()
        })
        
    }
    
    
    
    
}
