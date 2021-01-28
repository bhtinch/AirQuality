//
//  AirQuatityController.swift
//  AirQuality
//
//  Created by Benjamin Tincher on 1/28/21.
//

import Foundation

class AirQualityController {
    
    static let baseURL = URL(string: "https://api.airvisual.com/")
    static let version = "v2"
    static let countryComponent = "countries"
    static let stateComponent = "states"
    static let cityComponent = "cities"
    static let cityDataComponent = "city"
    static let apiKey = "1403cc44-030e-437a-99dd-899d2a76471e"
    static let nearestCityComponent = "nearest_city"
    
    static func fetchSupportedCountries(completion: @escaping (Result<[String], NetworkError>) -> Void) {
        
        guard let baseURL = baseURL else { return completion(.failure(.invalidURL)) }
        let versionURL = baseURL.appendingPathComponent(version)
        let countryURL = versionURL.appendingPathComponent(countryComponent)
        
        var components = URLComponents(url: countryURL, resolvingAgainstBaseURL: true)
        let apiQuery = URLQueryItem(name: "key", value: apiKey)
        components?.queryItems = [apiQuery]
        
        guard let finalURL = components?.url else { return completion(.failure(.invalidURL)) }
        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) { (data, response, error) in
            if let error = error {
                print("======== ERROR 1 ========")
                print("Function: \(#function)")
                print("Error: \(error)")
                print("Description: \(error.localizedDescription)")
                print("======== ERROR ========")
                return completion(.failure(.thrownError(error)))
            }
            
            if let response = response as? HTTPURLResponse {
                print("Country List Status Code: \(response.statusCode)")
            }
            
            guard let data = data else { return completion(.failure(.noData)) }
            
            do {
                let countryTopLevel = try JSONDecoder().decode(CountryTopLevel.self, from: data)
                let countriesData = countryTopLevel.data
                
                var countries: [String] = []
                
                for country in countriesData {
                    let countryString = country.country
                    countries.append(countryString)
                }
                
                completion(.success(countries))
            } catch {
                print("======== ERROR 2 ========")
                print("Function: \(#function)")
                print("Error: \(error)")
                print("Description: \(error.localizedDescription)")
                print("======== ERROR ========")
                return completion(.failure(.thrownError(error)))
            }
        }.resume()
    }
    
    static func fetchSupportedStates(forCountry country: String, completion: @escaping (Result<[String], NetworkError>) -> Void) {
        
        guard let baseURL = baseURL else { return completion(.failure(.invalidURL)) }
        let versionURL = baseURL.appendingPathComponent(version)
        let statesURL = versionURL.appendingPathComponent(stateComponent)
        
        var components = URLComponents(url: statesURL, resolvingAgainstBaseURL: true)
        let apiQuery = URLQueryItem(name: "key", value: apiKey)
        let countryQuery = URLQueryItem(name: "country", value: country)
        components?.queryItems = [countryQuery, apiQuery]
        
        guard let finalURL = components?.url else { return completion(.failure(.invalidURL)) }
        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) { (data, response, error) in
            if let error = error {
                print("======== ERROR 3 ========")
                print("Function: \(#function)")
                print("Error: \(error)")
                print("Description: \(error.localizedDescription)")
                print("======== ERROR ========")
                return completion(.failure(.thrownError(error)))
            }
            
            if let response = response as? HTTPURLResponse {
                print("State List Status Code: \(response.statusCode)")
            }
            
            guard let data = data else { return completion(.failure(.noData)) }
            
            do {
                let stateTopLevelObject = try JSONDecoder().decode(StateTopLevel.self, from: data)
                let stateData = stateTopLevelObject.data
                
                var states: [String] = []
                
                for state in stateData {
                    let stateString = state.state
                    states.append(stateString)
                }
                
                completion(.success(states))
            } catch {
                print("======== ERROR 4 ========")
                print("Function: \(#function)")
                print("Error: \(error)")
                print("Description: \(error.localizedDescription)")
                print("======== ERROR ========")
                return completion(.failure(.thrownError(error)))
            }
        }.resume()
    }
    
    static func fetchSupportedCities(forState state: String, inCountry country: String, completion: @escaping (Result<[String], NetworkError>) -> Void) {
        
        guard let baseURL = baseURL else { return completion(.failure(.invalidURL)) }
        let versionURL = baseURL.appendingPathComponent(version)
        let citiesURL = versionURL.appendingPathComponent(cityComponent)
        
        var components = URLComponents(url: citiesURL, resolvingAgainstBaseURL: true)
        let countryQuery = URLQueryItem(name: "country", value: country)
        let stateQuery = URLQueryItem(name: "state", value: state)
        let apiQuery = URLQueryItem(name: "key", value: apiKey)
        components?.queryItems = [stateQuery, countryQuery, apiQuery]
        
        guard let finalURL = components?.url else { return completion(.failure(.invalidURL)) }
        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) { (data, response, error) in
            if let error = error {
                print("======== ERROR 5 ========")
                print("Function: \(#function)")
                print("Error: \(error)")
                print("Description: \(error.localizedDescription)")
                print("======== ERROR ========")
                return completion(.failure(.thrownError(error)))
            }
            
            if let response = response as? HTTPURLResponse {
                print("Cities List status Code: \(response.statusCode)")
            }
            
            guard let data = data else { return completion(.failure(.noData)) }
            
            do {
                let cityTopLevelObject = try JSONDecoder().decode(CityTopLevel.self, from: data)
                let cityData = cityTopLevelObject.data
                
                var cities: [String] = []
                
                for city in cityData {
                    let cityString = city.city
                    cities.append(cityString)
                }
                
                completion(.success(cities))
            } catch {
                print("======== ERROR 6 ========")
                print("Function: \(#function)")
                print("Error: \(error)")
                print("Description: \(error.localizedDescription)")
                print("======== ERROR ========")
                return completion(.failure(.thrownError(error)))
            }
        }.resume()
    }
    
    static func fetchData(forCity city: String, inState state: String, inCountry country: String, completion: @escaping (Result<CityReportTopLevel, NetworkError>) -> Void) {
        
        guard let baseURL = baseURL else { return completion(.failure(.invalidURL)) }
        let versionURL = baseURL.appendingPathComponent(version)
        let cityURL = versionURL.appendingPathComponent(cityDataComponent)
        
        var components = URLComponents(url: cityURL, resolvingAgainstBaseURL: true)
        let cityQuery = URLQueryItem(name: "city", value: city)
        let stateQuery = URLQueryItem(name: "state", value: state)
        let countryQuery = URLQueryItem(name: "country", value: country)
        let apiQuery = URLQueryItem(name: "key", value: apiKey)
        components?.queryItems = [cityQuery, stateQuery, countryQuery, apiQuery]
        
        guard let finalURL = components?.url else { return completion(.failure(.invalidURL)) }
        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) { (data, response, error) in
            if let error = error {
                print("======== ERROR 7 ========")
                print("Function: \(#function)")
                print("Error: \(error)")
                print("Description: \(error.localizedDescription)")
                print("======== ERROR ========")
                return completion(.failure(.thrownError(error)))
            }
            
            if let response = response as? HTTPURLResponse {
                print("City Data Status Code: \(response.statusCode)")
            }
            
            guard let data = data else { return completion(.failure(.noData)) }
            
            do {
                let cityReport = try JSONDecoder().decode(CityReportTopLevel.self, from: data)
                completion(.success(cityReport))
            } catch {
                print("======== ERROR 8 ========")
                print("Function: \(#function)")
                print("Error: \(error)")
                print("Description: \(error.localizedDescription)")
                print("======== ERROR ========")
                return completion(.failure(.thrownError(error)))
            }
        }.resume()
    }
    
    static func fetchNearestCity(completion: @escaping (Result<CityReportTopLevel, NetworkError>) -> Void) {
        
        guard let baseURL = baseURL else { return completion(.failure(.invalidURL)) }
        let versionURL = baseURL.appendingPathComponent(version)
        let nearestCityURL = versionURL.appendingPathComponent(nearestCityComponent)
        
        var components = URLComponents(url: nearestCityURL, resolvingAgainstBaseURL: true)
        let apiQuery = URLQueryItem(name: "key", value: apiKey)
        components?.queryItems = [apiQuery]
        
        guard let finalURL = components?.url else { return completion(.failure(.invalidURL)) }
        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) { (data, response, error) in
            if let error = error {
                print("======== ERROR ========")
                print("Function: \(#function)")
                print("Error: \(error)")
                print("Description: \(error.localizedDescription)")
                print("======== ERROR ========")
                return completion(.failure(.thrownError(error)))
            }
            
            if let response = response as? HTTPURLResponse {
                print("Nearest City Status Code: \(response.statusCode)")
            }
            
            guard let data = data else { return completion(.failure(.noData)) }
            
            do {
                let nearestCityData = try JSONDecoder().decode(CityReportTopLevel.self, from: data)
                completion(.success(nearestCityData))
            } catch {
                print("======== ERROR ========")
                print("Function: \(#function)")
                print("Error: \(error)")
                print("Description: \(error.localizedDescription)")
                print("======== ERROR ========")
                return completion(.failure(.thrownError(error)))
            }
        }.resume()
    }
    
}   //  End of Class
