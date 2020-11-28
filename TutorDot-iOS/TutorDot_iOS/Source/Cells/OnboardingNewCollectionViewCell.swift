//
//  OnboardingNewCollectionViewCell.swift
//  TutorDot_iOS
//
//  Created by Sehwa Ryu on 2020/11/28.
//  Copyright © 2020 Sehwa Ryu. All rights reserved.
//

import UIKit

class OnboardingNewCollectionViewCell: UICollectionViewCell {
    static let identifier: String = "OnboardingNewCollectionViewCell"
    
    @IBOutlet weak var image: UIImageView!
    
    func set(_ onboarding: OnboardingImage) {
        image.image = onboarding.imageName
    }
}
