//
//  DataFetch.swift
//  VKWeatherApplication
//
//  Created by Elvis on 24.03.2024.
//

import Foundation

final class DataFetch {
    
    static let shared = DataFetch()
    private var apiManager = ApiManager()
    
    func fetchWeatherData<T: Codable>(latitude: Double, longitude: Double, isCurrent: Bool, comletionHandler: @escaping (T?) -> ()) {
        self.apiManager.request(latitude: latitude, longitude: longitude, isCurrent: isCurrent) { (data, error) in
                if error != nil {
                    print("Error: \(String(describing: error?.localizedDescription))")
                    comletionHandler(nil)
                }
                
                let decode = self.decodeJSON(type: T.self, from: data)
                comletionHandler(decode)
        }
    }
    
    func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        guard let data = from else { return nil }
        
        do {
            let objects = try decoder.decode(type.self, from: data)
            return objects
            
        } catch let jsonError {
            print("JSONError: ", jsonError)
            return nil
        }
    }
}
