//
//  SevenDaysForcastTableViewCell.swift
//  VKWeatherApplication
//
//  Created by Elvis on 25.03.2024.
//

import UIKit

final class SevenDaysForcastTableViewCell: UITableViewCell {

    // MARK: - Properties
    private let tempLabel = UILabel()
    private let feelsLikeLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let dateLabel = UILabel()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    private func setupViews(){
        tempLabel.translatesAutoresizingMaskIntoConstraints = false
        feelsLikeLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        tempLabel.font = .boldSystemFont(ofSize: Constants.cellLargeTextSize)
        dateLabel.font = .boldSystemFont(ofSize: Constants.havyTextSize)
        feelsLikeLabel.font = .systemFont(ofSize: Constants.defaultTextSize)
        descriptionLabel.font = .systemFont(ofSize: Constants.defaultTextSize)
        
        addSubview(tempLabel)
        addSubview(feelsLikeLabel)
        addSubview(descriptionLabel)
        addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.cellTopPadding),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.cellSmallPadding),
            
            tempLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: Constants.cellSmallPadding),
            tempLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.smallPadding),
            
            feelsLikeLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: Constants.smallPadding),
            feelsLikeLabel.leadingAnchor.constraint(equalTo: tempLabel.trailingAnchor, constant: Constants.smallPadding),
            
            descriptionLabel.topAnchor.constraint(equalTo: feelsLikeLabel.bottomAnchor, constant: Constants.cellTopPadding),
            descriptionLabel.leadingAnchor.constraint(equalTo: tempLabel.trailingAnchor, constant: Constants.smallPadding)
        ])
    }
    
    // MARK: - Configure Cell
    func configureCell(model: Forecast) {
        tempLabel.text = "\(model.main.tempString)º"
        feelsLikeLabel.text = Strings.feelsLikeTitle + "\(model.main.feelsLikeString)º"
        descriptionLabel.text = model.weather.last?.description
        dateLabel.text = model.dtTxt
    }

}
