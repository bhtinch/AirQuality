//
//  CitiesListTableViewController.swift
//  AirQuality
//
//  Created by Maxwell Poffenbarger on 1/5/21.
//

import UIKit

class CitiesListTableViewController: UITableViewController {
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let country = country,
              let state = state else { return }
        
        fetchCities(state: state, country: country)
    }
    
    //  MARK: Properties
    var country: String?
    var state: String?
    var cities: [String] = []
    
    //  MARK: Methods
    func fetchCities(state: String, country: String) {
        AirQualityController.fetchSupportedCities(forState: state, inCountry: country) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let cities):
                    self.cities = cities
                    self.tableView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath)
        
        let city = cities[indexPath.row]
        cell.textLabel?.text = city
        
        return cell
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCityDataVC" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                  let country = country,
                  let state = state,
                  let destination = segue.destination as? CityDataViewController else { return }
            destination.city = cities[indexPath.row]
            destination.state = state
            destination.country = country
        }
    }
}//End of class
