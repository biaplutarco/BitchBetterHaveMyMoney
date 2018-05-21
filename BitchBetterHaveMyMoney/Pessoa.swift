//
//  Pessoa.swift
//  BitchBetterHaveMyMoney
//
//  Created by Ada 2018 on 14/05/18.
//  Copyright © 2018 Academy. All rights reserved.
//

import Foundation

struct Pessoa: Codable {
    var nome: String
    var dividas: [Divida]
}
