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
    private let window: UIWindow
    private var rootViewController: UIViewController!
    private var childCoordinators: [Coordinator<Any>] = []
    
    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() -> Void {
        // TODO: instantiate coordinators or viewControllers
        rootViewController = MainScreenViewController(text: "Hello, world!")
        
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }
}
