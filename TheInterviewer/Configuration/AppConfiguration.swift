//
//  AppConfiguration.swift
//  TheInterviewer
//
//  Created by Athos Lagemann on 06/08/19.
//  Copyright © 2019 Athos Lagemann. All rights reserved.
//

import Foundation
import UIKit

final class AppConfiguration {
    
    private init() { }
    static var shared: AppConfiguration = AppConfiguration()

    // Placeholders
    enum Placeholders: String {
        case answer = "Resposta..."
    }
    
    // Colors
    static var mainColor: UIColor = UIColor(hex: 0x7851A9)
}
