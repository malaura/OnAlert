//
//  MapViewController.swift
//  onalert
//
//  Created by Maria Laura Rodriguez on 2/27/17.
//  Copyright © 2017 Maria Laura Rodriguez. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

class MapViewController: UIViewController, CrimeDetailViewControllerDelegate, MKMapViewDelegate, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var Map: MKMapView!
    private var fetchedResultsController: NSFetchedResultsController<Crime>?
    let locationManager = CLLocationManager()

    
    @IBAction private func mapViewDone(sender: UIStoryboardSegue) {
        // Intentionally left blank
    }

    @IBAction func setCurrentLocation(_ sender: Any) {
        if let loc = Map.userLocation.location?.coordinate {
            Map.centerCoordinate = (loc)
        } else {
            let alertController = UIAlertController(title: "Error finding location", message: "Could not find your current location, make sure you have enabled your permissions correctly", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Map.visibleMapRect = MapViewController.defaultMapRect
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        updateFetchedResultsController()
    }
    
   func updateFetchedResultsController() {
        fetchedResultsController = try? CrimeService.shared.crimeFetchedResultsController(with: self)
    
        if let someObjects = fetchedResultsController?.fetchedObjects {
            Map.addAnnotations(someObjects)
        }
    } 
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func reportCrime(_ sender: Any) {
        self.performSegue(withIdentifier: "ReportCrimeSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case .some("ReportCrimeSegue"):
            let reportCrimeController = segue.destination as! ReportCrimeController
            reportCrimeController.updateCrime(latitude: Map.centerCoordinate.latitude, longitude: Map.centerCoordinate.longitude)
        case .some("CrimeDetailSegue"):
            let crimeDetailViewController = segue.destination as! CrimeDetailViewController
            crimeDetailViewController.selectedCrime = selectedCrime
            crimeDetailViewController.delegate = self

        default:
            super.prepare(for: segue, sender: sender)
        }
    }
    
    // MARK: MKMapViewDelegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView: MKAnnotationView

        if annotation is MKUserLocation {
            return nil
        }
        if let someAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "CrimeAnnotation") {
            annotationView = someAnnotationView
        }
        else {
            let pinAnnotationView = MKPinAnnotationView(annotation:annotation, reuseIdentifier:"CrimeAnnotation")
            pinAnnotationView.pinTintColor = .red
            pinAnnotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            annotationView = pinAnnotationView
        }
        
        annotationView.annotation = annotation
        annotationView.canShowCallout = true
        annotationView.isDraggable = true
        
        return annotationView;
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let someCrime = view.annotation as? Crime {
            selectedCrime = someCrime
            performSegue(withIdentifier: "CrimeDetailSegue", sender:self)
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        if let crime = anObject as? Crime {
            if type == .insert {
                Map.addAnnotation(crime)
            }
        }
    }
    
    func crimeDetailViewController(_ viewController: CrimeDetailViewController, didChange crime: Crime){
        Map.deselectAnnotation(crime, animated: false)
        Map.selectAnnotation(crime, animated: false)
    }
    
	private static let defaultMapRect = MKMapRect(origin: MKMapPoint(x: 41984000.0, y: 97083392.0), size: MKMapSize(width: 50000.0, height: 10000.0))
    private var selectedCrime: Crime?
}

