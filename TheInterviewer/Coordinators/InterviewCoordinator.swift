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
    private var interview: Interview
    
    init(window: UIWindow, interview: Interview) {
        self.window = window
        self.interview = interview
    }
    
    override func start() -> Void {
        // TODO: - startup code
        rootViewController = MainInterviewViewController(progress: 0.2, question: "What do I have in my pocket?", answer: nil)
        
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }
}

// MARK: ???
extension InterviewCoordinator {
    
}
