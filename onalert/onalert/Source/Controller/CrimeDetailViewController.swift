//
//  CrimeDetailViewController.swift
//  onalert
//
//  Created by Maria Rodriguez on 3/7/17.
//  Copyright © 2017 Maria Laura Rodriguez. All rights reserved.
//

import UIKit

class CrimeDetailViewController: UITableViewController {

    // MARK: Properties
    var selectedCrime: Crime? {
        didSet {
            if let someCrime = selectedCrime {
                latitude = someCrime.latitude?.doubleValue ?? 0
                longitude = someCrime.longitude?.doubleValue ?? 0
                crime = someCrime.type
                time = someCrime.time as Date?
                if let pictureData = someCrime.picture?.data {
                    picture = UIImage(data: pictureData.data as! Data)
                }
                else {
                    picture = nil
                }
                comment = someCrime.picture?.comment
            }
        }
    }
    
    // MARK: Private
    private func updateUI() {
        if let someLatitude = latitude, let someLongitude = longitude, let someTime = time {
            image.image = picture
            if picture == nil {
                pictureLabel.isHidden = true
            }
            let formatter = DateFormatter()
            formatter.dateFormat = "hh:mm a"
            let resultTime = formatter.string(from: someTime )
            timeLabel.text = resultTime
            commentLabel.text = comment
            let numberFormatter = NumberFormatter()
            numberFormatter.formatterBehavior = .behavior10_4
            numberFormatter.minimumFractionDigits = 2
            numberFormatter.maximumFractionDigits = 5
            numberFormatter.minimumIntegerDigits = 1
            
            if let latitudeString = numberFormatter.string(from: someLatitude as NSNumber), let longitudeString = numberFormatter.string(from: someLongitude as NSNumber) {
                locationLabel.text = "\(latitudeString), \(longitudeString)"
            }
            
            

        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let someCrime = selectedCrime {
            navigationItem.title = someCrime.type
        }
        updateUI()
    }
    
    // MARK: Properties (IBOutlet)
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var pictureLabel: UILabel!
    
    // MARK: Properties (Private)
    private var latitude: Double?
    private var longitude: Double?
    private var crime: String?
    private var time: Date?
    private var picture: UIImage?
    private var comment: String?

    
    weak var delegate: CrimeDetailViewControllerDelegate?
}
