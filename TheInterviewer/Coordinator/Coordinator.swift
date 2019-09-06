//
//  Coordinator.swift
//  TheInterviewer
//
//  Created by Athos Lagemann on 26/06/19.
//  Copyright © 2019 Athos Lagemann. All rights reserved.
//

import Foundation

class Coordinator<T>: NSObject {
    private var childCoordinators: Set<AnyHashable> = []
    
    func start() -> T {
        fatalError("start() has not been implemented.")
    }
    
    @discardableResult
    final func coordinate<U>(to coordinator: Coordinator<U>) -> U {
        let status = self.childCoordinators.insert(coordinator)
        
        if status.inserted {
            return coordinator.start()
        } else {
            fatalError("Could not insert Coordinator in children set.")
        }
    }
}
