//
//  InterviewSection.swift
//  TheInterviewer
//
//  Created by Athos Lagemann on 22/08/19.
//  Copyright © 2019 Athos Lagemann. All rights reserved.
//

import Foundation

struct Section {
    let title: String
    var questionPairs: [QuestionPair]
}

struct Part {
    let title: String
    var sections: [Section]
}

struct Index {
    let part: Int
    let section: Int
    let row: Int
}
