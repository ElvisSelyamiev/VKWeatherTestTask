//
//  WeatherModel.swift
//  VKWeatherApplication
//
//  Created by Elvis on 23.03.2024.
//

import Foundation

struct WeatherDataModel: Codable {
    let main: Main
    let weather: [Weather]
    let wind: Wind
    let clouds: Clouds
    let name: String
}

struct Main: Codable {
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

struct Weather: Codable {
    let main: String
    let description: String
}

struct Wind: Codable {
    let speed: Double
    var speedString: String {
        return "\(speed)"
    }
}

struct Clouds: Codable {
    let all: Int
    var allString: String {
        return "\(all)"
    }
}
