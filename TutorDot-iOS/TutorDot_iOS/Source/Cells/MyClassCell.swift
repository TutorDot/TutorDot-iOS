//
//  MyClassCell.swift
//  TutorDot_iOS
//
//  Created by 최인정 on 2020/07/08.
//  Copyright © 2020 Sehwa Ryu. All rights reserved.
//

import UIKit
import os


class MyClassCell: UICollectionViewCell {
    static let identifier: String = "MyClassCell"
    var myRoleSet: String? = ""
    @IBOutlet weak var myClassView: UIView!
    @IBOutlet weak var classColor: UIImageView!
    @IBOutlet weak var classTitle: UILabel!
    
    @IBOutlet weak var classInfo: UILabel!
    @IBOutlet weak var TuteeImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        myClassView.layer.cornerRadius = 7
        TuteeImage.layer.cornerRadius = TuteeImage.frame.width / 2
    }
    
    func setMyClassInfo(classColor : String, classTitle: String, Tutee: String, classTime: [SchedulesData]){
        self.classColor.image = UIImage(named: classColor)
        self.classTitle.text = classTitle
        
        let url = URL(string: Tutee)
        self.TuteeImage.kf.setImage(with: url)
        
        var timeInfo: String = ""
        for i in 0...classTime.count-1 {
            timeInfo += classTime[i].day + " "
            if i != classTime.count-1 {
                timeInfo += "/ "
            }
        }
        timeInfo += classTime[0].orgStartTime
        timeInfo += "~"
        self.classInfo.text = timeInfo
        
    }
    
}
