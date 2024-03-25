//
//  SevenDaysForecastViewControllerCoordinator.swift
//  VKWeatherApplication
//
//  Created by Elvis on 22.03.2024.
//

import UIKit

final class SevenDaysForecastViewControllerCoordinator: BaseCoordinator {
    
    private var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    override func strart() {
        let sevenDaysForecastViewController = SevenDaysForecastViewController()
        sevenDaysForecastViewController.sevenDaysForecastViewControllerCoordinator = self
        navigationController.pushViewController(sevenDaysForecastViewController, animated: true)
    }
}
