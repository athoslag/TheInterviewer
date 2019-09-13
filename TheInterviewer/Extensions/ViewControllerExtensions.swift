//
//  ViewController.swift
//  TheInterviewer
//
//  Created by Athos Lagemann on 28/08/19.
//  Copyright © 2019 Athos Lagemann. All rights reserved.
//

import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func presentAlert(title: String, detail: String?, optionTitle: String, optionType: UIAlertAction.Style, option: @escaping ()-> ()?, showsCancel: Bool, cancel: @escaping () -> ()?) {
        let alertController = UIAlertController(title: title, message: detail, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: optionTitle, style: optionType) { _ in
            option()
        }
        
        if showsCancel {
            let cancel = UIAlertAction(title: "Cancelar", style: .cancel) { _ in
                cancel()
            }
            
            alertController.addAction(cancel)
        }
        
        alertController.addAction(defaultAction)
        present(alertController, animated: true)
    }
}
