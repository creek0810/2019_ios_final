//
//  Weather.swift
//  2019_ios_final
//
//  Created by User15 on 2019/6/12.
//  Copyright © 2019 river. All rights reserved.
//

import Foundation

struct City: Codable {
    var id: String
    var name: String
    var towns: [Town]
}

struct Town: Codable {
    var id: String
    var name: String
}

struct Weather: Codable {
    var img: String?
    var dsec: String?
    var temperature: Int?
    var felt_air_temp: Int?
    var humidity: Int?
    var rainfall: Double?
    var sunrise: String?
    var sunset: String?
    var at: String?
}
struct Special: Codable {
    var title: String
    var status: String
    var at: String
    var desc: String
    var img: String
}
struct WeatherAll: Codable {
    var img: String?
    var dsec: String?
    var temperature: Int?
    var felt_air_temp: Int?
    var humidity: Int?
    var rainfall: Double?
    var sunrise: String?
    var sunset: String?
    var at: String?
    var specials: [Special]?
    var histories: [Weather]?
}
