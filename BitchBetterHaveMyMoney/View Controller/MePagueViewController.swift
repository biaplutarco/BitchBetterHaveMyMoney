//
//  MePagueViewController.swift
//  BitchBetterHaveMyMoney
//
//  Created by Ada 2018 on 14/05/18.
//  Copyright © 2018 Academy. All rights reserved.
//

import UIKit

class MePagueViewController: UIViewController {

    @IBOutlet weak var box: UIView!
    @IBOutlet weak var boxLabel: UILabel!
    @IBOutlet weak var labelValorTotalReceber: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var gradientView: UIView!
    
    var pessoasMeDevendo = [Pessoa]()
    var valorTotal = 0.0
    
    let currencyFormatter = NumberFormatter()
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale(identifier: "pt_BR")
        currencyFormatter.currencySymbol = ""
        
        if let data = userDefaults.data(forKey: "pessoasMeDevendo"){
            let decoder = JSONDecoder()
            pessoasMeDevendo = try! decoder.decode([Pessoa].self, from: data)
            
            let valorString = currencyFormatter.string(from: somarDividas() as NSNumber)
            labelValorTotalReceber.text = valorString
        }
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        tableView.register(UINib.init(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        
        box.isHidden = true

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToAddDividaPayMe" {
            let addView = segue.destination as! AddDividaViewController
            addView.delegate = self
        }
        else if segue.identifier == "goToDividasDetalhadas" {
            let nextView = segue.destination as! DividaDetalheViewController
            nextView.pessoa = sender as? Pessoa
            nextView.backgroundGradiente = #imageLiteral(resourceName: "green-gradient-back")
        }
    }
    
    func somarDividas() -> Double {
        var soma = 0.0
        
        for pessoa in pessoasMeDevendo {
            soma += pessoa.dividas.reduce(0) {$0 + $1.valor}
        }
        
        return soma
    }
    
}

extension MePagueViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pessoasMeDevendo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        
        cell.selectionStyle = .none
        
        let pessoa = pessoasMeDevendo[indexPath.row]
        
        cell.nomePessoa.text = pessoa.nome
        
        cell.valorTotal.textColor = #colorLiteral(red: 0.2980392157, green: 0.8509803922, blue: 0.3921568627, alpha: 1)
        let valorTotal = pessoa.dividas.reduce(0) {$0 + $1.valor}
        cell.valorTotal.text = String(valorTotal)
        
        cell.arrow.image = #imageLiteral(resourceName: "green-arrow")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pessoa = pessoasMeDevendo[indexPath.row]
        performSegue(withIdentifier: "goToDividasDetalhadas", sender: pessoa)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alert = UIAlertController(title: nil, message: "Is this debt really paid?", preferredStyle: .alert)
            let clearAction = UIAlertAction(title: "Yes", style: .destructive) { (alert: UIAlertAction!) -> Void in
                self.pessoasMeDevendo.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                
                let valorString = self.currencyFormatter.string(from: self.somarDividas() as NSNumber)
                self.labelValorTotalReceber.text = valorString
                
                let encodedData = try? JSONEncoder().encode(self.pessoasMeDevendo)
                self.userDefaults.set(encodedData, forKey: "pessoasMeDevendo")
            }
            
            let cancelAction = UIAlertAction(title: "No", style: .default) { (alert: UIAlertAction!) -> Void in
            
            }
            
            alert.addAction(clearAction)
            alert.addAction(cancelAction)
            
            present(alert, animated: true, completion:nil)
            
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (tableView.bounds).intersects(labelValorTotalReceber.frame) == false {
            let valorString = currencyFormatter.string(from: somarDividas() as NSNumber)
            boxLabel.text = valorString
            box.isHidden = false
        } else{
            box.isHidden = true
        }
    }
}

extension MePagueViewController: AddDividaDelegate {
    func novaDivida(divida: Divida, nome: String) {
        if let index = pessoasMeDevendo.index(where: {$0.nome == nome}){
            pessoasMeDevendo[index].dividas.append(divida)
            valorTotal += pessoasMeDevendo[index].dividas.reduce(0) {$0 + $1.valor}
            
        } else {
            let novaPessoa = Pessoa(nome: nome, dividas: [divida])
            pessoasMeDevendo.append(novaPessoa)
            valorTotal += novaPessoa.dividas .reduce(0) {$0 + $1.valor}
        }
        
        let valorString = currencyFormatter.string(from: somarDividas() as NSNumber)
        labelValorTotalReceber.text = valorString
        
        let encodedData = try? JSONEncoder().encode(pessoasMeDevendo)
        userDefaults.set(encodedData, forKey: "pessoasMeDevendo")
        
        tableView.reloadData()
        
    }
}


