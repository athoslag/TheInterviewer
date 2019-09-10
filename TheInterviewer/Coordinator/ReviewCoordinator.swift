//
//  ReviewCoordinator.swift
//  TheInterviewer
//
//  Created by Athos Lagemann on 10/09/19.
//  Copyright © 2019 Athos Lagemann. All rights reserved.
//

import Foundation
import UIKit

final class ReviewCoordinator: Coordinator<Void> {
    
    private let context: UIViewController
    private var navigationController: UINavigationController!
    private var viewModel: ReviewViewModel
    
    init(context: UIViewController, viewModel: ReviewViewModel) {
        self.context = context
        self.viewModel = viewModel
    }
    
    override func start() -> Void {
        navigationController = UINavigationController(rootViewController: makeReviewMenu())
        navigationController.navigationBar.tintColor = .black
        navigationController.modalPresentationStyle = .fullScreen
        
        context.present(navigationController, animated: true)
    }
}

extension ReviewCoordinator {
    func makeReviewMenu() -> UIViewController {
        let controller = ReviewMenuViewController(viewModel: ReviewViewModel())
        controller.delegate = self
        return controller
    }
}

extension ReviewCoordinator: ReviewDelegate {
    func didSelectRow(_ viewController: ReviewMenuViewController, viewModel: ReviewViewModel, row: Int) {
        self.viewModel = viewModel
        // TODO: coordinate to interview
    }
}
