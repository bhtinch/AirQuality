//
//  AirQuality.swift
//  AirQuality
//
//  Created by Maxwell Poffenbarger on 12/16/20.
//

import Foundation

//MARK: - Country List
struct Country: Codable {
    
    let status: String
    let data: [Data]
    
    struct Data: Codable {
        let countryName: String
        
        enum CodingKeys: String, CodingKey {
            case countryName = "country"
        }
    }
}//End of country list struct

//MARK: - State List
struct State: Codable {
    
    let status: String
    let data: [Data]
    
    struct Data: Codable {
        let stateName: String
        
        enum CodingKeys: String, CodingKey {
            case stateName = "state"
        }
    }
}//End of state struct

//MARK: - City List
struct City: Codable {
    
    let status: String
    let data: [Data]
    
    struct Data: Codable {
        let cityName: String
        
        enum CodingKeys: String, CodingKey {
            case cityName = "city"
        }
    }
}//End of city struct

//MARK: - City Data
struct CityData: Codable {
    
    let status: String
    let data: Data
    
    struct Data: Codable {
        
        let city: String
        let state: String
        let country: String
        let location: Location
        let current: Current
        
        struct Location: Codable {
            let type: String
            let coordinates: [Double]
        }
        
        struct Current: Codable {
            
            let weather: Weather
            let pollution: Pollution
            
            struct Weather: Codable {
                let ts: String
                let tp: Int
                let pr: Int
                let hu: Int
                let ws: Double
                let wd: Int
                let ic: String
            }
            
            struct Pollution: Codable {
                let ts: String
                let aqius: Int
                let mainus: String
                let aqicn: Int
                let maincn: String
            }
        }
    }
}//End of cityData struct
