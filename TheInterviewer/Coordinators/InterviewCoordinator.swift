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
    private var interviewVM: InterviewViewModel
    
    init(window: UIWindow, interviewVM: InterviewViewModel) {
        self.window = window
        self.interviewVM = interviewVM
    }
    
    override func start() -> Void {
        // TODO: - startup code
        rootViewController = makeOverviewController(viewModel: interviewVM)
        
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }
}

// MARK: ViewController Factory
extension InterviewCoordinator {
    
    func makeOverviewController(viewModel: InterviewViewModel) -> UIViewController {
        return OverviewViewController(interviewVM: viewModel)
    }
    
    func makeQAViewController(questionPair: QuestionPair) -> UIViewController {
        let controller = UIViewController()
        // setup Q/A
        return controller
    }
}
