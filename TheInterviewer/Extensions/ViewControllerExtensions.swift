//
//  ViewController.swift
//  TheInterviewer
//
//  Created by Athos Lagemann on 28/08/19.
//  Copyright © 2019 Athos Lagemann. All rights reserved.
//

import UIKit

struct AlertBundle {
    let title: String
    let details: String?
    let options: [AlertOption]
}

struct AlertOption {
    let title: String
    let style: UIAlertAction.Style
    let completion: (UIAlertAction) -> ()
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func presentAlert(_ bundle: AlertBundle) {
        let alertController = UIAlertController(title: bundle.title, message: bundle.details, preferredStyle: .alert)
        bundle.options.forEach { option in
            let action = UIAlertAction(title: option.title,
                                       style: option.style,
                                       handler: option.completion)
            alertController.addAction(action)
        }
        
        present(alertController, animated: true)
    }
}
