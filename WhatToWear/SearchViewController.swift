//
//  SearchViewController.swift
//  WhatToWear
//
//  Created by Vladislav Andreev on 22.08.17.
//  Copyright © 2017 Vladislav Andreev. All rights reserved.
//

import UIKit
import MapKit

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()

    @IBOutlet weak var searchResultsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchCompleter.delegate = self
        searchCompleter.filterType = .locationsOnly
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let searchResult = searchResults[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        
        cell.textLabel?.attributedText = highlightedText(searchResult.title, inRanges: searchResult.titleHighlightRanges, size: 17.0)
        cell.detailTextLabel?.attributedText = highlightedText(searchResult.subtitle, inRanges: searchResult.subtitleHighlightRanges, size: 12.0)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let completion = searchResults[indexPath.row]
        
        let searchRequest = MKLocalSearchRequest(completion: completion)
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            
            let location = response?.mapItems[0].placemark.location
            
            let place = Location()
            place.latitude = (location?.coordinate.latitude)!
            place.longitude = (location?.coordinate.longitude)!
            place.timesSelected = 1
            place.title = response?.mapItems[0].placemark.title
            
            CoreDataManager.instance.saveContext()
            self.navigationController?.popViewController(animated: true)

        }
    }
    
    func highlightedText(_ text: String, inRanges ranges: [NSValue], size: CGFloat) -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: text)
        let regular = UIFont.systemFont(ofSize: size)
        attributedText.addAttribute(NSFontAttributeName, value:regular, range:NSMakeRange(0, text.characters.count))
        
        let bold = UIFont.boldSystemFont(ofSize: size)
        for value in ranges {
            attributedText.addAttribute(NSFontAttributeName, value:bold, range:value.rangeValue)
        }
        return attributedText
    }

}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchCompleter.queryFragment = searchText
    }
}

extension SearchViewController: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        searchResultsTableView.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        // handle error
    }
}

