//
//  CrimeListViewController.swift
//  onalert
//
//  Created by Maria Rodriguez on 3/7/17.
//  Copyright © 2017 Maria Laura Rodriguez. All rights reserved.
//

import UIKit
import CoreData

class CrimeListViewController : UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController!.sections?[section].numberOfObjects ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CrimeCell", for: indexPath)
        let crimeValues = fetchedResultsController?.object(at: indexPath)
        if let someType = crimeValues?.type, let someCrime = crimeValues?.hour {
            cell.textLabel?.text = "\(someType) at \(someCrime)"
        }
        return cell
    }
    
    // MARK: View Management
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        for observerToken in observerTokens {
            NotificationCenter.default.removeObserver(observerToken)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CrimeDetailSegue2" {
            let crimeDetailViewController = segue.destination as! CrimeDetailViewController
            let selectedIndexPath = crimeListTable.indexPathForSelectedRow!
            crimeDetailViewController.selectedCrime = fetchedResultsController?.object(at: selectedIndexPath)
            
            crimeListTable.deselectRow(at: selectedIndexPath, animated: true)
        }
        else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        // There are additional methods in this delegate protocol that can be used for more detailed updates, for this
        // simple app we can just reload the entire table for any content change.
        crimeListTable.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Retrieve the fetched results controller from the cat service to prevent unnecessary creation of multiple
        // fetches
        fetchedResultsController = try? CrimeService.shared.dayCrimeFetchedResultsController(with: self)
        
        // Set the delegate to self so that we can respond to updates in the data
        fetchedResultsController?.delegate = self
    }
    
    // MARK: Properties (Private)
    private var observerTokens = Array<Any>()
    
    // MARK: Properties (IBOutlet)
    
    @IBOutlet private weak var crimeListTable: UITableView!
    private var fetchedResultsController: NSFetchedResultsController<Crime>?
    
}
