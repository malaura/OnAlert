//
//  File.swift
//  onalert
//
//  Created by Maria Rodriguez on 2/27/17.
//  Copyright © 2017 Maria Laura Rodriguez. All rights reserved.
//

import CoreData
import Foundation
import UIKit
import MobileCoreServices
import CloudKit

class CrimeService {
    
    func fetchCrimesCloudKit() throws{
        let context = persistentContainer.viewContext
        
        // Use the perform method to ensure correct CoreData access
        context.perform {
            let fetchRequest: NSFetchRequest<Crime> = Crime.fetchRequest()
            var allCrimes = Set((try? context.fetch(fetchRequest)) ?? [])
            let pred = NSPredicate(value: true)
            let query = CKQuery(recordType: "Crimes", predicate: pred)
            self.publicDatabase.perform(query, inZoneWith: nil) { (result, error) in
                if let someError = error as? NSError {
                    print("Error \(someError)")
                } else {
                    if (result?.count)! > 0
                    {
                        for record in result! {
                            let existingCrime = allCrimes.first(where: { $0.id == record.recordID.recordName })
                            if let someExistingCrime = existingCrime {
                                allCrimes.remove(someExistingCrime)
                            }
                            
                            DispatchQueue.main.async {
                                var img = UIImage()
                                let File : CKAsset? = record.object(forKey: "image") as! CKAsset?
                                if let file = File {
                                    if let data = NSData(contentsOf: file.fileURL) {
                                        img = UIImage(data: data as Data)!
                                    }
                                }
                                do {
                                    try self.createCrime(latitude: record.object(forKey: "latitude") as! Double, longitude: record.object(forKey: "longitude") as! Double, type: record.object(forKey: "type") as! String, time: record.object(forKey: "time") as! Date, picture: img, comment: record.object(forKey: "comment") as! String, id: record.recordID.recordName)
                                }
                                catch let error {
                                    fatalError("Failed to create new crime: \(error)")
                                }
                            }
                        }
                    }
                }
            }
            for someCrime in allCrimes {
                context.delete(someCrime)
            }
            try! self.persistentContainer.viewContext.save()
        }
    }
    
    func crimeFetchedResultsController(with delegate: NSFetchedResultsControllerDelegate?) throws -> NSFetchedResultsController<Crime> {
        try fetchCrimesCloudKit()
        let fetchRequest: NSFetchRequest<Crime> =  Crime.fetchRequest()
        var dateComponents = DateComponents()
        dateComponents.hour = -1
        let calendar = Calendar.current
        let startDate = calendar.date(byAdding: dateComponents, to: Date())!
        let endDate = Date()
        fetchRequest.predicate = NSPredicate(format: "time >= %@", startDate as NSDate, endDate as NSDate)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "time", ascending: true)]
        
        let resultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        resultsController.delegate = delegate
        
        try resultsController.performFetch()
        return resultsController
    }
    
    func dayCrimeFetchedResultsController(with delegate: NSFetchedResultsControllerDelegate?) throws -> NSFetchedResultsController<Crime> {
        let fetchRequest: NSFetchRequest<Crime> =  Crime.fetchRequest()
        var dateComponents = DateComponents()
        dateComponents.hour = -24
        let calendar = Calendar.current
        let startDate = calendar.date(byAdding: dateComponents, to: Date())!
        let endDate = Date()
        fetchRequest.predicate = NSPredicate(format: "time >= %@", startDate as NSDate, endDate as NSDate)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "time", ascending: true)]
        
        let resultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        resultsController.delegate = delegate
        
        try resultsController.performFetch()
        return resultsController
    }
    
    
    
    func updateCrime(_ crime: Crime, latitude: Double, longitude: Double, type: String, time : Date) throws {
        crime.latitude = latitude as NSNumber
        crime.longitude = longitude as NSNumber
        crime.type = type
        crime.time = time as NSDate?
        
        try persistentContainer.viewContext.save()
    }
    
    
    func createCrime(latitude: Double, longitude: Double, type: String, time: Date, picture: UIImage?, comment: String, id: String) throws {
        let context = persistentContainer.viewContext
        
        let crime = Crime(context: context)
        crime.latitude = latitude as NSNumber
        crime.longitude = longitude as NSNumber
        crime.type = type
        crime.time = time as NSDate?
        crime.id = id
        
        if let somePicture = picture, let somePictureData = UIImageJPEGRepresentation(somePicture, 1.0) {
            let pictureEntity = PhotoData(context: context)
            pictureEntity.data = somePictureData as NSData
            pictureEntity.photo = Photo(context: context)
            pictureEntity.photo?.crime = crime
            pictureEntity.photo?.comment = comment
        }
        try persistentContainer.viewContext.save()
    }
    
    
    
    func tempCreateCrime(latitude: Double, longitude: Double, type: String, time: Date, picture: UIImage?, comment: String, id: String) {
        let context = persistentContainer.viewContext
        
        let crime = Crime(context: context)
        crime.latitude = latitude as NSNumber
        crime.longitude = longitude as NSNumber
        crime.type = type
        crime.time = time as NSDate?
        crime.id = id
        
        if let somePicture = picture, let somePictureData = UIImageJPEGRepresentation(somePicture, 1.0) {
            let pictureEntity = PhotoData(context: context)
            pictureEntity.data = somePictureData as NSData
            pictureEntity.photo = Photo(context: context)
            pictureEntity.photo?.crime = crime
            pictureEntity.photo?.comment = comment
        }
    }
    
    
    
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "Model")
        persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
            let context = self.persistentContainer.viewContext
            context.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
            context.perform {
                do {
                    try context.save()
                }
                catch _ {
                    fatalError("Failed to save context after initial crime data")
                }
                
            }
        })
    }
    
    // MARK: Private
    private let persistentContainer: NSPersistentContainer
    
    // MARK: Properties (Static)
    static let shared = CrimeService()
    
    // Database
    let publicDatabase = CKContainer.default().publicCloudDatabase
    
}
