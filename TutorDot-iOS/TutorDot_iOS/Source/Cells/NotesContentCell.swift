//
//  NotesContentCell.swift
//  TutorDot_iOS
//
//  Created by 최인정 on 2020/10/14.
//  Copyright © 2020 Sehwa Ryu. All rights reserved.
//

import UIKit

class NotesContentCell: UICollectionViewCell {

    // MARK: Cell Objects Outlet
    @IBOutlet weak var noteContentStackView: UIStackView!
    @IBOutlet weak var classColor: UIImageView!
    @IBOutlet weak var classTitle: UILabel!
    @IBOutlet weak var classTimes: UILabel!
    @IBOutlet weak var classLesson1: UILabel!
    @IBOutlet weak var classLesson2: UILabel!
    @IBOutlet weak var classHW1: UILabel!
    @IBOutlet weak var classHW2: UILabel!
    @IBOutlet weak var classHW3: UILabel!
    @IBOutlet weak var tutorProfile: UIImageView!
    @IBOutlet weak var backView: UIView!
    
    
    // MARK: variables and constant
    var lesson: [String] = []
    var homeworks: [String] = []
    
    let viewRadius: CGFloat = 13.0
//    let lesson1: UIView = noteContentStackView.arrangedSubviews[2]
    
    
    // MARK: awake From Nib
    override func awakeFromNib() {
        super.awakeFromNib()
        backView.layer.cornerRadius = viewRadius
    }
    
    func setNotesContent(){
        //진도 개수 확인
        //숙제 개수 확인
        //stack view hide 할 부분 hide시키기
        //stack view 개수 :
    }
    
    
}
