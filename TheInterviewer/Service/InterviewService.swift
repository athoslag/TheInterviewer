//
//  InterviewService.swift
//  TheInterviewer
//
//  Created by Athos Lagemann on 03/09/19.
//  Copyright © 2019 Athos Lagemann. All rights reserved.
//

import Foundation
import RealmSwift

final class InterviewService {
    static var shared: InterviewService = InterviewService()
    
    // Private to avoid instantiation
    private init() { }
    
    func saveInterview(_ interview: Interview) throws {
        let realm = try Realm()
        let encoded = try interview.encode()
        let object = Object(value: encoded)
        
        try realm.write {
            realm.add(object)
        }
    }
    
    func loadInterviews() throws -> [Interview] {
        fatalError("Not implemented.")
    }
}
