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
    
    private enum Step: Int, CaseIterable {
        case overview = 1
        case interstep
        case finish
    }
    
    private let context: UIViewController
    private var navigationController: UINavigationController!
    private var viewModel: InterviewViewModel
    
    private var currentStep: Step = .overview
    private var currentIndex: Int = 0
    
    init(context: UIViewController, interviewVM: InterviewViewModel) {
        self.context = context
        self.viewModel = interviewVM
    }
    
    override func start() -> Void {
        // TODO: - startup code
        navigationController = UINavigationController(rootViewController: makeOverviewController(viewModel: viewModel))
        navigationController.navigationBar.tintColor = .black
        navigationController.modalPresentationStyle = .fullScreen
        
        context.present(navigationController, animated: true)
    }
}

// MARK: Navigation
extension InterviewCoordinator {
    func nextStep() {
        let next: Step
        let nextViewController: UIViewController
        
        switch currentStep {
        case .interstep:
            next = .finish
            nextViewController = makeOverviewController(viewModel: viewModel)
        case .overview:
            next = .interstep
            // FIXME: Count inter-steps
            nextViewController = makeQAViewController(questionPair: viewModel.questionPairs[currentIndex], index: currentIndex)
        case .finish:
            next = .finish
            nextViewController = makeOverviewController(viewModel: viewModel)
        }
        
        currentStep = next
        navigationController.pushViewController(nextViewController, animated: true)
    }
}

// MARK: ViewController Factory
extension InterviewCoordinator {
    
    func makeOverviewController(viewModel: InterviewViewModel) -> UIViewController {
        let overview = OverviewViewController(interviewVM: viewModel)
        overview.delegate = self
        return overview
    }
    
    func makeSectionOverview(section: Section) -> UIViewController {
        let sectionOverview = SectionOverviewViewController(section: section)
        sectionOverview.delegate = self
        return sectionOverview
    }
    
    func makeQAViewController(questionPair: QuestionPair, index: Int) -> UIViewController {
        let controller = QAViewController(pair: questionPair, index: index)
        return controller
    }
}

// MARK: Delegates
extension InterviewCoordinator: OverviewDelegate {
    func didSelect(_ viewController: OverviewViewController, itemIndex: IndexPath) {
        // TODO: implement flow
        currentIndex = itemIndex.row
        nextStep()
    }
}

extension InterviewCoordinator: SectionDelegate {
    func didSelectRow(_ viewController: SectionOverviewViewController, row: IndexPath) {
        // TODO: present selected QA
        nextStep() // remove this later
    }
}

extension InterviewCoordinator: QAViewControllerDelegate {
    func didFinishAnswer(_ viewController: QAViewController, index: Int, answer: String?) {
        // TODO: implement flow
        currentIndex = index
        nextStep()
    }
}
