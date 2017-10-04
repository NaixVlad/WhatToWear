//
//  CitySearchViewController.swift
//  WhatToWear
//
//  Created by Vladislav Andreev on 27.09.17.
//  Copyright © 2017 Vladislav Andreev. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import GooglePlaces

class CitySearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    
    var searchController: UISearchController?
    var resultsViewController: GMSAutocompleteResultsViewController?
    
    var fetchedResultsController = CoreDataManager.instance.fetchedResultsController("Location", keyForSort: "timesSelected")
    
    var countOfCells = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error)
        }
        
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        let filter = GMSAutocompleteFilter()
        filter.type = .city
        resultsViewController?.autocompleteFilter = filter
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        searchController?.searchBar.barStyle = .black
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        
        
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let sections = fetchedResultsController.sections {
            countOfCells = sections[section].numberOfObjects + 1
            // +1 is current location
        }
        
        return countOfCells
        
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = indexPath.row
        
        let currentLocationIdentifier = "currentLocation"
        let locationIdentifier = "location"
        
        if  row == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: currentLocationIdentifier, for: indexPath)
            
            cell.imageView?.image = #imageLiteral(resourceName: "geolocation")
            
            LocationServices.shared.getCurrentLocationAddress(completion: { (address, error) in
                
                if let location = address {
                    cell.textLabel?.text = "Текущее местоположение"
                    cell.detailTextLabel?.text = location
                    cell.layoutSubviews()
                } else {
                    cell.textLabel?.text = "Геопозиция недоступна"
                    cell.detailTextLabel?.text = ""
                    cell.layoutSubviews()
                }
            })
            
            return cell
            
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: locationIdentifier, for: indexPath)
        
        cell.imageView?.image = #imageLiteral(resourceName: "map")
        let indexPathWithOffset = IndexPath(row: row - 1, section: indexPath.section)
        let place = fetchedResultsController.object(at: indexPathWithOffset) as! Location
        cell.textLabel?.text  = place.title
        
        
        return cell
        
    }
    
    
    // MARK: - Fetched Results Controller Delegate
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        if type == .delete, let indexPath = indexPath {
            let indexPathWithOffset = IndexPath(row: indexPath.row + 1, section: indexPath.section)
            self.tableView.deleteRows(at: [indexPathWithOffset], with: .automatic)
        }
        
        
        if type == .insert, let indexPath = newIndexPath {
            let indexPathWithOffset = IndexPath(row: indexPath.row + 1, section: indexPath.section)
            tableView.insertRows(at: [indexPathWithOffset], with: .automatic)
        }
        
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
    
    
    // MARK: - Table view delegate
    
    
 func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let locationServices = LocationServices.shared
        
        if indexPath.row == 0  {
            
            locationServices.selectedLocation.type = .autodetection
            self.navigationController?.popViewController(animated: true)
            
        } else {
            
            let indexPathWithOffset = IndexPath(row: indexPath.row - 1, section: indexPath.section)
            let place = fetchedResultsController.object(at: indexPathWithOffset) as! Location
            place.timesSelected += 1
            CoreDataManager.instance.saveContext()
            
            locationServices.selectedLocation = SelectedLocation(.manual, place)
            
            self.navigationController?.popViewController(animated: true)
            
        }
        
        //tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    // Override to support conditional editing of the table view.
 func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        if indexPath.row == 0 {
            return false
        }
        
        return true
        
    }
    
    // Override to support editing the table view.
 func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let indexPathWithOffset = IndexPath(row: indexPath.row - 1, section: indexPath.section)
            let managedObject = fetchedResultsController.object(at: indexPathWithOffset) as! NSManagedObject
            CoreDataManager.instance.managedObjectContext.delete(managedObject)
            CoreDataManager.instance.saveContext()
        }
        
    }

}


// Handle the user's selection.
extension CitySearchViewController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        
        let location = Location()
        location.title = place.name
        location.latitude = place.coordinate.latitude
        location.longitude = place.coordinate.longitude
        location.timesSelected = 0
        CoreDataManager.instance.saveContext()
        self.tableView.reloadData()
        
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
