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

    // Interview
    static var interviewType: Interview.InterviewModel = .bpm
    
    // Placeholders
    enum Placeholders: String {
        case answer = "Resposta..."
    }
    
    // Colors
    static var mainColor: UIColor = .royalPurple
}

extension UIColor {
    static let royalPurple = UIColor(hex: 0x7851A9)
    static let navyBlue = UIColor(hex: 0x23238E)
    static let fireRed = UIColor(hex: 0xCD2626)
    static let brownish = UIColor(hex: 0xBDB290)
}

extension UIImage {
    static let record = UIImage(named: "record")
}
