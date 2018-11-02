//
//  VouTePagarViewController.swift
//  BitchBetterHaveMyMoney
//
//  Created by Ada 2018 on 16/05/18.
//  Copyright © 2018 Academy. All rights reserved.
//

import UIKit

class VouTePagarViewController: UIViewController {

    @IBOutlet weak var labelValorTotal: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var box: UIView!
    @IBOutlet weak var boxLabel: UILabel!
    
    var pessoasQueEuDevo = [Pessoa]()
    
    let currencyFormatter = NumberFormatter()
    let userDefaults = UserDefaults.standard
    
    var valorTotal = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale(identifier: "pt_BR")
        currencyFormatter.currencySymbol = ""
        
        if let data = userDefaults.data(forKey: "pessoasQueEuDevo"){
            let decoder = JSONDecoder()
            pessoasQueEuDevo = try! decoder.decode([Pessoa].self, from: data)
            
            let valorString = currencyFormatter.string(from: somarDividas() as NSNumber)
            labelValorTotal.text = valorString
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib.init(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell3")
        
        box.isHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToAddDividaIllPayYou" {
            let addView = segue.destination as! AddDividaViewController
            addView.delegate = self
        }
        else if segue.identifier == "goToDividasDetalhadas2" {
            let nextView = segue.destination as! DividaDetalheViewController
            nextView.pessoa = sender as? Pessoa
            nextView.backgroundGradiente = #imageLiteral(resourceName: "red-gradient-back")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func somarDividas() -> Double {
        var soma = 0.0
        
        for pessoa in pessoasQueEuDevo {
            soma += pessoa.dividas.reduce(0) {$0 + $1.valor}
        }
        
        return soma
    }

}

extension VouTePagarViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pessoasQueEuDevo.count
    }
 
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell3", for: indexPath) as! CustomTableViewCell
        
        let pessoa = pessoasQueEuDevo[indexPath.row]
        
        cell.selectionStyle = .none
        
        cell.nomePessoa.text = pessoa.nome
        cell.valorTotal.textColor = #colorLiteral(red: 1, green: 0.231372549, blue: 0.1882352941, alpha: 1)
        
        let valorDividas = pessoa.dividas.reduce(0) {$0 + $1.valor}
        cell.valorTotal.text = String(valorDividas)
        
        cell.arrow.image = #imageLiteral(resourceName: "red-arrow")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pessoa = pessoasQueEuDevo[indexPath.row]
        performSegue(withIdentifier: "goToDividasDetalhadas2", sender: pessoa)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                let alert = UIAlertController(title: nil, message: "Is this debt really paid?", preferredStyle: .alert)
                let clearAction = UIAlertAction(title: "Yes", style: .destructive) { (alert: UIAlertAction!) -> Void in
                    self.pessoasQueEuDevo.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    
                    tableView.reloadData()
                    
                    let valorString = self.currencyFormatter.string(from: self.somarDividas() as NSNumber)
                    self.labelValorTotal.text = valorString
                    
                    let encodedData = try? JSONEncoder().encode(self.pessoasQueEuDevo)
                    self.userDefaults.set(encodedData, forKey: "pessoasQueEuDevo")
                }
                let cancelAction = UIAlertAction(title: "No", style: .default) { (alert: UIAlertAction!) -> Void in
                    
                }
                
                alert.addAction(clearAction)
                alert.addAction(cancelAction)
                
                present(alert, animated: true, completion:nil)
                
            }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (tableView.bounds).intersects(labelValorTotal.frame) == false {
            let valorString = currencyFormatter.string(from: somarDividas() as NSNumber)
            boxLabel.text = valorString
            box.isHidden = false
        } else{
            box.isHidden = true
        }
    }
}

extension VouTePagarViewController: AddDividaDelegate {
    func novaDivida(divida: Divida, nome: String) {
        if let index = pessoasQueEuDevo.index(where: {$0.nome == nome}){
            pessoasQueEuDevo[index].dividas.append(divida)
            valorTotal += pessoasQueEuDevo[index].dividas.reduce(0) {$0 + $1.valor}
        } else {
            let novaPessoa = Pessoa(nome: nome, dividas: [divida])
            pessoasQueEuDevo.append(novaPessoa)
            valorTotal += novaPessoa.dividas .reduce(0) {$0 + $1.valor}
        }
        
        tableView.reloadData()
        
        let valorString = self.currencyFormatter.string(from: self.somarDividas() as NSNumber)
        self.labelValorTotal.text = valorString
        
        let encodedData = try? JSONEncoder().encode(self.pessoasQueEuDevo)
        self.userDefaults.set(encodedData, forKey: "pessoasQueEuDevo")
        
    }
}
