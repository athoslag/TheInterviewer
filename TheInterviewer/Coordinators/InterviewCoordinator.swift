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
    
    private enum Step {
        case overview
        case interstep
        case finish
    }
    
    private let context: UIViewController
    private var navigationController: UINavigationController!
    private var interviewVM: InterviewViewModel
    
    private var currentStep: Step
    
    init(context: UIViewController, interviewVM: InterviewViewModel) {
        self.context = context
        self.interviewVM = interviewVM
        self.currentStep = .overview
    }
    
    override func start() -> Void {
        // TODO: - startup code
        navigationController = UINavigationController(rootViewController: makeOverviewController(viewModel: interviewVM))
        navigationController.navigationBar.tintColor = .black
        navigationController.modalPresentationStyle = .fullScreen
        
        context.present(navigationController, animated: true)
    }
}

// MARK: Navigation
extension InterviewCoordinator {
    func goToNext() {
        
    }
    
    func goToPrevious() {
        
    }
    
    func goToOverview() {
        let overview = makeOverviewController(viewModel: interviewVM)
        navigationController.present(overview, animated: true)
    }
    
    func goToFinish() {
        
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
