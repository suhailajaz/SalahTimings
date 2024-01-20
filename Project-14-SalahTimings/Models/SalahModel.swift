//
//  SalahModel.swift
//  Project-14-SalahTimings
//
//  Created by suhail on 20/01/24.
//

import Foundation


struct SalahModel: Codable {
 
    
    let city: String
    let today_weather: TodayWeather
    let qibla_direction: String
    let latitude: String
    let longitude: String
    let items: [PrayerItem]
   
}

struct TodayWeather: Codable {
    let pressure: Int
    let temperature: String
}

struct PrayerItem: Codable {
    let fajr, dhuhr, asr, maghrib, isha: String
}



