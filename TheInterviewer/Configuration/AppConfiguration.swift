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
    
    enum Color {
        case purple
        
        var color: UIColor {
            switch self {
            case .purple:
                return UIColor(hex: 0x7851A9)
            }
        }
        
        var cgColor: CGColor {
            return color.cgColor
        }
    }
    
    enum Placeholders: String {
        case answer = "Resposta..."
    }
    
    private init() { }
    static var shared: AppConfiguration = AppConfiguration()
    
    // Colors
    static var mainColor: Color = .purple
}
