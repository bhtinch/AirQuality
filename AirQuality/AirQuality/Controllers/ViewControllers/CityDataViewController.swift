//
//  CityDataViewController.swift
//  AirQuality
//
//  Created by Maxwell Poffenbarger on 1/5/21.
//

import UIKit

class CityDataViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var closestCityTitleLabel: UILabel!
    @IBOutlet weak var cityStateCountryLabel: UILabel!
    @IBOutlet weak var aqiLabel: UILabel!
    @IBOutlet weak var windspeedLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var latLongLabel: UILabel!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        closestCityTitleLabel.isHidden = true
        fetchCityData()
    }
    
    //MARK: - Properties
    var city: String?
    var state: String?
    var country: String?
    
    //MARK: - Methods
    func fetchCityData() {
        
        if let city = city, let state = state, let country = country {
            AirQualityController.fetchData(forCity: city, inState: state, inCountry: country) { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let cityData):
                        self.updateView(with: cityData)
                        
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
        } else {
            fetchNearestCity()
        }
    }
    
    func updateView(with cityData: CityData) {
        let coordinates = cityData.data.location.coordinates
        cityStateCountryLabel.text = "\(cityData.data.city), \(cityData.data.state) \n \(cityData.data.country)"
        aqiLabel.text = "AQI: \(cityData.data.current.pollution.aqius)"
        windspeedLabel.text = "Windspeed: \(cityData.data.current.weather.ws)"
        temperatureLabel.text = "Temperature: \(cityData.data.current.weather.tp)"
        humidityLabel.text = "Humidity: \(cityData.data.current.weather.hu)"
        if coordinates.count == 2 {
            latLongLabel.text = "Latitude: \(coordinates[1]) \nLongitude: \(coordinates[0])"
        } else {
            latLongLabel.text = "Coordinates: Unknown"
        }
        
    }
    
    func fetchNearestCity() {
        AirQualityController.fetchNearestCity { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let cityData):
                    self.updateView(with: cityData)
                    self.closestCityTitleLabel.isHidden = false
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}//End of class
