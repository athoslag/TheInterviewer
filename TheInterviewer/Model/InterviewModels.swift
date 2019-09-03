//
//  InterviewModels.swift
//  TheInterviewer
//
//  Created by Athos Lagemann on 22/08/19.
//  Copyright © 2019 Athos Lagemann. All rights reserved.
//

import Foundation

struct QuestionPair: Codable {
    let question: String
    var answer: String?
    
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
