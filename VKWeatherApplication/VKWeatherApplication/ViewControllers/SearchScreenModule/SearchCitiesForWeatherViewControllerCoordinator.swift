//
//  SearchCitiesForWeatherViewControllerCoordinator.swift
//  VKWeatherApplication
//
//  Created by Elvis on 25.03.2024.
//

import UIKit

final class SearchCitiesForWeatherViewControllerCoordinator: BaseCoordinator {
    
    private var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    override func strart() {
        let searchCitiesForWeatherViewController = SearchCitiesForWeatherViewController()
        searchCitiesForWeatherViewController.searchCitiesForWeatherViewControllerCoordinator = self
        navigationController.pushViewController(searchCitiesForWeatherViewController, animated: true)
    }
}
