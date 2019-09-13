//
//  Double.swift
//  TheInterviewer
//
//  Created by Athos Lagemann on 13/09/19.
//  Copyright © 2019 Athos Lagemann. All rights reserved.
//

import Foundation

extension Double {
    func format(f: String) -> String {
        return String(format: "%\(f)f", self)
    }
}
