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
    
    var questionPairs: [QuestionPair] {
        var pairs: [QuestionPair] = []
        
        for part in interview.parts {
            for section in part.sections {
                pairs.append(contentsOf: section.questionPairs)
            }
        }
        
        return pairs
    }
    
    var parts: [Part] {
        return interview.parts
    }
    
    var sections: [Section] {
        return interview.parts.flatMap { $0.sections }
    }
    
    lazy var currentIndex: Index = Index(part: 0, section: 0, row: 0)
    
    // Methods
    init(interview: Interview) {
        self.interview = interview
    }
    
    init?(from encoded: Data) {
        do {
            let decoder = JSONDecoder()
            self.interview = try decoder.decode(Interview.self, from: encoded)
        } catch {
            return nil
        }
    }
    
    private func validateIndex(_ index: Index) -> Bool {
        return interview.parts.count > index.part &&
            interview.parts[index.part].sections.count > index.section &&
            interview.parts[index.part].sections[index.section].questionPairs.count > index.row
    }
    
    func encodeInterview() -> Data? {
        do {
            return try interview.encode()
        } catch {
            return nil
        }
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
    
    var numberOfParts: Int {
        return interview.parts.count
    }
    
    func titles(for index: Index?) -> (part: String, section: String) {
        guard let validIndex = index else { return ("", "") }
        return (partTitle(part: validIndex.part), sectionTitle(part: validIndex.part, section: validIndex.section))
    }
    
    func partTitle(part: Int) -> String {
        guard part < interview.parts.count else { return "" }
        return interview.parts[part].title
    }
    
    func sectionTitle(part: Int, section: Int) -> String {
        guard part < interview.parts.count, section < interview.parts[part].sections.count else { return "" }
        return interview.parts[part].sections[section].title
    }
    
    func numberOfSections(part: Int) -> Int {
        guard part < numberOfParts else { return -1 }
        return interview.parts[part].sections.count
    }
    
    func numberOfQuestions(section: Int, part: Int) -> Int {
        guard part < numberOfParts,
            section < numberOfSections(part: part) else { return -1 }
        
        return interview.parts[part].sections[section].questionPairs.count
    }
    
    func questionPair(for index: Index) -> QuestionPair? {
        guard validateIndex(index) else { return nil }
        return interview.parts[index.part].sections[index.section].questionPairs[index.row]
    }
    
    func nextIndex(currentIndex: Index) -> Index? {
        let newRow = currentIndex.advancing(.row)
        if validateIndex(newRow) {
            return newRow
        } else {
            let newSection = currentIndex.advancing(.section)
            if validateIndex(newSection) {
                return newSection
            } else {
                let newPart = currentIndex.advancing(.part)
                if validateIndex(newPart) {
                    return newPart
                } else {
                    // Reached end of interview
                    return nil
                }
            }
        }
    }
    
    func describeInterview() {
        interview.description()
    }
}

// MARK: Setters
extension InterviewViewModel {
    func updateTitle(_ newTitle: String) {
        self.interview.title = newTitle
    }
    
    func updateAnswer(_ newAnswer: String?, for index: Index) {
        guard validateIndex(index) else { return }
        interview.parts[index.part].sections[index.section].questionPairs[index.row].answer = newAnswer
    }
}
