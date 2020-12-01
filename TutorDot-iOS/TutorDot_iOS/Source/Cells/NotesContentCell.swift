//
//  NotesContentCell.swift
//  TutorDot_iOS
//
//  Created by 최인정 on 2020/10/14.
//  Copyright © 2020 Sehwa Ryu. All rights reserved.
//

import UIKit
import os

class NotesContentCell: UICollectionViewCell {

    static let identifier: String = "NotesContentCell"
    
    // MARK: Cell Objects Outlet
    @IBOutlet weak var noteContentStackView: UIStackView!
    @IBOutlet weak var classColor: UIImageView!
    @IBOutlet weak var classTitle: UILabel!
    @IBOutlet weak var classTimes: UILabel!
    @IBOutlet weak var classLesson: UILabel!
    @IBOutlet weak var classHW: UILabel!
    @IBOutlet weak var tutorProfile: UIImageView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var hwCheckButton: UIButton!
    
    // MARK: variables and constant
    var lesson: [String] = []
    var homeworks: [String] = []
    let radius: CGFloat = 13.0
    let pick: String = "classlogImgPick"
    let unpick: String = "classlogImgUnpick"
    
    class func cellForCollectionView(collectionView: UICollectionView, indexPath: IndexPath) -> NotesContentCell {
        let noteContentCellIdentifier = "NotesContentCell"
        
        collectionView.register(UINib(nibName: "NotesContentCell", bundle: Bundle.main), forCellWithReuseIdentifier: noteContentCellIdentifier)
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: noteContentCellIdentifier, for: indexPath) as! NotesContentCell
    
        return cell
    }

    // MARK: awake From Nib
    override func awakeFromNib() {
        super.awakeFromNib()

        self.backView.layer.cornerRadius = radius
        tutorProfile.layer.cornerRadius = 21
        
    }
    
    func setNotesContent(){
        //진도 개수 확인
        //숙제 개수 확인
        //stack view hide 할 부분 hide시키기
        //stack view 개수 :
    }
    
    @IBAction func homeworkCheckButtonDidTap(_ sender: Any) {
        os_log("select button", log: .note)
        if hwCheckButton.currentImage == UIImage(named: pick) {
            hwCheckButton.setImage(UIImage(named: unpick), for: .normal)
        } else {
            hwCheckButton.setImage(UIImage(named: pick), for: .normal)
        }
    }
    
    
    
}
