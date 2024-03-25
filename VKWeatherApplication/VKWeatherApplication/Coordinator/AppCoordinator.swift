//
//  AppCoordinator.swift
//  VKWeatherApplication
//
//  Created by Elvis on 22.03.2024.
//

import UIKit

final class AppCoordinator: BaseCoordinator {
    
    private var window: UIWindow
    
    private var navigationController: UINavigationController = {
        let navigationController = UINavigationController()
        return navigationController
    }()
    
    init(window: UIWindow) {
        self.window = window
        self.window.rootViewController = navigationController
        self.window.makeKeyAndVisible()
    }
    
    override func strart() {
        let mainViewControllerCoordinator = MainViewControllerCoordinator(navigationController: navigationController)
        add(coordinator: mainViewControllerCoordinator)
        mainViewControllerCoordinator.strart()
    }
}
