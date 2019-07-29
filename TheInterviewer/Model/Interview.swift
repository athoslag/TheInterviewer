//
//  Interview.swift
//  TheInterviewer
//
//  Created by Athos Lagemann on 29/07/19.
//  Copyright © 2019 Athos Lagemann. All rights reserved.
//

import Foundation

final class Interview {
    
    typealias Section = [QuestionPair]
    
    let title: String
    var sections: [Section]
    
    init(title: String) {
        self.title = title
        self.sections = []
    }
}
