//
//  SearchCitiesForWeatherViewController.swift
//  VKWeatherApplication
//
//  Created by Elvis on 25.03.2024.
//

import UIKit
import Foundation

final class SearchCitiesForWeatherViewController: UIViewController {

    // MARK: - Properties
    weak var searchCitiesForWeatherViewControllerCoordinator: SearchCitiesForWeatherViewControllerCoordinator?
    
    private let apiKey = "05ae9b1853710fdb76aa88d4d2f2cc7b"
    
    private let searchController = UISearchController(searchResultsController: nil)
    private let activityIndicator = UIActivityIndicatorView()
    private let contentView = UIView()
    private let placeholderInfoLabel = UILabel()
    private let temperatureLabel = UILabel()
    private let weatherConditionsLabel = UILabel()
    private let feelsLikeTemperatureLabel = UILabel()
    private let windSpeedLabel = UILabel()
    private let cloudsLabel = UILabel()
    
    private var timer: Timer?

    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTamic()
        setupSearchBar()
        setupUI()
        settingUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        placeholderInfoLabel.isHidden = false
    }
    
    // MARK: - Private Methods
    private func setupSearchBar() {
        navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.searchBar.delegate = self
    }
    
    private func setupTamic() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        placeholderInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        weatherConditionsLabel.translatesAutoresizingMaskIntoConstraints = false
        feelsLikeTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        windSpeedLabel.translatesAutoresizingMaskIntoConstraints = false
        cloudsLabel.translatesAutoresizingMaskIntoConstraints = false
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
        contentView.backgroundColor = .white.withAlphaComponent(Constants.colorOpacity)
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = Constants.cornerRadius
        
        placeholderInfoLabel.text = Strings.placholderInfo
        placeholderInfoLabel.numberOfLines = Constants.null
        placeholderInfoLabel.textAlignment = .center
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
        contentView.addSubview(activityIndicator)
        contentView.addSubview(placeholderInfoLabel)
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
            
            placeholderInfoLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            placeholderInfoLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

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
        ])
    }
}

// MARK: - Extensions, SearchBarDelegate
extension SearchCitiesForWeatherViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: { [weak self] (_) in
            guard let self else { return }
            self.placeholderInfoLabel.isHidden = true
            self.startActivitiIndicator()
            
            let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(searchText)&lang=ru&units=metric&appid=\(self.apiKey)"
            guard let url = URL(string: urlString) else { return }
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if let data = data {
                    let fetchResult = DataFetch.shared.decodeJSON(type: WeatherDataModel.self, from: data)
                    guard let fetchResult else { return }
                    DispatchQueue.main.async {
                        self.configuration(weatherData: fetchResult)
                        self.stopActivitiIndicator()
                    }
                }
            }
            task.resume()
        })
    }
}

extension SearchCitiesForWeatherViewController {
    
    private func startActivitiIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func stopActivitiIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
}
