//
//  AirQuality.swift
//  AirQuality
//
//  Created by Benjamin Tincher on 1/28/21.
//

import Foundation

struct CountryTopLevel: Codable {
    let status: String
    let data: [CountryData]
    
    struct CountryData: Codable {
        let country: String
    }
}

struct StateTopLevel: Codable {
    let status: String
    let data: [StateData]
    
    struct StateData: Codable {
        let state: String
    }
}

struct CityTopLevel: Codable {
    let status: String
    let data: [CityData]
    
    struct CityData: Codable {
        let city: String
    }
}

struct CityReportTopLevel: Codable {
    let status: String
    let data: CityReport
    
    struct CityReport: Codable {
        let city: String
        let state: String
        let country: String
        let location: LocationObject
        let current: CurrentObject
        
        struct LocationObject: Codable {
            let coordinates: [Double]
        }
        
        struct CurrentObject: Codable {
            let weather: WeatherObject
            let pollution: PollutionObject
            
            struct WeatherObject: Codable {
                let tp: Int
                let ws: Double
                let hu: Int
            }
            
            struct PollutionObject: Codable {
                let aqius: Int
            }
        }
    }
}
