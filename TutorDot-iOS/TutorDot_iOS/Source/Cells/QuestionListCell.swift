//
//  QuestionListCell.swift
//  TutorDot_iOS
//
//  Created by 최인정 on 2020/11/15.
//  Copyright © 2020 Sehwa Ryu. All rights reserved.
//

import UIKit

class QuestionListCell: UITableViewCell {
    static let identifier: String = "QuestionListCell"
    let viewRadius: CGFloat = 13
    let imageRadius: CGFloat = 10
    
    @IBOutlet weak var listWrapView: UIView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var questionImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setDefault()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setDefault(){
        listWrapView.layer.cornerRadius = viewRadius
        questionImage.layer.cornerRadius = imageRadius
        contentLabel.numberOfLines = 3
        
        let attrString = NSMutableAttributedString(string: contentLabel.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        
        paragraphStyle.lineSpacing = 4
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        contentLabel.attributedText = attrString
    }
}
