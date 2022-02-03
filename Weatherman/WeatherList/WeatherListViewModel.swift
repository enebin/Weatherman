//
//  WeatherListViewModel.swift
//  WeatherBoy
//
//  Created by 이영빈 on 2022/02/02.
//

import SwiftUI
import Combine

class WeatherListViewModel: ObservableObject {
    @Published var city: String = ""
    @Published var cityViewSource = [CurrentWeather]()
    
    var sortCityBy: SortWeatherBy {
        willSet {
            cityViewSource.sort(by: { newValue.execute($0, $1) })
        }
    }
    
    private let cityList =
    [
        "Seoul", "Busan", "Gwangju", "Gongju", "Gumi", "Gunsan", "Daegu", "Daejeon", "Mokpo", "Seosan", "Sokcho", "Suwon", "Suncheon", "Ulsan", "Iksan", "Jeonju", "Jeju", "Cheonan", "Cheongju", "Chuncheon"
    ]
    
    private var subsriptions = Set<AnyCancellable>()
    
    func fetchWeather() {
        cityViewSource = []
        _ = cityList
            .map({ city in
                WeatherDataManager.currentWeatherPublisher(name: city)
                    .map(CurrentWeather.init)
                    .receive(on: DispatchQueue.main)
                    .sink(receiveCompletion: { response in
                        switch response {
                        case .failure(let error):
                            print("Failed with error: \(error)")
                            return
                        case .finished:
                            print("Succeesfully finished!")
                        }
                    }, receiveValue: { value in
                        self.cityViewSource.append(value)
                    })
                    .store(in: &subsriptions)
            })
    }
    
    init(schduler: DispatchQueue = DispatchQueue(label: "WeatherListViewModel")) {
        self.sortCityBy = .alphabet
        self.fetchWeather()
    }
}
