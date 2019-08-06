//
//  Extensions.swift
//  TheInterviewer
//
//  Created by Athos Lagemann on 06/08/19.
//  Copyright © 2019 Athos Lagemann. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    /// RGB helper init to the Hex init
    private convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    /// Hexadecimal UIColor init
    ///
    /// Usage: let white = UIColor(rgb: 0xFFFFFF)
    ///        let black = UIColor(rgb: 0x000000)
    ///
    /// - Parameter hex: The hexadecimal to be instantiated
    convenience init(hex: Int) {
        self.init(
            red: (hex >> 16) & 0xFF,
            green: (hex >> 8) & 0xFF,
            blue: hex & 0xFF
        )
    }
}

extension UIFont {
    enum SFProFont: String {
        case text = "Text"
        case display = "Display"
    }
    
    enum FontVariants: String {
        case bold = "Bold"
        case heavy = "Heavy"
        case light = "Light"
        case medium = "Medium"
        case regular = "Regular"
        case semibold = "Semibold"
    }
    
    convenience init?(SFPro font: SFProFont, variant: FontVariants, size: CGFloat) {
        let fontName = "SFPro\(font.rawValue)-\(variant.rawValue)"
        self.init(name: fontName, size: size)
    }
}
