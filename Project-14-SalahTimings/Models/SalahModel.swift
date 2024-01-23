//
//  SalahModel.swift
//  Project-14-SalahTimings
//
//  Created by suhail on 20/01/24.
//

import Foundation


struct SalahModel: Codable {
 
    
    let query: String
    let today_weather: TodayWeather?
    let qibla_direction: String
    let latitude: String
    let longitude: String
    let items: [PrayerItem]
   
}

struct TodayWeather: Codable {
    let pressure: String?
    let temperature: String
    
    init(pressure: String? = nil, temperature: String) {
           self.pressure = pressure
           self.temperature = temperature
           
       }
    
    init(from decoder: Decoder) throws {
           let container = try decoder.container(keyedBy: CodingKeys.self)
        temperature = try container.decode(String.self, forKey: .temperature)
           do {
               pressure = try String(container.decode(Int.self, forKey: .pressure))
           } catch DecodingError.typeMismatch {
               pressure = try container.decode(String.self, forKey: .pressure)
           }
       }
    
    
}

struct PrayerItem: Codable {
    let fajr, dhuhr, asr, maghrib, isha: String
}



