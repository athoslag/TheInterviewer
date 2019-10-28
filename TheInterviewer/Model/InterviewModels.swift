//
//  InterviewModels.swift
//  TheInterviewer
//
//  Created by Athos Lagemann on 22/08/19.
//  Copyright © 2019 Athos Lagemann. All rights reserved.
//

import Foundation

enum AnswerType: String, Codable {
    case name
    case short
    case long
    case number
}

struct QuestionPair: Codable {
    let question: String
    var answer: String?
    let type: AnswerType
}

struct Section: Codable {
    let title: String
    var questionPairs: [QuestionPair]
}

struct Part: Codable {
    let title: String
    var sections: [Section]
}

struct Index {
    let part: Int
    let section: Int
    let row: Int
    
    func advancing(_ component: IndexComponent) -> Index {
        switch component {
        case .row:
            return Index(part: self.part, section: self.section, row: self.row + 1)
        case .section:
            return Index(part: self.part, section: self.section + 1, row: 0)
        case .part:
            return Index(part: self.part + 1, section: 0, row: 0)
        }
    }
    
    func withRow(_ row: Int) -> Index {
        return Index(part: self.part, section: self.section, row: row)
    }
    
    var filename: String {
        return "\(part).\(section).\(row)"
    }
}

enum IndexComponent {
    case row
    case section
    case part
}
