//
//  NetworkDataFetch.swift
//  VKWeatherApplication
//
//  Created by Elvis on 23.03.2024.
//

import Foundation

final class ApiManager {
    
    private let apiKey = "05ae9b1853710fdb76aa88d4d2f2cc7b"
    
    func request(latitude: Double, longitude: Double, isCurrent: Bool, completionHandler: @escaping (Data?, Error?) -> Void) {
        let parameters = self.getParameters(lat: latitude, lon: longitude, isCurrent: isCurrent)
        let url = self.url(parameters: parameters, isCurrent: isCurrent)
        var request = URLRequest(url: url)
        request.httpMethod = "get"
        let task = dataTask(request, completionHandler: completionHandler)
        task.resume()
    }
    
    private func url(parameters: [String : String], isCurrent: Bool) -> URL {
        let path = isCurrent ? "weather" : "forecast"
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.openweathermap.org"
        components.path = "/data/2.5/" + path
        components.queryItems = parameters.map { URLQueryItem(name: $0, value: $1)}
        return components.url!
    }
    
    private func getParameters(lat: Double, lon: Double, isCurrent: Bool) -> [String: String] {
        var parameters = [String: String]()
        parameters["lat"] = String(lat)
        parameters["lon"] = String(lon)
        parameters["units"] = "metric"
        parameters["lang"] = "ru"
        if !isCurrent { parameters["cnt"] = "7"}
        parameters["appid"] = apiKey
        return parameters
    }
    
    private func dataTask(_ request: URLRequest, completionHandler: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask {
        
        return URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                completionHandler(data, error)
            }
        }
    }
}
