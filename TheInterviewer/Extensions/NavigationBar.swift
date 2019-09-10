//
//  NavigationBar.swift
//  TheInterviewer
//
//  Created by Athos Lagemann on 10/09/19.
//  Copyright © 2019 Athos Lagemann. All rights reserved.
//

import UIKit

extension UINavigationBar {
    func setupNavigationBar() {
        self.prefersLargeTitles = true
        removeBottomLine()
    }
    
    func removeBottomLine() {
        shadowImage = UIImage()
        setBackgroundImage(UIImage(), for: .default)
    }
}
