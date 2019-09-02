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
    
    // experimental flow usage
    private var interviewProgress: [Part] = []
    private var partProgress: [Section] = []
    private var sectionProgress: [QuestionPair] = []
    
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
    // Interview init
    func initInterviewNavigation() {
        interviewProgress = viewModel.parts
        interviewNextStep()
    }
    
    // Interview progression
    func interviewNextStep() {
        guard !interviewProgress.isEmpty else {
            // TODO: End of part
            navigationController.popToRootViewController(animated: true)
            return
        }
        
        let part = interviewProgress.removeFirst()
        initPartNavigation(part)
    }
    
    // Part init
    func initPartNavigation(_ part: Part) {
        partProgress = part.sections
        partNextStep()
    }
    
    // Part progression
    func partNextStep() {
        guard !partProgress.isEmpty else {
            interviewNextStep()
            return
        }
        
        let section = partProgress.removeFirst()
        initSectionNavigation(section)
    }
    
    // Section init
    func initSectionNavigation(_ section: Section) {
        sectionProgress = section.questionPairs
        sectionNextStep()
    }
    
    // Section progression
    func sectionNextStep() {
        guard !sectionProgress.isEmpty else {
            partNextStep()
            return
        }
        
        let questionPair = sectionProgress.removeFirst()
        let controller = makeQAViewController(questionPair: questionPair, index: 0)
        navigationController.pushViewController(controller, animated: true)
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
        controller.delegate = self
        return controller
    }
}

// MARK: Delegates
extension InterviewCoordinator: OverviewDelegate {
    func didSelect(_ viewController: OverviewViewController, itemIndex: IndexPath) {
        // TODO: fix flow
        initInterviewNavigation()
    }
}

extension InterviewCoordinator: SectionDelegate {
    func didSelectRow(_ viewController: SectionOverviewViewController, row: IndexPath) {
        // TODO: present selected QA
        sectionNextStep()
    }
}

extension InterviewCoordinator: QAViewControllerDelegate {
    func didFinishAnswer(_ viewController: QAViewController, index: Int, answer: String?) {
        // TODO: save answer
        sectionNextStep()
    }
}
