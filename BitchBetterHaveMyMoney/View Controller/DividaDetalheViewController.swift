//
//  DividaDetalheViewController.swift
//  BitchBetterHaveMyMoney
//
//  Created by Ada 2018 on 15/05/18.
//  Copyright © 2018 Academy. All rights reserved.
//

import UIKit

class DividaDetalheViewController: UIViewController {
    
    var pessoa: Pessoa?
    var backgroundGradiente: UIImage?
    var dividas: [Divida]?
    
    @IBOutlet weak var backgroundGradient: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let nome = pessoa?.nome {
            navigationItem.title = nome
        }
        
        tableView.register(UINib.init(nibName: "DescricaoTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell2")
        
        dividas = pessoa?.dividas
        
        tableView.delegate = self
        tableView.dataSource = self
        
        backgroundGradient.image = backgroundGradiente
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension DividaDetalheViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dividas!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath) as! DescricaoTableViewCell
        
        let divida = dividas![indexPath.row]
        
        cell.motivoLabel.text = divida.motivo
        cell.dataLabel.text = divida.data
        cell.valorLabel.text = String(divida.valor)
        
        return cell
    }
}
