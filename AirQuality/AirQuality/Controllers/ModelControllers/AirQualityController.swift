//
//  AirQualityController.swift
//  AirQuality
//
//  Created by Maxwell Poffenbarger on 1/5/21.
//

import Foundation

class AirQualityController {
    
    static let baseURLString = URL(string: "https://api.airvisual.com/")
    static let version = "v2"
    static let countryComponent = "countries"
    static let stateComponent = "states"
    static let cityComponent = "cities"
    static let cityDataComponent = "city"
    /// You will need to register for your own api key and replace the string below with your api key.
    static let apiKey = "04b27ce2-de9d-4cd6-b27d-0e494e0c4993"
    static let nearestCityComponent = "nearest_city"
    
    static func fetchSupportedCountries(then completion: @escaping (Result<[String], NetworkError>) -> Void) {
        
        guard let baseURL = baseURLString else {return completion(.failure(.invalidURL))}
        let versionURL = baseURL.appendingPathComponent(version)
        let countryURL = versionURL.appendingPathComponent(countryComponent)
        
        var components = URLComponents(url: countryURL, resolvingAgainstBaseURL: true)
        let apiQuery = URLQueryItem(name: "key", value: apiKey)
        components?.queryItems = [apiQuery]
        
        guard let finalURL = components?.url else {return completion(.failure(.invalidURL))}
        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) { (data, response, error) in
            
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            if let response = response as? HTTPURLResponse{
                print("COUNTRY LIST STATUS CODE: \(response.statusCode)")
            }
            
            guard let data = data else {return completion(.failure(.noData))}
            
            do {
                let topLevelObject = try JSONDecoder().decode(Country.self, from: data)
                let countryDictionaries = topLevelObject.data
                var listOfCountryNames: [String] = []
                
                for countryDict in countryDictionaries {
                    let countryName = countryDict.countryName
                    listOfCountryNames.append(countryName)
                }
                
                return completion(.success(listOfCountryNames))
                
            } catch {
                completion(.failure(.thrownError(error)))
            }
        }.resume()
    }//end of func
    
    static func fetchSupportedStates(forCountry: String, then completion: @escaping (Result<[String], NetworkError>) -> Void) {
        
        guard let baseURL = baseURLString else {return completion(.failure(.invalidURL))}
        let versionURL = baseURL.appendingPathComponent(version)
        let statesURL = versionURL.appendingPathComponent(stateComponent)
        
        var components = URLComponents(url: statesURL, resolvingAgainstBaseURL: true)
        let apiQuery = URLQueryItem(name: "key", value: apiKey)
        let countryQuery = URLQueryItem(name: "country", value: forCountry)
        components?.queryItems = [countryQuery, apiQuery]
        
        guard let finalURL = components?.url else {return completion(.failure(.invalidURL))}
        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) { (data, response, error) in
            
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            if let response = response as? HTTPURLResponse{
                print("STATE LIST STATUS CODE: \(response.statusCode)")
            }
            
            guard let data = data else {return completion(.failure(.noData))}
            
            do {
                let topLevelObject = try JSONDecoder().decode(State.self, from: data)
                let stateDictionaries = topLevelObject.data
                var listOfStateNames: [String] = []
                
                for stateDict in stateDictionaries {
                    let stateName = stateDict.stateName
                    listOfStateNames.append(stateName)
                }
                
                return completion(.success(listOfStateNames))
                
            } catch {
                completion(.failure(.thrownError(error)))
            }
        }.resume()
    }//end of func
    
    static func fetchSupportedCities(forState: String, inCountry: String, then completion: @escaping (Result<[String], NetworkError>) -> Void) {
        
        guard let baseURL = baseURLString else {return completion(.failure(.invalidURL))}
        let versionURL = baseURL.appendingPathComponent(version)
        let citiesURL = versionURL.appendingPathComponent(cityComponent)
        
        var components = URLComponents(url: citiesURL, resolvingAgainstBaseURL: true)
        let apiQuery = URLQueryItem(name: "key", value: apiKey)
        let countryQuery = URLQueryItem(name: "country", value: inCountry)
        let stateQuery = URLQueryItem(name: "state", value: forState)
        components?.queryItems = [stateQuery, countryQuery, apiQuery]
        
        guard let finalURL = components?.url else {return completion(.failure(.invalidURL))}
        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) { (data, response, error) in
            
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            if let response = response as? HTTPURLResponse{
                print("CITY LIST STATUS CODE: \(response.statusCode)")
            }
            
            guard let data = data else {return completion(.failure(.noData))}
            
            do {
                let topLevelObject = try JSONDecoder().decode(City.self, from: data)
                let cityDictionaries = topLevelObject.data
                var listOfCityNames: [String] = []
                
                for cityDict in cityDictionaries {
                    let cityName = cityDict.cityName
                    listOfCityNames.append(cityName)
                }
                
                return completion(.success(listOfCityNames))
                
            } catch {
                completion(.failure(.thrownError(error)))
            }
        }.resume()
    }//end of func
    
    static func fetchData(forCity: String, inState: String, inCountry: String, then completion: @escaping (Result<CityData, NetworkError>) -> Void) {
        
        guard let baseURL = baseURLString else {return completion(.failure(.invalidURL))}
        let versionURL = baseURL.appendingPathComponent(version)
        let citiesURL = versionURL.appendingPathComponent(cityDataComponent)
        
        var components = URLComponents(url: citiesURL, resolvingAgainstBaseURL: true)
        let apiQuery = URLQueryItem(name: "key", value: apiKey)
        let countryQuery = URLQueryItem(name: "country", value: inCountry)
        let stateQuery = URLQueryItem(name: "state", value: inState)
        let cityQuery = URLQueryItem(name: "city", value: forCity)
        components?.queryItems = [cityQuery, stateQuery, countryQuery, apiQuery]
        
        guard let finalURL = components?.url else {return completion(.failure(.invalidURL))}
        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) { (data, response, error) in
            
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            if let response = response as? HTTPURLResponse{
                print("CITY DATA STATUS CODE: \(response.statusCode)")
            }
            
            guard let data = data else {return completion(.failure(.noData))}
            
            do {
                let cityData = try JSONDecoder().decode(CityData.self, from: data)
                
                return completion(.success(cityData))
                
            } catch {
                completion(.failure(.thrownError(error)))
            }
        }.resume()
    }//end of func
    
    static func fetchNearestCity(then completion: @escaping (Result<CityData, NetworkError>) -> Void) {
        
        guard let baseURL = baseURLString else {return completion(.failure(.invalidURL))}
        let versionURL = baseURL.appendingPathComponent(version)
        let nearestCityURL = versionURL.appendingPathComponent(nearestCityComponent)
        
        var components = URLComponents(url: nearestCityURL, resolvingAgainstBaseURL: true)
        let apiQuery = URLQueryItem(name: "key", value: apiKey)
        
        components?.queryItems = [apiQuery]
        
        guard let finalURL = components?.url else {return completion(.failure(.invalidURL))}
        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) { (data, response, error) in
            
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            if let response = response as? HTTPURLResponse{
                print("NEAREST CITY DATA STATUS CODE: \(response.statusCode)")
            }
            
            guard let data = data else {return completion(.failure(.noData))}
            
            do {
                let cityData = try JSONDecoder().decode(CityData.self, from: data)
                
                return completion(.success(cityData))
                
            } catch {
                completion(.failure(.thrownError(error)))
            }
        }.resume()
    }//end of func
}//End of class
