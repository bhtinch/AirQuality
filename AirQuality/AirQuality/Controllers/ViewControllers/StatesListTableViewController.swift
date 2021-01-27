//
//  StatesListTableViewController.swift
//  AirQuality
//
//  Created by Maxwell Poffenbarger on 1/5/21.
//

import UIKit

class StatesListTableViewController: UITableViewController {
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchStates()
    }
    
    //MARK: - Properties
    var country: String?
    var states: [String] = []
    
    //MARK: - Methods
    func fetchStates() {
        
        guard let countryName = country else {return}
        
        AirQualityController.fetchSupportedStates(forCountry: countryName) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let states):
                    self.states = states
                    self.tableView.reloadData()
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return states.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stateCell", for: indexPath)
        
        let stateName = states[indexPath.row]
        
        cell.textLabel?.text = stateName
        
        return cell
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toCitiesVC" {
            
            guard let indexPath = tableView.indexPathForSelectedRow,
                  let country = country,
                  let destinationVC = segue.destination as? CitiesListTableViewController
            else { return}
            
            let selectedState = states[indexPath.row]
            destinationVC.country = country
            destinationVC.state = selectedState
        }
    }
}//End of class
