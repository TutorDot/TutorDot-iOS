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
    
    @IBOutlet weak var signUpButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var signUpButtonToPageControlConstraint: NSLayoutConstraint!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onboardingCollectionView.delegate = self
        onboardingCollectionView.dataSource = self
        setImage()
        pageControl.pageIndicatorTintColor = .lightPeriwinkle
        pageControl.currentPageIndicatorTintColor = UIColor.battleshipGrey
        setHeight()
        setView()
    }
    
    func setHeight() {
        if (self.view.frame.size.height) < 700 {
            collectionViewToTopConstraint.constant = 35
            signUpButtonHeight.constant = 20
            
        } else {
            signUpButtonHeight.constant = 40
            collectionViewToTopConstraint.constant = 70

        }
    }
    
    func setView() {
        signUpButton.backgroundColor = UIColor.softBlue
        signUpButton.titleLabel?.textColor = UIColor.white
        signUpButton.layer.cornerRadius = 10
    }
    
    func setImage() {
        let image1 = OnboardingImage(imageName: "onboardingImgStart")
        let image2 = OnboardingImage(imageName: "onboardingImgCalender")
        let image3 = OnboardingImage(imageName: "onboardingImgClassLog")
        let image4 = OnboardingImage(imageName: "onboardingImgQuestion")
        let image5 = OnboardingImage(imageName: "onboardingImgNotice")
        
        onboardingImageList = [image1, image2, image3, image4, image5]
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
            pageControl?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    
            
        }
        
    
    
}
