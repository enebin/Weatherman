//
//  WeatherListVIewModel+Enum.swift
//  WeatherBoy
//
//  Created by 이영빈 on 2022/02/02.
//

extension WeatherListViewModel {
    enum SortWeatherBy: String, CaseIterable {
        case temperature = "temperature"
        case humidity = "humidity"
        case alphabet = "alphabet"
        
        var imageName: String {
            switch self {
            case .temperature:
                return "thermometer"

            case .humidity:
                return "drop.fill"

            case .alphabet:
                return "textformat.abc"
            }
        }
        
        func execute(_ lhs: CurrentWeather, _ rhs: CurrentWeather) -> Bool{
            switch self {
            case .temperature:
                return lhs.temperature > rhs.temperature
            case .humidity:
                return lhs.humidity > rhs.humidity
            case .alphabet:
                return lhs.name < rhs.name
            }
        }
    }
}
