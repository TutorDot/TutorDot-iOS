//
//  JournalDataCell.swift
//  TutorDot_iOS
//
//  Created by 최인정 on 2020/07/05.
//  Copyright © 2020 Sehwa Ryu. All rights reserved.
//

import UIKit

class JournalDataCell: UITableViewCell {

    static let identifier: String = "JournalDataCell"

    
    @IBOutlet weak var classColorImage: UIImageView!
    @IBOutlet weak var classTitle: UILabel!
    @IBOutlet weak var lessonLabel: UILabel!
    @IBOutlet weak var homeworkLabel: UILabel!
    @IBOutlet weak var classCount: UILabel!
    @IBOutlet weak var journalView: UIView!
    @IBOutlet weak var hwCheckImage: UIButton!
    var diaryId: Int = 0
    var classDate: String = ""
    var homeworkCheck: Int = 0 //1이면 동그라미, 3이면 엑스
    let hwImage: [String] = ["", "hwUnCheck", "", "hwUnCheck"]
    override func awakeFromNib() {
        super.awakeFromNib()
        setJournalView()
    }

    func setJournalView(){
        journalView.layer.cornerRadius = 13
       
    }
    
    func setNoteCell(_ color: String, _ title: String, _ times: Int, _ hour: Int, _ lesson: String, _ homework: String, _ hwCheck: Int){
        
        classColorImage.image = UIImage(named: color)
        classTitle.text = title
        lessonLabel.text = lesson
        homeworkLabel.text = homework
        classCount.text = "\(times)" + "회차" + " / " + "\(hour)" + "시간"
        homeworkCheck = hwCheck
        //hwCheckImage.imageView?.image = UIImage(named: hwImage[homeworkCheck])
        
    }
    

    
    
    
    
}
