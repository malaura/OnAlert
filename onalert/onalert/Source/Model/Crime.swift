//
//  Crime+CoreDataClass.swift
//  onalert
//
//  Created by Maria Rodriguez on 2/28/17.
//  Copyright © 2017 Maria Laura Rodriguez. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData
import MapKit



public class Crime: NSManagedObject, MKAnnotation {
    public var coordinate: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2D(latitude: latitude?.doubleValue ?? 0, longitude: longitude?.doubleValue ?? 0)
        }
        
        set {
            do {
                try CrimeService.shared.updateCrime(self, latitude: newValue.latitude, longitude: newValue.longitude, type: type!, time: time! as Date)
            }
            catch let error {
                fatalError("Failed to update existing hill: \(error)")
            }
        }
    }
    
    var hour : String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        let result = formatter.string(from: time as! Date)
        return result
    }
    
    public var title: String? {
        return type
    }
    
    public var subtitle: String? {
        return hour
    }

    
}
