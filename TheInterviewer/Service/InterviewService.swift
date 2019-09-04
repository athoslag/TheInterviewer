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
    
    // Private to avoid instantiation
    private init() { }
    
    static func saveInterview(_ interview: Interview) throws {
        let realm = try Realm()
        let encoded = try interview.encode()
        let wrapp = RealmWrapper()
        wrapp.data = encoded
        
        try realm.write {
            realm.add(wrapp)
        }
    }
    
    static func loadInterviews() throws -> [Interview] {
        let realm = try Realm()
        let wrappers = realm.objects(RealmWrapper.self)
        let decoder = JSONDecoder()
        
        let result: [Interview] = try wrappers.compactMap { try decoder.decode(Interview.self, from: $0.data!) }
        return result
    }
}
