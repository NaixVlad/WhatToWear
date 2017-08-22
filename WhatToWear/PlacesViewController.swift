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
    }
    
    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let sections = fetchedResultsController.sections {
            countOfCells = sections[section].numberOfObjects + 2
        }
        
        return countOfCells
        
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = indexPath.row

        let locationIdentifier = "location"
        
        if  row == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: locationIdentifier, for: indexPath)
            
            cell.imageView?.image = #imageLiteral(resourceName: "location")
            //cell.textLabel?.text = "Текущее местоположение"
            cell.textLabel?.text = LocationServices.shared.getAdressFromCurentLocation()
            //let strLocation = LocationServices.shared.getAdressFromCurentLocation()
            //cell.detailTextLabel?.text = strLocation
            
            return cell
            
        }
        
        if  row == countOfCells - 1 {
            let addLocationIdentifier = "addLocation"
            let cell = tableView.dequeueReusableCell(withIdentifier: addLocationIdentifier, for: indexPath)
            return cell
        }
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: locationIdentifier, for: indexPath)
        
        
        
        
        DispatchQueue.global(qos: .background).async {
            let index = IndexPath(row: row - 1, section: indexPath.section)
            let coordinate = self.fetchedResultsController.object(at: index) as! Location
            let loc = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            LocationServices.shared.getAdressFromLocation(loc, completion: { (adress, error) in
                if let a = adress, let city = a["City"] as? String {
                    
                    DispatchQueue.main.async {
                        cell.textLabel?.text  = city
                    }
                }
            })

        }

        
        
        return cell
        
    }
    
    
    // MARK: - Fetched Results Controller Delegate
    
    /*func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        /*switch type {
            
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
            
        case .update:
            if let indexPath = indexPath {
                let location = fetchedResultsController.object(at: indexPath) as! Location
                let cell = tableView.cellForRow(at: indexPath)
                cell!.textLabel?.text = customer.name
            }
            
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }*/
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }

    */
    // MARK: - Table view delegate
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 || indexPath.row == countOfCells - 1 {
            
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
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
