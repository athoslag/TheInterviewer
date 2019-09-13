//
//  InterviewCoordinator.swift
//  TheInterviewer
//
//  Created by Athos Lagemann on 29/07/19.
//  Copyright © 2019 Athos Lagemann. All rights reserved.
//

import Foundation
import UIKit

enum Mode {
    case edition
    case review
}

final class InterviewCoordinator: Coordinator<Void> {
    
    private let context: UIViewController
    private var navigationController: UINavigationController!
    private var viewModel: InterviewViewModel
    
    // Allows coordinator reuse
    private let mode: Mode
    
    private var currentIndex: Index? = Index(part: 0, section: 0, row: 0)
    
    // experimental flow usage
    private var interviewProgress: [Part] = []
    private var partProgress: [Section] = []
    private var sectionProgress: [QuestionPair] = []
    
    init(context: UIViewController, interviewVM: InterviewViewModel, mode: Mode) {
        self.context = context
        self.viewModel = interviewVM
        self.mode = mode
    }
    
    override func start() -> Void {
        // TODO: - startup code
        navigationController = UINavigationController(rootViewController: makeOverviewController(viewModel: viewModel))
        navigationController.navigationBar.tintColor = .black
        navigationController.modalPresentationStyle = .fullScreen
        
        context.present(navigationController, animated: true)
    }
    
    private func endFlow() {
        navigationController.dismiss(animated: true) {
            self.parentCoordinator?.release(self)
        }
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
            let finalController = makeFinalViewController()
            navigationController.pushViewController(finalController, animated: true)
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
        presentSectionIntro(section: section)
    }
    
    // Section progression
    func sectionNextStep() {
        guard !sectionProgress.isEmpty, let index = currentIndex else {
            partNextStep()
            return
        }
        
        let questionPair = sectionProgress.removeFirst()
        let controller = makeQAViewController(questionPair: questionPair, index: index)
        navigationController.pushViewController(controller, animated: true)
    }
    
    func presentSectionIntro(section: Section) {
        let controller = makeSectionOverview(section: section)
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
        let partTitle = viewModel.titles(for: currentIndex).part
        let sectionOverview = SectionOverviewViewController(section: section, partTitle: partTitle)
        sectionOverview.delegate = self
        return sectionOverview
    }
    
    func makeQAViewController(questionPair: QuestionPair, index: Index) -> UIViewController {
        switch questionPair.type {
        case .long:
            let longController = QALongViewController(viewModel: viewModel, index: index)
            longController.delegate = self
            return longController
        default:
            let controller = QAViewController(viewModel: viewModel, index: index, answerType: questionPair.type)
            controller.delegate = self
            return controller
        }
    }
    
    func makeFinalViewController() -> UIViewController {
        let controller = FinalScreenViewController(viewModel: viewModel)
        controller.delegate = self
        return controller
    }
}

// MARK: Delegates
extension InterviewCoordinator: OverviewDelegate {
    func didSelect(_ viewController: OverviewViewController, index: Index) {
        // TODO: fix flow
        self.currentIndex = index
        initInterviewNavigation()
    }
    
    func shouldDismiss(_ viewController: OverviewViewController) {
        endFlow()
    }
}

extension InterviewCoordinator: SectionDelegate {
    func didSelectRow(_ viewController: SectionOverviewViewController, row: Int) {
        // TODO: present selected QA
        self.currentIndex = currentIndex?.withRow(row)
        sectionNextStep()
    }
}

extension InterviewCoordinator: QAViewControllerDelegate {
    func didFinishAnswer(_ viewController: QAViewController, viewModel: InterviewViewModel, index: Index) {
        self.currentIndex = viewModel.nextIndex(currentIndex: index)
        self.viewModel = viewModel
        sectionNextStep()
    }
}

extension InterviewCoordinator: QALongViewControllerDelegate {
    func didFinishAnswer(_ viewController: QALongViewController, viewModel: InterviewViewModel, index: Index) {
        self.currentIndex = viewModel.nextIndex(currentIndex: index)
        self.viewModel = viewModel
        sectionNextStep()
    }
}

extension InterviewCoordinator: FinalScreenDelegate {
    func didTapShare(_ viewController: FinalScreenViewController) {
        guard let interview = viewModel.shareInterview() else { return }
        let items: [Any] = [interview]
        
        let shareViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        shareViewController.popoverPresentationController?.sourceView = viewController.view
        shareViewController.modalPresentationStyle = .formSheet
        shareViewController.excludedActivityTypes = [.assignToContact, .addToReadingList, .saveToCameraRoll]
        viewController.present(shareViewController, animated: true)
    }
    
    func didTapSave(_ viewController: FinalScreenViewController) {
        let status = viewModel.saveInterview()
        
        let errorOption = [AlertOption(title: "Ok", style: .default, completion: { _ in })]
        let successOption = [AlertOption(title: "Ok", style: .default, completion: { _ in
            self.endFlow()
        })]
        
        let title = status ? "Sucesso" : "Erro"
        let message = status ? "A entrevista foi salva com sucesso" : "Houve um erro ao salvar a entrevista"
        
        let bundle = AlertBundle(title: title, details: message, options: status ? successOption : errorOption)
        viewController.presentAlert(bundle)
    }
    
    func didTapDiscard(_ viewController: FinalScreenViewController) {
        let options: [AlertOption] = [
            AlertOption(title: "Excluir", style: .destructive, completion: { _ in
                self.endFlow()
            }),
            AlertOption(title: "Cancelar", style: .cancel, completion: { _ in })
        ]
        
        let bundle = AlertBundle(title: "Você tem certeza de que deseja deletar a entrevista?",
                                 details: "Esta ação é irreversível",
                                 options: options)
        
        viewController.presentAlert(bundle)
    }
}
