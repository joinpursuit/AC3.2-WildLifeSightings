//
//  SightingsViewController.swift
//  WildlifeSighting
//
//  Created by Sabrina Ip on 1/9/17.
//  Copyright © 2017 Sabrina, Vic, Tom. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class SightingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapOrDataSegmentedControl: UISegmentedControl!
    @IBOutlet weak var tableViewBottomLayoutConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func mapOrDataSegmentedControlChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            mapView.isHidden = false
            tableViewBottomLayoutConstraint.isActive = false
            tableViewBottomLayoutConstraint = tableView.bottomAnchor.constraint(equalTo: self.view.centerYAnchor)
            tableViewBottomLayoutConstraint.isActive = true

        case 1:
            mapView.isHidden = true
            tableViewBottomLayoutConstraint.isActive = false
            tableViewBottomLayoutConstraint = tableView.bottomAnchor.constraint(equalTo: mapOrDataSegmentedControl.topAnchor, constant: -8.0)
            tableViewBottomLayoutConstraint.isActive = true
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        guard let sections = fetchedResultsController.sections else {
//            fatalError("No sections in fetchedResultsController")
//        }
//        let sectionInfo = sections[section]
//        return sectionInfo.numberOfObjects
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SightingCell", for: indexPath)
//        let object = fetchedResultsController.object(at: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true // return true to be able to delete things - the default is false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        switch editingStyle {
//        case .delete:
//            let object = fetchedResultsController.object(at: indexPath)
//            mainContext.delete(object)
//            try! mainContext.save()
//        default: break
//        }
    }

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        <#code#>
//    }
}
