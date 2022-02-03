//
//  ContentView.swift
//  WeatherBoy
//
//  Created by 이영빈 on 2022/01/29.
//

import SwiftUI

struct WeatherListView: View {
    @ObservedObject var viewModel = WeatherListViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                Background
                    .ignoresSafeArea()
                
                VStack {
                    SearchField
                    RefreshAndSort
                        .padding(.horizontal)
                    WeatherList
                }
            }
            .navigationBarHidden(true)
        }
    }
}

extension WeatherListView {
    var Background: some View {
        LinearGradient(colors: [Color(red: 71/255, green: 110/255, blue: 168/255),
                                Color(red: 6/255, green: 9/255, blue: 28/255)],
                       startPoint: .topLeading, endPoint: .bottomTrailing)
        
    }
    
    var RefreshAndSort: some View {
        HStack {
            Button(action: {viewModel.fetchWeather()}) {
                Image(systemName: "arrow.clockwise")
                    .frame(width: 50, height: 50, alignment: .center)
                    .foregroundColor(.white)
            }
            Spacer()
            Picker(selection: $viewModel.sortCityBy) {
                ForEach(WeatherListViewModel.SortWeatherBy.allCases, id: \.self) { by in
                    HStack {
//                        Image(systemName: by.imageName)
                        Text(by.rawValue)
                    }
                }
            } label: {
                Image(systemName: "arrow.up.arrow.down")
                    .frame(width: 50, height: 50, alignment: .center)
                    .foregroundColor(.white)
            }
            .pickerStyle(.menu)
            .colorMultiply(.black)
        }
    }
    
    var WeatherList: some View {
        ScrollView {
            VStack(spacing: 20) {
                if (viewModel.cityViewSource.count != 20) {
                    Spacer()
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .foregroundColor(.white)
                } else {
                    ForEach(viewModel.cityViewSource.filter({
                        viewModel.city == "" ? true : $0.name.localizedCaseInsensitiveContains(viewModel.city)
                    }),
                            id: \.self) { source in
                        NavigationLink(destination: CurrentWeatherView(viewModel: source)) {
                            CurrentWeatherRowView(viewModel: source)
                        }
                    }
                    .foregroundColor(.white)
                }
            }
        }
    }
    
    var SearchField: some View {
        VStack {
            Text("Where do you want to know?")
                .font(.system(size: 20))
                .foregroundColor(.white)
                .padding(.top)
                .padding(.vertical, 10)

            if #available(iOS 15.0, *) {
                TextField("e.g Seoul ", text: $viewModel.city)
                    .padding()
                    .foregroundColor(.white)
                    .background(.white.opacity(0.17))
                    .cornerRadius(10)
                    .frame(width: 300, height: 50, alignment: .center)
                    .shadow(color: .black, radius: 5, x: 0, y: 2)
                    .padding(.vertical, 10)
            } else {
                // Fallback on earlier versions
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherListView()
    }
}
