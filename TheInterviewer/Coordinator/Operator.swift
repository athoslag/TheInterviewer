//
//  Operator.swift
//  TheInterviewer
//
//  Created by Athos Lagemann on 23/10/19.
//  Copyright © 2019 Athos Lagemann. All rights reserved.
//

import Foundation

func xor(_ op1: Bool, _ op2: Bool) -> Bool {
    if op1 {
        return !op2
    } else {
        return op2
    }
}
