//
//  PopUpClassesTableViewCell.swift
//  TutorDot_iOS
//
//  Created by 최인정 on 2020/11/11.
//  Copyright © 2020 Sehwa Ryu. All rights reserved.
//

import UIKit


class PopUpClassesTableViewCell: UITableViewCell {

    static let identifier: String = "popUpClassesTableViewCell"
    
    @IBOutlet weak var popUpLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
}

