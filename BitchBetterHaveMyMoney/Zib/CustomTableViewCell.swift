//
//  CustomTableViewCell.swift
//  BitchBetterHaveMyMoney
//
//  Created by Ada 2018 on 14/05/18.
//  Copyright © 2018 Academy. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var nomePessoa: UILabel!
    @IBOutlet weak var valorTotal: UILabel!
    @IBOutlet weak var arrow: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
