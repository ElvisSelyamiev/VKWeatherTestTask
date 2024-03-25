//
//  ForecastDataModel.swift
//  VKWeatherApplication
//
//  Created by Elvis on 25.03.2024.
//

import Foundation

struct ForecastDataModel: Codable {
    let list: [Forecast]
}

struct Forecast: Codable {
    let main: ForecastMain
    let weather: [ForecastWeather]
    let dtTxt: String
    
    enum CodingKeys: String, CodingKey {
        case main
        case weather
        case dtTxt = "dt_txt"
    }
}

struct ForecastMain: Codable {
    let temp: Double
    var tempString: String {
        return "\(Int(temp.rounded()))"
    }
    
    let feelsLike: Double
    var feelsLikeString: String {
        return "\(Int(feelsLike.rounded()))"
    }
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
    }
}

struct ForecastWeather: Codable {
    let main: String
    let description: String
}
