//
//  ViewController.swift
//  VKWeatherApplication
//
//  Created by Elvis on 21.03.2024.
//

import UIKit
import CoreLocation
import Foundation

final class MainViewController: UIViewController {
  
    // MARK: - Properties
    weak var mainViewControllerCoordinator: MainViewControllerCoordinator?
    
    private let locationManager = LocationManager()
    private let apiManager = ApiManager()
    
    private let contentView = UIView()
    private let activityIndicator = UIActivityIndicatorView()
    private let temperatureLabel = UILabel()
    private let weatherConditionsLabel = UILabel()
    private let feelsLikeTemperatureLabel = UILabel()
    private let windSpeedLabel = UILabel()
    private let cloudsLabel = UILabel()
    
    private let sevenDaysForecastButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Strings.sevenDaysScreenTitle, for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = UIColor.white.withAlphaComponent(Constants.colorOpacity)
        button.layer.cornerRadius = Constants.cornerRadius
        button.addTarget(nil, action: #selector(sevenDaysForecastButtonTap), for: .touchUpInside)
        return button
    }()
    
    private let otherCitiesForecastButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Strings.otherCitiesForecastButtonTitle, for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = UIColor.white.withAlphaComponent(Constants.colorOpacity)
        button.layer.cornerRadius = Constants.cornerRadius
        button.addTarget(nil, action: #selector(otherCitiesForecastButtonTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var refreshButton = UIBarButtonItem(title: Strings.refreshBarButton , style: .plain, target: self, action: #selector(refreshButtonAction))

    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.mainDelegate = self
        
        setupTamic()
        setupUI()
        settingUI()
        startActivitiIndicator()
    }
    
    // MARK: - Private Methods
    private func setupTamic() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        weatherConditionsLabel.translatesAutoresizingMaskIntoConstraints = false
        feelsLikeTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        windSpeedLabel.translatesAutoresizingMaskIntoConstraints = false
        cloudsLabel.translatesAutoresizingMaskIntoConstraints = false
        sevenDaysForecastButton.translatesAutoresizingMaskIntoConstraints = false
        otherCitiesForecastButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configuration(weatherData: WeatherDataModel) {
        title = weatherData.name
        temperatureLabel.text = weatherData.main.tempString + "º"
        weatherConditionsLabel.text = weatherData.weather.last?.main
        feelsLikeTemperatureLabel.text = Strings.feelsLikeTitle + "\(weatherData.main.feelsLikeString)º"
        windSpeedLabel.text = Strings.windSpeedTitle + "\(weatherData.wind.speedString) м/с"
        cloudsLabel.text = Strings.cloudsTitle + "\(weatherData.clouds.allString) %"
    }
    
    private func settingUI() {
        navigationItem.rightBarButtonItem = refreshButton
        contentView.backgroundColor = .white.withAlphaComponent(Constants.colorOpacity)
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = Constants.cornerRadius

        activityIndicator.style = .large
        activityIndicator.color = .black
        temperatureLabel.font = .boldSystemFont(ofSize: Constants.largeTextSize)
        weatherConditionsLabel.font = .systemFont(ofSize: Constants.havyTextSize)
        feelsLikeTemperatureLabel.font = .systemFont(ofSize: Constants.defaultTextSize)
        windSpeedLabel.font = .systemFont(ofSize: Constants.defaultTextSize)
        cloudsLabel.font = .systemFont(ofSize: Constants.defaultTextSize)
    }
    
    private func setupUI() {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: Images.backgroundImage)
        backgroundImage.contentMode = .scaleAspectFill
        
        view.insertSubview(backgroundImage, at: Constants.null)
        view.addSubview(contentView)
        view.addSubview(sevenDaysForecastButton)
        view.addSubview(otherCitiesForecastButton)
        contentView.addSubview(activityIndicator)
        contentView.addSubview(temperatureLabel)
        contentView.addSubview(weatherConditionsLabel)
        contentView.addSubview(feelsLikeTemperatureLabel)
        contentView.addSubview(windSpeedLabel)
        contentView.addSubview(cloudsLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.topPadding),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.defaultPadding),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.defaultPadding),
            contentView.heightAnchor.constraint(equalToConstant: Constants.contentViewHeight),
            
            activityIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            temperatureLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.topPadding),
            temperatureLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: Constants.tempCenterXPadding),
            
            weatherConditionsLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: Constants.weatherTopPadding),
            weatherConditionsLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            feelsLikeTemperatureLabel.topAnchor.constraint(equalTo: weatherConditionsLabel.bottomAnchor, constant: Constants.defaultPadding),
            feelsLikeTemperatureLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.smallPadding),
            
            windSpeedLabel.topAnchor.constraint(equalTo: feelsLikeTemperatureLabel.bottomAnchor, constant: Constants.smallPadding),
            windSpeedLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.smallPadding),
            
            cloudsLabel.topAnchor.constraint(equalTo: windSpeedLabel.bottomAnchor, constant: Constants.smallPadding),
            cloudsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.smallPadding),
            
            sevenDaysForecastButton.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: Constants.defaultPadding),
            sevenDaysForecastButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.defaultPadding),
            sevenDaysForecastButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.defaultPadding),
            sevenDaysForecastButton.heightAnchor.constraint(equalToConstant: Constants.heightAnchor),
            
            otherCitiesForecastButton.topAnchor.constraint(equalTo: sevenDaysForecastButton.bottomAnchor, constant: Constants.defaultPadding),
            otherCitiesForecastButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.defaultPadding),
            otherCitiesForecastButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.defaultPadding),
            otherCitiesForecastButton.heightAnchor.constraint(equalToConstant: Constants.heightAnchor)
        ])
    }
    
    // MARK: - @Objc Methods
    @objc func sevenDaysForecastButtonTap() {
        mainViewControllerCoordinator?.runSevenDaysForecast()
    }
    
    @objc func otherCitiesForecastButtonTap() {
        mainViewControllerCoordinator?.runSearchCitiesForWeather()
    }
    
    @objc func refreshButtonAction() {
        locationManager.refreshUserCoordinate()
    }
}

// MARK: - Extensions
extension MainViewController: LocationManagerMainDelegate {
    
    func getLocationDataForMain(latitude: Double, longitude: Double) {
        DataFetch.shared.fetchWeatherData(latitude: latitude, longitude: longitude, isCurrent: true) { [weak self] (fetchResult: WeatherDataModel?) in
            guard let self, let fetchResult else { return }
            self.configuration(weatherData: fetchResult)
            self.stopActivitiIndicator()
        }
    }
}

extension MainViewController {
    
    private func startActivitiIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func stopActivitiIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
}
