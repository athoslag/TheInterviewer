//
//  RealmWrapper.swift
//  TheInterviewer
//
//  Created by Athos Lagemann on 04/09/19.
//  Copyright © 2019 Athos Lagemann. All rights reserved.
//

import Foundation
import RealmSwift

final class Wrapper: Object {
    @objc dynamic var identifier: String = String()
    @objc dynamic var data: Data?
    
    override static func primaryKey() -> String? {
        return "identifier"
    }
    
    func wrap(_ data: Data, id: String) {
        self.identifier = id
        self.data = data
    }
}
