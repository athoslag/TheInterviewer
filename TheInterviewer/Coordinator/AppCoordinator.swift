//
//  AppCoordinator.swift
//  TheInterviewer
//
//  Created by Athos Lagemann on 19/06/19.
//  Copyright © 2019 Athos Lagemann. All rights reserved.
//

import Foundation
import UIKit

final class AppCoordinator: Coordinator<Void> {
    
    private enum MenuOption: String, CaseIterable {
        case new
        case review
        case configurations
    }
    
    private let window: UIWindow
    private var rootViewController: UIViewController!
    private var childCoordinators: [Coordinator<Any>] = []
    
    private var viewModel: MainViewModel
    private var options: [MenuOption] = MenuOption.allCases
    
    init(window: UIWindow) {
        self.window = window
        viewModel = MainViewModel()
    }
    
    override func start() -> Void {
        // TODO: instantiate coordinators or viewControllers
        rootViewController = makeMainScreen()
        
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }
}

// MARK: ViewController Factory
extension AppCoordinator {
    func makeMainScreen() -> MainScreenViewController {
        let viewController = MainScreenViewController()
        viewController.delegate = self
        return viewController
    }
}

// MARK: Main Screen Delegate
extension AppCoordinator: MainScreenDelegate {
    func didTapNew(_ mainScreen: MainScreenViewController) {        
        let viewModel = InterviewViewModel(interview: Interview())
        let interviewFlow = InterviewCoordinator(context: rootViewController, interviewVM: viewModel, mode: .edition)
        coordinate(to: interviewFlow)
    }
    
    func didTapReview(_ mainScreen: MainScreenViewController) {
        let reviewViewModel = ReviewViewModel()
        let reviewFlow = ReviewCoordinator(context: rootViewController, viewModel: reviewViewModel)
        coordinate(to: reviewFlow)
    }
}
