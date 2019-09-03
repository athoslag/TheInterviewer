//
//  InterviewModels.swift
//  TheInterviewer
//
//  Created by Athos Lagemann on 22/08/19.
//  Copyright © 2019 Athos Lagemann. All rights reserved.
//

import Foundation

enum AnswerType: String, Codable {
    case short
    case long
    case number
}

struct QuestionPair: Codable {
    let question: String
    var answer: String?
    let type: AnswerType
    
    // TODO: Add recorded answer option
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
}
