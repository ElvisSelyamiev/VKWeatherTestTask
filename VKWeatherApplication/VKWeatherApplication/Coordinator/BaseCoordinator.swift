//
//  BaseCoordinator.swift
//  VKWeatherApplication
//
//  Created by Elvis on 22.03.2024.
//

import Foundation

class BaseCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    func strart() {
        fatalError("Child should implement funcStart")
    }
}
