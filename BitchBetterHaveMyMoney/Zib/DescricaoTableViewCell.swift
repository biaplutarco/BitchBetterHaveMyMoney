//
//  DescricaoTableViewCell.swift
//  BitchBetterHaveMyMoney
//
//  Created by Ada 2018 on 16/05/18.
//  Copyright © 2018 Academy. All rights reserved.
//

import UIKit

class DescricaoTableViewCell: UITableViewCell {

    @IBOutlet weak var motivoLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var valorLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
