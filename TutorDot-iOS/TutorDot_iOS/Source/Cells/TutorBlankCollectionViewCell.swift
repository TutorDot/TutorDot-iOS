//
//  TutorBlankCollectionViewCell.swift
//  TutorDot_iOS
//
//  Created by Sehwa Ryu on 2020/07/08.
//  Copyright © 2020 Sehwa Ryu. All rights reserved.
//

import UIKit

class TutorBlankCollectionViewCell: UICollectionViewCell {

    static let identifier: String = "TutorBlankCollectionViewCell"
    
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        firstLabel.textColor = UIColor.brownishGrey
        secondLabel.textColor = UIColor.brownishGrey
    }
    
    
    class func cellForCollectionView(collectionView: UICollectionView, indexPath: IndexPath) -> TutorBlankCollectionViewCell {
        let TutorBlankCollectionViewCellIdentifier = "TutorBlankCollectionViewCell"
        
        collectionView.register(UINib(nibName: "TutorBlankCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: TutorBlankCollectionViewCellIdentifier)
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TutorBlankCollectionViewCellIdentifier, for: indexPath) as! TutorBlankCollectionViewCell
        return cell
    }

}
