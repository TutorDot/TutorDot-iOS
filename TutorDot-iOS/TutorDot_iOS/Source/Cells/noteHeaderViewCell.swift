//
//  noteHeaderViewCell.swift
//  TutorDot_iOS
//
//  Created by 최인정 on 2020/11/29.
//  Copyright © 2020 Sehwa Ryu. All rights reserved.
//

import UIKit

class noteHeaderViewCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    class func cellForCollectionView(collectionView: UICollectionView, indexPath: IndexPath) -> noteHeaderViewCell {
        let noteHeaderCollectionViewCellIdentifier = "noteHeaderViewCell"
        
        collectionView.register(UINib(nibName: "noteHeaderViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: noteHeaderCollectionViewCellIdentifier)
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: noteHeaderCollectionViewCellIdentifier, for: indexPath) as! noteHeaderViewCell
        
        return cell
    }
    

}
