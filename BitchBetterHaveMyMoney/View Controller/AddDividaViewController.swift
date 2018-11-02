//
//  AddDividaViewController.swift
//  BitchBetterHaveMyMoney
//
//  Created by Ada 2018 on 15/05/18.
//  Copyright © 2018 Academy. All rights reserved.
//

import UIKit

class AddDividaViewController: UIViewController {

    @IBOutlet weak var modalView: UIView! {
        didSet {
            modalView.layer.cornerRadius = 10
            modalView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            modalView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var toolbar: UIToolbar!
    
    @IBOutlet weak var textFieldNome: UITextField!
    @IBOutlet weak var textFieldValor: UITextField!
    @IBOutlet weak var textFieldMotivo: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var delegate: AddDividaDelegate?
    
    var initialTouchPoint: CGPoint = CGPoint(x: 0,y: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerHandler(_:)))
        modalView.addGestureRecognizer(panGestureRecognizer)
        
        let toolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 30))
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))
        
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        toolbar.setShadowImage(UIImage(), forToolbarPosition: .any)
        
        self.textFieldValor.inputAccessoryView = toolbar
        self.textFieldMotivo.inputAccessoryView = toolbar
        self.textFieldNome.inputAccessoryView = toolbar
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
    }
    
    
    @objc func doneButtonAction() {
        self.view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2985070634)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func addDivida(_ sender: Any) {
        let nome = textFieldNome.text
        let valor = Double(textFieldValor.text!)
        let motivo = textFieldMotivo.text
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        
        let data = formatter.string(from: datePicker.date)
        
        let novaDivida = Divida(valor: valor!, motivo: motivo!, data: data) //fazer um alert
        
        delegate?.novaDivida(divida: novaDivida, nome: nome!)
        
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func panGestureRecognizerHandler(_ sender: UIPanGestureRecognizer) {
        let touchPoint = sender.location(in: self.view?.window)
        
        if sender.state == UIGestureRecognizerState.began {
            view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            initialTouchPoint = touchPoint
        } else if sender.state == UIGestureRecognizerState.changed {
            if touchPoint.y - initialTouchPoint.y > 0 {
                self.view.frame = CGRect(x: 0, y: touchPoint.y - initialTouchPoint.y, width: self.view.frame.size.width, height: self.view.frame.size.height)
            }
        } else if sender.state == UIGestureRecognizerState.ended || sender.state == UIGestureRecognizerState.cancelled {
            if touchPoint.y - initialTouchPoint.y > 200 {
                self.dismiss(animated: true, completion: nil)
            } else {                UIView.animate(withDuration: 0.5, animations: {
                    self.view.frame.origin = CGPoint(x: 0, y: 0)
                
            }, completion: { (finished: Bool) in
                self.view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2985070634)
            })
            }
        }
    }
    
}

extension AddDividaViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    @objc func keyboardSeraHide(notification: Notification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y = keyboardSize.height - keyboardSize.height
            }
        }
    }
    
    @objc func keyboardSeraShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

}

