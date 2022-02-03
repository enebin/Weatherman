//
//  CurrentWeatherRowView.swift
//  WeatherBoy
//
//  Created by 이영빈 on 2022/01/31.
//

import SwiftUI

struct CurrentWeatherRowView: View {
    @ObservedObject var viewModel: CurrentWeather
    var body: some View {
        HStack {
            Text("\(viewModel.name)")
                .bold()
            Spacer()
            
            Text("\(viewModel.temperature)º")
                .padding(.trailing)
            Text("\(viewModel.humidity)%")
                .foregroundColor(.gray)
            Spacer()
            
            if let icon = viewModel.icon {
                icon
            } else {
                Image(systemName: "xmark")
            }
        }
        .font(.system(size: 20))
        .padding(.horizontal)
    }
        
    init(viewModel: CurrentWeather) {
        self.viewModel = viewModel
    }
            
}

//struct CurrentWeatherRowView_Previews: PreviewProvider {
//    static var previews: some View {
////        CurrentWeatherRowView(viewModel: CurrentWeatherForecast(i))
//    }
//}
