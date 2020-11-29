//
//  BlankNoteCell.swift
//  TutorDot_iOS
//
//  Created by 최인정 on 2020/11/18.
//  Copyright © 2020 Sehwa Ryu. All rights reserved.
//

import UIKit

class BlankNoteCell: UICollectionViewCell {

    static let identifier: String = "BlankNoteCell"
    
    @IBOutlet weak var blankImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var topConstraints: NSLayoutConstraint!
    var mult: CGFloat = UIScreen.main.bounds.height / 812
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.textColor = UIColor.BlankTextBlack
        subtitleLabel.textColor = UIColor.BlankTextBlack
        background.layer.backgroundColor = UIColor.whiteTwo.cgColor
        //topConstraints = blankImage.topAnchor.constraint(equalTo: topAnchor, constant: 137*mult)
        topConstraints.constant *= mult
    }

    
    
}
