//
//  JournalDataCell.swift
//  TutorDot_iOS
//
//  Created by 최인정 on 2020/07/05.
//  Copyright © 2020 Sehwa Ryu. All rights reserved.
//

import UIKit
import Kingfisher

class JournalDataCell: UITableViewCell {

    static let identifier: String = "JournalDataCell"
    let defaultLesson: String  = "진도를 입력해주세요"
    let defaultHW: String = "숙제를 입력해주세요"
    let widthDefault: CGFloat = 375 //아이폰 11 Pro 기준 가로 길이
    
    @IBOutlet weak var classColorImage: UIImageView!
    @IBOutlet weak var classTitle: UILabel!
    @IBOutlet weak var lessonLabel: UILabel!
    @IBOutlet weak var homeworkLabel: UILabel!
    @IBOutlet weak var classCount: UILabel!
    
    @IBOutlet weak var tuteeImageView: UIImageView!
    @IBOutlet weak var journalView: UIView! {
        didSet {
            //그림자 divice별 밸런스 맞추기
            let weight: CGFloat = 1.89 * (UIScreen.main.bounds.width / widthDefault)
            let radius: CGFloat = journalView.frame.width / 2.1
            let shadowPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: weight * radius, height: journalView.frame.height), cornerRadius: 13)
            
            journalView.layer.cornerRadius = 13
            
            journalView.layer.masksToBounds = false
            journalView.layer.shadowColor = UIColor.lightGray.cgColor
            journalView.layer.shadowOffset = CGSize(width: 4, height: 4)
            journalView.layer.shadowRadius = 3
            journalView.layer.shadowOpacity = 0.3
            journalView.layer.shadowPath = shadowPath.cgPath
            
           
        }
    }
    @IBOutlet weak var hwCheckImage: UIButton!
    var diaryId: Int = 0
    var classDate: String = ""
    var homeworkCheck: Int = 0 //1이면 동그라미, 3이면 엑스
    let hwImage: [String] = ["", "hwCheck", "", "hwUnCheck"]
    override func awakeFromNib() {
        super.awakeFromNib()
        tuteeImageView.layer.cornerRadius  = tuteeImageView.frame.width / 2
    }


    
    func setNoteCell(_ color: String, _ profileUrl: String, _ title: String, _ times: Int, _ hour: Int, _ lesson: String, _ homework: String, _ hwCheck: Int){
        
        classColorImage.image = UIImage(named: color)
        classTitle.text = title
        
        if lesson == defaultLesson {
            lessonLabel.text = defaultLesson
            lessonLabel.textColor = UIColor.gray
        } else {
            lessonLabel.text = lesson
            lessonLabel.textColor = UIColor.black
        }
        
        if homework == defaultHW {
            homeworkLabel.text = defaultHW
            homeworkLabel.textColor = UIColor.gray
        } else {
            homeworkLabel.text = homework
            homeworkLabel.textColor = UIColor.black
        }
        
        classCount.text = "\(times)" + "회차" + " / " + "\(hour)" + "시간"
        homeworkCheck = hwCheck
        hwCheckImage.imageView?.image = UIImage(named: hwImage[homeworkCheck])
        
        let url = URL(string: profileUrl)
        self.tuteeImageView.kf.setImage(with: url)
        
        
    }
    

    
    
    
    
}
