//
//  DetailedCurrentWeatherView.swift
//  WeatherBoy
//
//  Created by 이영빈 on 2022/01/31.
//

import SwiftUI

struct CurrentWeatherView: View {
    @ObservedObject var viewModel: CurrentWeather
    var body: some View {
        ZStack {
            // Background color. LinearGradient in this case
            Background
                .ignoresSafeArea()
            
            VStack {
                // Weather description with icon ahead
                WeatherWithIcon
                
                // Main Temp
                Text("\(viewModel.temperature)º")
                    .font(.system(size: 100))
                    .foregroundColor(.white)
                
                // Min/Max Temp
                MinAndMaxTemp
                
                Spacer()
                Divider()
                
                // Temp feels like
                TempFeelsLike
                    .padding(.vertical)
                    .padding(.top, 35)
                    .padding(.horizontal)

                // For more informations(ATM, wind speed, Humidity)
                MoreInformations
                    .padding(.horizontal)
                    .padding(.bottom, 35)
                
                // Button that navigates to another view.
                NavigateButton
                    .padding(.bottom, 15)
            }
        }
        .navigationBarTitle("\(viewModel.name)")
        .navigationBarTitleTextColor(.white)    // Personally added method. It changes navigation bar item's color.
        .navigationBarTitleDisplayMode(.inline)
    }
}

extension CurrentWeatherView {
    var Background: some View {
        let startColor: Color
        let endColor: Color
        
        switch viewModel.weather.lowercased() {
        case "clouds":
            startColor = Color(red: 71/255, green: 110/255, blue: 168/255)
            endColor = Color(red: 173/255, green: 207/255, blue: 246/255)
            break
        case "clear":
            startColor = Color(red: 8/255, green: 102/255, blue: 246/255)
            endColor = Color(red: 173/255, green: 207/255, blue: 246/255)
            break
        case "rain":
            startColor = Color(red: 55/255, green: 55/255, blue: 55/255)
            endColor = Color(red: 149/255, green: 161/255, blue: 174/255)
            break
        case "snow":
            startColor = Color(red: 55/255, green: 55/255, blue: 55/255)
            endColor = Color(red: 149/255, green: 161/255, blue: 174/255)
            break
        default:
            startColor = Color(red: 167/255, green: 210/255, blue: 172/255)
            endColor = Color(red: 95/255, green: 218/255, blue: 108/255)
            break
        }
        
        return LinearGradient(colors: [startColor, endColor],
                       startPoint: .topLeading, endPoint: .bottomTrailing)
    }
    
    var WeatherWithIcon: some View {
        HStack {
            if let icon = viewModel.icon {
                icon
            }
            Text("\(viewModel.weather)")
        }
        .foregroundColor(.white)
        .font(.system(size: 25))
    }

    var MinAndMaxTemp: some View {
        HStack(spacing: 15) {
            VStack {
                Text("min")
                    .foregroundColor(.white)
                Text("\(viewModel.minTemperature)º")
                    .foregroundColor(.blue)
            }
            VStack {
                Text("max")
                    .foregroundColor(.white)
                Text("\(viewModel.maxTemperature)º")
                    .foregroundColor(.red)
            }
        }
        .font(.system(size: 25))
    }
    
    var TempFeelsLike: some View {
        HStack{
            VStack(alignment: .leading) {
                Text("Temperature feels like")
                    .padding(.bottom, 10)
                    .font(.system(size: 20))
                Text("\(viewModel.temperatureFeelsLike)º")
                    .font(.system(size: 25))
                    .bold()
            }
            Spacer()
        }
        .foregroundColor(.white)
    }
    
    var MoreInformations: some View {
        HStack {
            VStack {
                Text("ATM")
                    .font(.system(size: 20))
                    .padding(.bottom, 10)
                FigWithUnit(figure: viewModel.pressure, unit: "hPa")
            }
            Spacer()
            VStack {
                Text("Wind Speed")
                    .font(.system(size: 20))
                    .padding(.bottom, 10)
                FigWithUnit(figure: viewModel.speed, unit: "m/s")

            }
            Spacer()
            VStack {
                Text("Humidity")
                    .font(.system(size: 20))
                    .padding(.bottom, 10)
                FigWithUnit(figure: viewModel.humidity, unit: "%")
            }
        }
        .foregroundColor(.white)
        .font(.system(size: 25))
    }
    
    var NavigateButton: some View {
        NavigationLink(destination:Text("more")) {
            Text("more...")
                .font(.system(size: 20))
                .frame(width: 140, height: 50, alignment: .center)
                .foregroundColor(.white)
                .background(RoundedRectangle(cornerRadius: 10)
                                .fill(.gray.opacity(0.1)))
        }
    }
    
    
    @ViewBuilder
    func FigWithUnit(figure: String, unit: String) -> some View {
        HStack {
            Text("\(figure)")
                .bold()
            Text("\(unit)")
                .font(.subheadline)
        }
    }
}

//struct DetailedCurrentWeatherView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailedCurrentWeatherView()
//    }
//}
