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
    
    init(context: UIViewController, interviewVM: InterviewViewModel, mode: Mode) {
        self.context = context
        self.viewModel = interviewVM
        self.mode = mode
    }
    
    override func start() -> Void {
        navigationController = UINavigationController(rootViewController: makeOverviewController(viewModel: viewModel, canEditTitle: true))
        navigationController.navigationBar.tintColor = .black
        navigationController.modalPresentationStyle = .fullScreen
        
        context.present(navigationController, animated: true)
    }
}

// MARK: Navigation
extension InterviewCoordinator {
    private func nextStep(advance: Bool) {
        guard let index = currentIndex else {
            let finalController = makeFinalViewController()
            navigationController.pushViewController(finalController, animated: true)
            return
        }
        
        let nextMove: InterviewViewModel.IndexPair
        
        if advance {
            nextMove = viewModel.nextIndex(currentIndex: index)
        } else {
            nextMove = viewModel.currentIndexPair(index)
        }
        
        switch nextMove {
        case .done:
            let finalController = makeFinalViewController()
            navigationController.pushViewController(finalController, animated: true)
        case .questionPair(let newIndex):
            let questionPair = viewModel.questionPair(for: newIndex)
            let controller = makeQAViewController(questionPair: questionPair!, index: newIndex)
            navigationController.pushViewController(controller, animated: true)
        case .section(let newIndex, let section):
            currentIndex = newIndex
            let controller = makeSectionOverview(section: section)
            navigationController.pushViewController(controller, animated: true)
        case .part(let newIndex, _):
            currentIndex = newIndex
            let section = viewModel.section(for: newIndex)
            let controller = makeSectionOverview(section: section)
            navigationController.pushViewController(controller, animated: true)
        }
    }
    
    private func requestOverview() {
        let overview = makeOverviewController(viewModel: viewModel, canEditTitle: false)
        navigationController.pushViewController(overview, animated: true)
    }
    
    private func endFlow() {
        navigationController.dismiss(animated: true) {
            self.parentCoordinator?.release(self)
        }
    }
}

// MARK: ViewController Factory
extension InterviewCoordinator {
    func makeOverviewController(viewModel: InterviewViewModel, canEditTitle: Bool) -> UIViewController {
        let overview = OverviewViewController(interviewVM: viewModel, canEditTitle: canEditTitle)
        overview.delegate = self
        return overview
    }
    
    func makeSectionOverview(section: Section) -> UIViewController {
        let partTitle = viewModel.titles(for: currentIndex).part
        let sectionOverview = SectionOverviewViewController(section: section, partTitle: partTitle, index: currentIndex!)
        sectionOverview.delegate = self
        return sectionOverview
    }
    
    func makeQAViewController(questionPair: QuestionPair, index: Index) -> UIViewController {
        switch questionPair.type {
        case .long:
            let longController = QALongViewController(viewModel: viewModel, index: index, presentationMode: mode)
            longController.delegate = self
            return longController
        default:
            let configuration = QAConfiguration(answerType: questionPair.type, presentationMode: mode)
            let controller = QAViewController(viewModel: viewModel, index: index, configuration: configuration)
            controller.delegate = self
            return controller
        }
    }
    
    func makeFinalViewController() -> UIViewController {
        let controller = FinalScreenViewController(viewModel: viewModel, displayMode: mode)
        controller.delegate = self
        return controller
    }
}

// MARK: Delegates
extension InterviewCoordinator: OverviewDelegate {
    func didSelect(_ viewController: OverviewViewController, index: Index) {
        self.currentIndex = index
        nextStep(advance: false)
    }
    
    func shouldDismiss(_ viewController: OverviewViewController) {
        endFlow()
    }
}

extension InterviewCoordinator: SectionDelegate {
    func didSelectRow(_ viewController: SectionOverviewViewController, index: Index) {
        self.currentIndex = index
        nextStep(advance: false)
    }
}

extension InterviewCoordinator: QAViewControllerDelegate {
    func didTapBack(_ viewController: QAViewController, viewModel: InterviewViewModel) {
        self.viewModel = viewModel
    }
    
    func didTapOverview(_ viewController: QAViewController, viewModel: InterviewViewModel) {
        self.viewModel = viewModel
        requestOverview()
    }
    
    func didFinishAnswer(_ viewController: QAViewController, viewModel: InterviewViewModel, index: Index) {
        self.currentIndex = index
        self.viewModel = viewModel
        nextStep(advance: true)
    }
}

extension InterviewCoordinator: QALongViewControllerDelegate {
    func didTapBack(_ viewController: QALongViewController, viewModel: InterviewViewModel) {
        self.viewModel = viewModel
    }
    
    func didTapOverview(_ viewController: QALongViewController, viewModel: InterviewViewModel) {
        self.viewModel = viewModel
        requestOverview()
    }
    
    func didFinishAnswer(_ viewController: QALongViewController, viewModel: InterviewViewModel, index: Index) {
        self.currentIndex = index
        self.viewModel = viewModel
        nextStep(advance: true)
    }
}

extension InterviewCoordinator: FinalScreenDelegate {
    func didTapShare(_ viewController: FinalScreenViewController) {
        guard let interview = viewModel.shareInterview() else { return }
        var items: [Any] = [interview]
        
        if let url = ZipfileService.zipFilesAt(path: viewModel.interviewDirectory, filename: viewModel.title) {
            items.append(url)
        } else {
            print("Failed to zip files.")
        }
        
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
        guard mode == .edition else {
            self.endFlow()
            return
        }
        
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
