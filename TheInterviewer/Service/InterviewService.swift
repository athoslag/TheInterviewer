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
    enum ServiceError: Error {
        case alreadyExists
        case decode
        case encode
        case realmUnavailable
        case realmWrite
        case notFound
        case fileManager
        case unknown
    }
    
    private static var recordingsPath: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent("recordings", isDirectory: true)
    }
    
    // Private to avoid instantiation
    private init() { }
    
    /// Saves an interview object into the local database.
    ///
    /// - Parameter interview: The interview object to be saved
    /// - Throws: Throws a ServiceError, according to the unsuccessful operation
    static func saveInterview(_ interview: Interview) throws {
        let realm: Realm
        do {
            realm = try Realm()
        } catch {
            throw ServiceError.realmUnavailable
        }
        
        let encoded: Data
        do {
            encoded = try interview.encode()
        } catch {
            throw ServiceError.encode
        }
        
        let wrapper = Wrapper()
        wrapper.wrap(encoded, id: encoded.base64EncodedString())
        
        if realm.object(ofType: Wrapper.self, forPrimaryKey: wrapper.identifier) != nil {
            throw ServiceError.alreadyExists
        }
        
        do {
            try realm.write {
                realm.add(wrapper)
            }
        } catch {
            throw ServiceError.realmWrite
        }
    }
    
    /// Load the interviews from the local database.
    ///
    /// - Returns: All locally stored interviews.
    /// - Throws: Throws a ServiceError, according to the unsuccessful operation
    static func loadInterviews() throws -> [Interview] {
        let realm: Realm
        do {
            realm = try Realm()
        } catch {
            throw ServiceError.realmUnavailable
        }
        
        let wrappers = realm.objects(Wrapper.self)
        let decoder = JSONDecoder()
        
        do {
            let result: [Interview] = try wrappers.compactMap { try decoder.decode(Interview.self, from: $0.data!) }
            return result
        } catch {
            throw ServiceError.decode
        }
    }
    
    /// Deletes a specific object from the local database.
    ///
    /// - Parameter interview: The interview reference to be deleted.
    /// - Throws: Throws a ServiceError, according to the unsuccessful operation
    static func deleteInterview(_ interview: Interview) throws {
        let realm: Realm
        do {
            realm = try Realm()
        } catch {
            throw ServiceError.realmUnavailable
        }
        
        let encoded: Data
        do {
            encoded = try interview.encode()
        } catch {
            throw ServiceError.encode
        }
        
        guard let wrapper = realm.object(ofType: Wrapper.self, forPrimaryKey: encoded.base64EncodedString()) else {
            // Object not found!
            throw ServiceError.notFound
        }
        
        do {
            try realm.write {
                realm.delete(wrapper)
            }
        } catch {
            throw ServiceError.realmWrite
        }
        
        // Delete associated audios folder
        let fileManager = FileManager.default
        var isDir: ObjCBool = true
        
        guard fileManager.fileExists(atPath: recordingsPath.path, isDirectory: &isDir) else { throw ServiceError.fileManager }
        let path: URL = recordingsPath.appendingPathComponent(encoded.base64EncodedString(), isDirectory: true)
        
        if fileManager.fileExists(atPath: path.path, isDirectory: &isDir) {
            do {
                try fileManager.removeItem(at: path)
            } catch {
                throw ServiceError.fileManager
            }
        }
    }
    
    /// Deletes all interviews from the local database.
    ///
    /// - Throws: Throws a ServiceError, according to the unsuccessful operation
    static func deleteAllInterviews() throws {
        let realm: Realm
        do {
            realm = try Realm()
        } catch {
            throw ServiceError.realmUnavailable
        }
        
        do {
            try realm.write {
                realm.deleteAll()
            }
        } catch {
            throw ServiceError.realmWrite
        }
    }
}
