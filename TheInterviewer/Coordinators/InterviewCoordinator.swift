//
//  InterviewCoordinator.swift
//  TheInterviewer
//
//  Created by Athos Lagemann on 29/07/19.
//  Copyright © 2019 Athos Lagemann. All rights reserved.
//

import Foundation
import UIKit

final class InterviewCoordinator: Coordinator<Void> {
    private let window: UIWindow
    private var rootViewController: UIViewController!
    
    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() -> Void {
        // TODO: - startup code
        
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }
}
