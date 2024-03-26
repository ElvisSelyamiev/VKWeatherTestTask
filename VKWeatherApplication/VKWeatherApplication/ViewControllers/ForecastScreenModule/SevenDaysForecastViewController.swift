//
//  SevenDaysForecastViewController.swift
//  VKWeatherApplication
//
//  Created by Elvis on 22.03.2024.
//

import UIKit
import Foundation

final class SevenDaysForecastViewController: UIViewController {
    
    // MARK: - Properties
    weak var sevenDaysForecastViewControllerCoordinator: SevenDaysForecastViewControllerCoordinator?
    
    var forecast = [Forecast]()
    
    private lazy var infoButton = UIBarButtonItem(image: .init(systemName: Images.infoBarButton), style: .plain, target: self, action: #selector(infoButtonAction))
    
    private let locationManager = LocationManager()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        activity.translatesAutoresizingMaskIntoConstraints = false
        activity.color = .black
        activity.style = .large
        return activity
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white.withAlphaComponent(Constants.colorOpacity)
        tableView.layer.cornerRadius = Constants.cornerRadius
        return tableView
    }()
    
    private let infoAlertController: UIAlertController = {
        let alert = UIAlertController(
            title: Strings.alertTitle,
            message: Strings.alertMessage,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: Strings.alertActionTitle, style: .default, handler: nil)
        alert.addAction(okAction)
        return alert
    }()
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.forecastDelegate = self
        setupViews()
        startActivitiIndicator()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        locationManager.locationDataRequest()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        stopActivitiIndicator()
        reloadTableView()
    }
    
    // MARK: - Private Methods
    private func setupViews() {
        navigationItem.rightBarButtonItem = infoButton
        title = Strings.sevenDaysScreenTitle
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: Images.backgroundImage)
        backgroundImage.contentMode = .scaleAspectFill
        
        view.insertSubview(backgroundImage, at: Constants.null)
        view.addSubview(tableView)
        tableView.addSubview(activityIndicator)
        setupTableView()
        setupConstraints()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        registerCell()
    }
    
    private func registerCell() {
        tableView.register(SevenDaysForcastTableViewCell.self, forCellReuseIdentifier: Strings.cellReuseIdentifier)
    }
    
    private func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.smallPadding),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.defaultPadding),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.defaultPadding),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.defaultPadding),
            
            activityIndicator.centerYAnchor.constraint(equalTo: tableView.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: tableView.centerXAnchor)
        ])
    }
    
    // MARK: - @Objc Methods
    @objc private func infoButtonAction() {
        present(infoAlertController, animated: true, completion: nil)
    }
}

// MARK: - TableView DataSource
extension SevenDaysForecastViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecast.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SevenDaysForcastTableViewCell = tableView.dequeueReusableCell(withIdentifier: Strings.cellReuseIdentifier, for: indexPath) as! SevenDaysForcastTableViewCell
        let model = forecast[indexPath.row]
        cell.configureCell(model: model)
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105
    }
}

// MARK: - Extensions
extension SevenDaysForecastViewController: LocationManagerForecastDelegate {
    
    func getLocationDataForForecast(latitude: Double, longitude: Double) {
        DataFetch.shared.fetchWeatherData(latitude: latitude, longitude: longitude, isCurrent: false) { [weak self] (fetchResult: ForecastDataModel?) in
            guard let self, let fetchResult else { return }
            self.forecast = fetchResult.list
        }
    }
}

extension SevenDaysForecastViewController {
    
    private func startActivitiIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func stopActivitiIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
}
