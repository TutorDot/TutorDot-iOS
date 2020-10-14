//
//  PopUpTableViewCell.swift
//  TutorDot_iOS
//
//  Created by Sehwa Ryu on 2020/10/14.
//  Copyright © 2020 Sehwa Ryu. All rights reserved.
//

import UIKit

class PopUpTableViewCell: UITableViewCell {

    static let identifier: String = "popUpTableViewCell"
    
    @IBOutlet weak var popUpLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
