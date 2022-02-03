//
//  Formatter.swift
//  WeatherBoy
//
//  Created by 이영빈 on 2022/02/01.
//

import Foundation

let dayFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "EEEE"
    return formatter
}()

let monthFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMMM"
    return formatter
}()

let hourFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH"
    return formatter
}()
