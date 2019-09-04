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
        let wrapper = Wrapper()
        wrapper.wrap(encoded, id: encoded.base64EncodedString())
        
        try realm.write {
            realm.add(wrapper)
        }
    }
    
    static func loadInterviews() throws -> [Interview] {
        let realm = try Realm()
        let wrappers = realm.objects(Wrapper.self)
        let decoder = JSONDecoder()
        
        let result: [Interview] = try wrappers.compactMap { try decoder.decode(Interview.self, from: $0.data!) }
        return result
    }
    
    static func deleteInterview(_ interview: Interview) throws {
        let realm = try Realm()
        let encoded = try interview.encode()

        guard let wrapper = realm.object(ofType: Wrapper.self, forPrimaryKey: encoded.base64EncodedString()) else {
            print("Object not found!")
            return
        }
        
        try realm.write {
            realm.delete(wrapper)
        }
    }
    
    static func deleteAllInterviews() throws {
        let realm = try Realm()
        
        try realm.write {
            realm.deleteAll()
        }
    }
}
