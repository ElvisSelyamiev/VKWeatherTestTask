//
//  MainViewControllerCoordinator.swift
//  VKWeatherApplication
//
//  Created by Elvis on 22.03.2024.
//

import UIKit

final class MainViewControllerCoordinator: BaseCoordinator {

    private var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    override func strart() {
        let mainViewController = MainViewController()
        mainViewController.mainViewControllerCoordinator = self
        navigationController.pushViewController(mainViewController, animated: true)
    }
    
    func runSevenDaysForecast() {
        let sevenDaysForecastViewControllerCoordinator = SevenDaysForecastViewControllerCoordinator(navigationController: navigationController)
        add(coordinator: sevenDaysForecastViewControllerCoordinator)
        sevenDaysForecastViewControllerCoordinator.strart()
    }
    
    func runSearchCitiesForWeather() {
        let searchCitiesForWeatherViewControllerCoordinator = SearchCitiesForWeatherViewControllerCoordinator(navigationController: navigationController)
        add(coordinator: searchCitiesForWeatherViewControllerCoordinator)
        searchCitiesForWeatherViewControllerCoordinator.strart()
    }
}


