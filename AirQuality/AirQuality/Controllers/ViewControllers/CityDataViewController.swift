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
        
        if let country = country, let state = state, let city = city {
            fetchCityReport(country: country, state: state, city: city)
        } else {
            fetchNearestCity()
        }
    }
    
    //  MARK: Properties
    var country: String?
    var state: String?
    var city: String?
    
    //  MARK: Methods
    func fetchCityReport(country: String, state: String, city: String) {
        
        AirQualityController.fetchData(forCity: city, inState: state, inCountry: country) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let cityReport):
                    self.updateView(with: cityReport)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func updateView(with cityData: CityReportTopLevel) {
        cityStateCountryLabel.text = "\(cityData.data.city), \(cityData.data.state), \(cityData.data.country)"
        aqiLabel.text = "AQI: \(cityData.data.current.pollution.aqius)"
        windspeedLabel.text = "Windspeed: \(cityData.data.current.weather.ws)"
        temperatureLabel.text = "Temperature: \(cityData.data.current.weather.tp)"
        humidityLabel.text = "Humidity: \(cityData.data.current.weather.hu)"
        
        if cityData.data.location.coordinates.count == 2 {
            latLongLabel.text = "Latitude: \(cityData.data.location.coordinates[1]) \nLongitude: \(cityData.data.location.coordinates[0])"
        } else {
            latLongLabel.text = "No coordinates available"
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
