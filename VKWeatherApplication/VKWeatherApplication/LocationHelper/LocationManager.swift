//
//  LocationManager.swift
//  VKWeatherApplication
//
//  Created by Elvis on 22.03.2024.
//

import Foundation
import CoreLocation

protocol LocationManagerMainDelegate: AnyObject {
    func getLocationDataForMain(latitude: Double, longitude: Double)
}

protocol LocationManagerForecastDelegate: AnyObject {
    func getLocationDataForForecast(latitude: Double, longitude: Double)
}

final class LocationManager: NSObject, CLLocationManagerDelegate {
    
    private let locationManager = CLLocationManager()
    
    weak var mainDelegate: LocationManagerMainDelegate?
    weak var forecastDelegate: LocationManagerForecastDelegate?
    
    private var latitude = 0.0
    private var longitude = 0.0

    override init() {
        super.init()
        startLocationManager()
    }
    
    private func startLocationManager() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.pausesLocationUpdatesAutomatically = false
            locationManager.startUpdatingLocation()
    }
    
    func locationDataRequest() {
        forecastDelegate?.getLocationDataForForecast(latitude: latitude, longitude: longitude)
    }
    
    func refreshUserCoordinate() {
        guard let delegate = mainDelegate else { return }
        delegate.getLocationDataForMain(latitude: latitude, longitude: longitude)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            latitude = location.coordinate.latitude
            longitude = location.coordinate.longitude
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
}

