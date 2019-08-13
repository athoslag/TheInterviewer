//
//  InterviewViewModel.swift
//  TheInterviewer
//
//  Created by Athos Lagemann on 01/08/19.
//  Copyright © 2019 Athos Lagemann. All rights reserved.
//

import Foundation

final class InterviewViewModel {
    
    // Data
    typealias Index = (part: Int, section: Int, row: Int)
    private var interview: Interview
    
    var completionRate: Float {
        var total = 0
        var rate = 0
        
        for part in interview.parts {
            for section in part.sections {
                for question in section.questions {
                    total += 1
                    if question.answer != nil {
                        rate += 1
                    }
                }
            }
        }
        
        guard total != 0 else { return 0 }
        return Float(rate / total)
    }
    
    // Methods
    init(interview: Interview) {
        self.interview = interview
    }
    
    private func validateIndex(_ index: Index) -> Bool {
        return interview.parts.count > index.part &&
            interview.parts[index.part].sections.count > index.section &&
            interview.parts[index.part].sections[index.section].questions.count > index.row
    }
}

// MARK: Getters
extension InterviewViewModel {
    var title: String {
        return interview.title
    }
    
    var partTitles: [String] {
        return interview.parts.map { $0.title }
    }
    
    func sectionTitle(part: Int, section: Int) -> String {
        guard part < interview.parts.count, section < interview.parts[part].sections.count else { return "" }
        return interview.parts[part].sections[section].title
    }
    
    var numberOfParts: Int {
        return interview.parts.count
    }
    
    func numberOfSections(part: Int) -> Int {
        guard part < numberOfParts else { return -1 }
        return interview.parts[part].sections.count
    }
    
    func numberOfQuestions(section: Int, part: Int) -> Int {
        guard part < numberOfParts,
            section < numberOfSections(part: part) else { return -1 }
        
        return interview.parts[part].sections[section].questions.count
    }
    
    func question(on index: Index) -> String? {
        guard validateIndex(index) else { return nil }
        return interview.parts[index.part].sections[index.section].questions[index.row].question
    }
}

// MARK: Setters
extension InterviewViewModel {
    func updateAnswer(_ newAnswer: String, index: Index) {
        guard validateIndex(index) else { return }
        interview.parts[index.part].sections[index.section].questions[index.row].answer = newAnswer
    }
}
