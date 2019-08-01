//
//  InterviewViewModel.swift
//  TheInterviewer
//
//  Created by Athos Lagemann on 01/08/19.
//  Copyright © 2019 Athos Lagemann. All rights reserved.
//

import Foundation

final class InterviewViewModel {
    
    private var interview: Interview
    
    init(interview: Interview) {
        self.interview = interview
    }
    
    // MARK: Getters
    var numberOfParts: Int {
        return interview.parts.count
    }
    
    func numberOfSections(part: Int) -> Int {
        guard numberOfParts < part else { return -1 }
        return interview.parts[part].sections.count
    }
    
    func numberOfQuestions(section: Int, part: Int) -> Int {
        guard numberOfParts < part,
            numberOfSections(part: part) < section else { return -1 }
        
        return interview.parts[part].sections[section].questions.count
    }
    
    func question(on row: Int, section: Int, part: Int) -> String {
        guard numberOfParts < part,
            numberOfSections(part: part) < section,
            numberOfQuestions(section: section, part: part) < row  else { return "" }
        
        return interview.parts[part].sections[section].questions[row].question
    }
    
    // MARK: Setters
    func updateAnswer(_ newAnswer: String, part: Int, section: Int, question: Int) {
        guard interview.parts.count < part,
            interview.parts[part].sections.count < section,
            interview.parts[part].sections[section].questions.count < question else { return }
        
        interview.parts[part].sections[section].questions[question].answer = newAnswer
    }
}
