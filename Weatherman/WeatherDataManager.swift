//
//  Weather.swift
//  WeatherBoy
//
//  Created by 이영빈 on 2022/01/29.
//

import Foundation
import Combine

class WeatherDataManager {
    enum WeatherError: Error, CustomStringConvertible {
        case network
        case parsing
        case fetching
        
        var description: String {
            switch self {
            case .network:
                return "Network error"
            case .parsing:
                return "Parsing error"
            case .fetching:
                return "File fetching error"
            }
        }
    }
    
    // MARK: Downloading current weather of the city from api server
    static func currentWeatherPublisher(name: String) -> AnyPublisher<CurrentWeatherResponse, Error> {
        // Get path of APIKeys.plist
        guard let path = Bundle.main.path(forResource: "APIKeys", ofType: "plist") else {
            return Fail(error: WeatherError.fetching as Error).eraseToAnyPublisher()
        }
        
        // Fetch my api key from APIKeys.plist
        var weatherAPIKey: String?
        do {
            let keyDictUrl = URL(fileURLWithPath: path)
            let data = try Data(contentsOf: keyDictUrl)
            let keyDict = try PropertyListDecoder().decode([String: String].self, from: data)
            weatherAPIKey = keyDict["OpenWeatherAPIKey"]
        } catch  {
            return Fail(error: error).eraseToAnyPublisher()
        }
         
        // Make URLSession.datapublisher which requests informations from the server
        let session = URLSession.shared
        let decoder = JSONDecoder()
        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(name)&appid=\(weatherAPIKey!)")
        
        return session.dataTaskPublisher(for: url!)
            .map(\.data)
            .decode(type: CurrentWeatherResponse.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
}
