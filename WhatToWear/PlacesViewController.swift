//
//  PlacesViewController.swift
//  WhatToWear
//
//  Created by Vladislav Andreev on 22.08.17.
//  Copyright © 2017 Vladislav Andreev. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class PlacesViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    var fetchedResultsController = CoreDataManager.instance.fetchedResultsController("Location", keyForSort: "timesSelected")
    
    var countOfCells = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error)
        }
        self.navigationItem.rightBarButtonItem = self.editButtonItem

        
        //self.tableView.register(CityCell.classForCoder(), forCellReuseIdentifier:"location")
        //self.tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier:"default")
    }
    
    
    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let sections = fetchedResultsController.sections {
            countOfCells = sections[section].numberOfObjects + 2
            print(sections[section].numberOfObjects)
        }
        
        return countOfCells
        
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = indexPath.row

        let locationIdentifier = "location"
        let defaultIdentifier = "default"
        
        if  row == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: defaultIdentifier, for: indexPath)
            
            cell.imageView?.image = #imageLiteral(resourceName: "geolocation")
            
            LocationServices.shared.getCurrentLocationAddress(completion: { (address, error) in
                
                if let a = address, let city = a["City"] as? String {
                    cell.textLabel?.text = city
                } else {
                    cell.textLabel?.text = "Текущая геопозиция недоступна"
                }
            })
            
            return cell
            
        }
        
        if  row == countOfCells - 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: defaultIdentifier, for: indexPath)
            cell.imageView?.image = #imageLiteral(resourceName: "add")
            cell.textLabel?.text = "Добавить"
            return cell
        }
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: locationIdentifier, for: indexPath) as! CityCell
        
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
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let locationServices = LocationServices.shared
        
        if indexPath.row != 0 && indexPath.row != countOfCells - 1 {
            
            let indexPathWithOffset = IndexPath(row: indexPath.row - 1, section: indexPath.section)
            let place = fetchedResultsController.object(at: indexPathWithOffset) as! Location
            place.timesSelected += 1
            CoreDataManager.instance.saveContext()
            
            locationServices.selectedLocation = SelectedLocation(.manual, place)

            self.navigationController?.popViewController(animated: true)
            
        }
        
        if indexPath.row == 0  {
            locationServices.selectedLocation.type = .autodetection
            self.navigationController?.popViewController(animated: true)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
 
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        if indexPath.row == 0 || indexPath.row == countOfCells - 1 {
            return false
        }
 
        return true
        
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let indexPathWithOffset = IndexPath(row: indexPath.row - 1, section: indexPath.section)
            let managedObject = fetchedResultsController.object(at: indexPathWithOffset) as! NSManagedObject
            CoreDataManager.instance.managedObjectContext.delete(managedObject)
            CoreDataManager.instance.saveContext()
        }
        
    }



}
