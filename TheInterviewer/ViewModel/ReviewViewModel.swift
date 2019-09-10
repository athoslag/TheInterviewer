//
//  ReviewViewModel.swift
//  TheInterviewer
//
//  Created by Athos Lagemann on 10/09/19.
//  Copyright © 2019 Athos Lagemann. All rights reserved.
//

import Foundation

final class ReviewViewModel {
    
    private var interviews: [Interview]
    
    var interviewCount: Int {
        return interviews.count
    }
    
    init() {
        do {
            self.interviews = try InterviewService.loadInterviews().sorted { $0.date < $1.date }
        } catch {
            self.interviews = []
        }
    }
    
    func interviewTitles() -> [(title: String, date: String)] {
        return interviews.map{ ($0.title, $0.date.formattedDescription) }
    }
    
    func interviewInfos(for row: Int) -> (title: String, date: String) {
        return (interviews[row].title, interviews[row].date.formattedDescription)
    }

    func interview(_ row: Int) -> Interview {
        return interviews[row]
    }
    
    /// Deletes an interview at the specified index
    ///
    /// - Parameter index: The specified index to be deleted
    /// - Returns: An indication wheter the deletion was successful
    @discardableResult
    func deleteInterview(at index: Int) -> Bool {
        let interview = interviews.remove(at: index)
        
        do {
            try InterviewService.deleteInterview(interview)
        } catch {
            return false
        }
        
        return true
    }
}
