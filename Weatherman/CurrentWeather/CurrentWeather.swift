//
//  CurrentWeather.swift
//  WeatherBoy
//
//  Created by 이영빈 on 2022/01/30.
//

import Foundation
import SwiftUI
import MapKit
import Combine

struct CurrentWeatherResponse: Decodable {
    let coord: Coord
    let main: Main
    let weather: [Weather]
    let wind: Wind
    let name: String
    
    struct Wind: Codable {
        let speed: Double
    }
    
    struct Weather: Codable {
        let weather: String
        let iconName: String
        let description: String
        
        enum CodingKeys: String, CodingKey {
            case weather = "main"
            case iconName = "icon"
            case description
        }
    }
    
    struct Main: Codable {
        let temperature: Double
        let feelsLike: Double
        let humidity: Int
        let pressure: Int
        let maxTemperature: Double
        let minTemperature: Double
        
        enum CodingKeys: String, CodingKey {
            case temperature = "temp"
            case feelsLike = "feels_like"
            case humidity
            case pressure
            case maxTemperature = "temp_max"
            case minTemperature = "temp_min"
        }
    }
    
    struct Coord: Codable {
        let lon: Double
        let lat: Double
    }
}


class CurrentWeather: ObservableObject {
    @Published var icon: Image?
    private let item: CurrentWeatherResponse
    var subscriptions = Set<AnyCancellable>()
    
    private func toCelcius(from kelvin: Double) -> Double {
        return kelvin - 273.15
    }
    
    var name: String {
        if item.name.contains("-") {
            return String(item.name.split(separator: "-").first!)
        } else if item.name.contains(" ") {
            return String(item.name.split(separator: " ").first!)
        } else {
            return item.name
        }
    }
    
    var weather: String {
        return item.weather[0].weather
    }
    
    var weatherIconAddress: URL {
        return URL(string: "https://openweathermap.org/img/w/\(item.weather[0].iconName).png")!
    }
    
    var speed: String {
        return String(format: "%.1f", item.wind.speed)
    }
    
    var temperature: String {
        let celcius = toCelcius(from: item.main.temperature)
        return String(format: "%.1f", celcius)
    }
    
    var temperatureFeelsLike: String {
        let celcius = toCelcius(from: item.main.feelsLike)
        return String(format: "%.1f", celcius)
    }
    
    var maxTemperature: String {
        let celcius = toCelcius(from: item.main.maxTemperature)
        return String(format: "%.1f", celcius)
    }
    
    var minTemperature: String {
        let celcius = toCelcius(from: item.main.minTemperature)
        return String(format: "%.1f", celcius)
    }
    
    var humidity: String {
        return String(format: "%d", item.main.humidity)
    }
    
    var pressure: String {
        return String(format: "%d", item.main.pressure)
    }
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D.init(latitude: item.coord.lat, longitude: item.coord.lon)
    }
    
    private func getIconImage() {
        
    }
    
    init(item: CurrentWeatherResponse) {
        self.item = item
        
        let session = URLSession.shared
        let url = URL(string: "https://openweathermap.org/img/w/\(item.weather[0].iconName).png")!
        session.dataTask(with: url) { data, response, error in
            if error == nil, let data = data {
                let downloadedImage = UIImage(data: data)!
                DispatchQueue.main.async {
                    self.icon = Image(uiImage: downloadedImage)
                }
            }
            else {
                print("Error while downloading icon image data")
                return
            }
        }
        .resume()
    }
}

extension CurrentWeather: Hashable {
  static func == (lhs: CurrentWeather, rhs: CurrentWeather) -> Bool {
    return lhs.name == rhs.name
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(self.name)
  }
}
