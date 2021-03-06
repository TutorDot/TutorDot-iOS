//
//  CalendarCollectionViewCell.swift
//  TutorDot_iOS
//
//  Created by Sehwa Ryu on 02/07/2020.
//  Copyright © 2020 Sehwa Ryu. All rights reserved.
//

import UIKit

class CalendarCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    @IBOutlet weak var imageContainer: UIStackView!
    var classId: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dateView.layer.cornerRadius = dateView.frame.width/2.1
        dateView.clipsToBounds = true
        dateView.backgroundColor = UIColor.white
        
    }

    func set (_ calendarInformation: Tutor) {
        image1.image = UIImage(named:calendarInformation.color)
        image3.image = UIImage(named:calendarInformation.color)
        image2.image = UIImage(named:calendarInformation.color)
        dateLabel.text = calendarInformation.classDate
        
    
    }
    
    
    
    // XIB 연결해주기
    class func cellForCollectionView(collectionView: UICollectionView, indexPath: IndexPath) -> CalendarCollectionViewCell {
        let CalendarCollectionViewCellIdentifier = "CalendarCollectionViewCellIdentifier"
        
        collectionView.register(UINib(nibName: "CalendarCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: CalendarCollectionViewCellIdentifier)
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarCollectionViewCellIdentifier, for: indexPath) as! CalendarCollectionViewCell
        return cell
    }
    
    

}
