//
//  ReportCrimeController.swift
//  onalert
//
//  Created by Maria Laura Rodriguez on 2/27/17.
//  Copyright © 2017 Maria Laura Rodriguez. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices
import CloudKit

class ReportCrimeController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    let publicDatabase = CKContainer.default().publicCloudDatabase
    
    var crimeTypes = ["Assault", "Murder", "Theft", "Vandalization"]
    var placementCrime = 0
    
    private var latitude: Double?
    private var longitude: Double?
    private var crime: String?
    private var time: Date?
    private var picture: UIImage?
    private var comment: String?
    
    private var datePicker: UIDatePicker!
    private var dateFormatter = DateFormatter()
    // private var crimePicker: UIPickerView!
    
    
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var crimesPicker: UIPickerView!
    @IBOutlet weak var commentText: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    //    @IBOutlet weak var crimeTextField: UITextField!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var LabelCrime: UILabel!
    //  @IBOutlet weak var selectCrime: UILabel!
    @IBOutlet weak var selectTime: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    
    @IBAction func selectImage(_ sender: Any) {
        let alertController = UIAlertController(title: nil, message: "Pick Crime Image Source", preferredStyle: .actionSheet)
        
        let checkSourceType = { (sourceType: UIImagePickerControllerSourceType, buttonText: String) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(sourceType) {
                alertController.addAction(UIAlertAction(title: buttonText, style: .default, handler: self.imagePickerControllerSourceTypeActionHandler(for: sourceType)))
            }
        }
        checkSourceType(.camera, "Camera")
        checkSourceType(.photoLibrary, "Photo Library")
        checkSourceType(.savedPhotosAlbum, "Saved Photos Album")
        
        if !alertController.actions.isEmpty {
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            present(alertController, animated: true, completion: nil)
        }
    }
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // First check for an edited image, then the original image
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            print(image)
            picture = image
        }
        else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            print(image)
            picture = image
        }
        
        updateUIForPicture()
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    private func imagePickerControllerSourceTypeActionHandler(for sourceType: UIImagePickerControllerSourceType) -> (_ action: UIAlertAction) -> Void {
        return { (action) in
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = sourceType
            imagePickerController.mediaTypes = [kUTTypeImage as String] // Import the MobileCoreServices framework to use kUTTypeImage (see top of file)
            imagePickerController.allowsEditing = true
            
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    private func updateUIForPicture(animated: Bool = true) {
        if animated {
            if let somePicture = picture, image.isHidden {
                image.image = somePicture
                self.image.transform = CGAffineTransform(scaleX: 0.01, y: 0.01).rotated(by: CGFloat(-M_PI))
                image.isHidden = false
                commentText.isHidden = false
                clearButton.alpha = 0.0
                clearButton.isHidden = false
                
                UIView.animate(withDuration: 0.2, animations: { () -> Void in
                    self.image.transform = CGAffineTransform.identity
                    self.clearButton.alpha = 1.0
                }, completion: { (complete) -> Void in
                })
            }
            else {
                UIView.animate(withDuration: 0.2, animations: { () -> Void in
                    self.image.transform = CGAffineTransform(scaleX: 0.01, y: 0.01).rotated(by: CGFloat(M_PI))
                    self.clearButton.alpha = 0.0
                }, completion: { (complete) -> Void in
                    self.image.image = nil
                    self.image.transform = CGAffineTransform.identity
                    self.image.isHidden = true
                    self.clearButton.alpha = 1.0
                    self.clearButton.isHidden = true
                })
            }
        }
        else {
            if let somePicture = picture {
                image.isHidden = false
                commentText.isHidden = false
                image.image = somePicture
                clearButton.isHidden = false
            }
            else {
                image.isHidden = true
                image.image = nil
                clearButton.isHidden = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        time = Date()
        dateFormatter.dateFormat = "hh:mm a"
        selectTime.text = dateFormatter.string(from: time!)
        loading.isHidden = true
        loadingLabel.isHidden = true
        
        crimesPicker.delegate = self
        crimesPicker.dataSource = self
        
        datePicker = UIDatePicker(frame: CGRect.zero)
        datePicker.datePickerMode = .time
        datePicker.maximumDate = NSDate() as Date
        datePicker.addTarget(self, action: #selector(ReportCrimeController.datePickerDidChange(_:)), for: .valueChanged)
        let toolbar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: 0.0, height: 44.0))
        toolbar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(ReportCrimeController.datePickerDidFinish(_:)))]
        timeTextField.inputView = datePicker
        timeTextField.allowsEditingTextAttributes = false
        timeTextField.inputAccessoryView = toolbar
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .medium
    }
    
    @IBAction private func datePickerDidChange(_ sender: UIDatePicker) {
        time = sender.date
        dateFormatter.dateFormat = "hh:mm a"
        selectTime.text = dateFormatter.string(from: time!)
    }
    
    @IBAction private func datePickerDidFinish(_ sender: AnyObject) {
        view.endEditing(true)
    }
    
    //crime
    func crimePickerDidFinish (_ sender: AnyObject)
    {
        view.endEditing(true)
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return crimeTypes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return crimeTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        placementCrime = row
        //        selectCrime.text = crimeTypes[placementCrime]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    private func updateUI() {
        if let someLatitude = latitude, let someLongitude = longitude {
            
            let numberFormatter = NumberFormatter()
            numberFormatter.formatterBehavior = .behavior10_4
            numberFormatter.minimumFractionDigits = 2
            numberFormatter.maximumFractionDigits = 5
            numberFormatter.minimumIntegerDigits = 1
            
            if let latitudeString = numberFormatter.string(from: someLatitude as NSNumber), let longitudeString = numberFormatter.string(from: someLongitude as NSNumber) {
                location.text = "\(latitudeString), \(longitudeString)"
            }
            else {
                location.text = ""
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    func updateCrime(latitude: Double, longitude: Double){
        self.latitude = latitude
        self.longitude = longitude
    }
    
    @IBAction private func clearButton(_ sender: AnyObject) {
        self.view.endEditing(true)
        
        let alertController = UIAlertController(title: nil, message: "Are you sure you want to delete the picture?", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Delete Picture", style: .destructive, handler: { (action: UIAlertAction) -> Void in
            self.picture = nil
            self.commentText.isHidden = true
            self.updateUIForPicture()
        }))
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func submit(_ sender: UIButton) {
        loading.isHidden = false
        loadingLabel.isHidden = false
        loading.startAnimating()
        crime = crimeTypes[placementCrime]
        comment = commentText.text ?? ""
        if let someLatitude = latitude, let someLongitude = longitude, let someCrime = crime, let someTime = time {
            let crimeCK = CKRecord(recordType: "Crimes")
            crimeCK.setObject(someCrime as NSString, forKey: "type")
            crimeCK.setObject(someLatitude as CKRecordValue?, forKey: "latitude")
            crimeCK.setObject(someLongitude as CKRecordValue?, forKey: "longitude")
            crimeCK.setObject(comment as CKRecordValue?, forKey: "comment")
            crimeCK.setObject(someTime as CKRecordValue?, forKey: "time")
            let mngr = FileManager.default
            let dir = mngr.urls(for: .documentDirectory, in: .userDomainMask)
            let file = dir[0].appendingPathComponent("image").path
            
            if let somePicture = picture {
                let imgURL = NSURL.fileURL(withPath: file)
                do { try UIImageJPEGRepresentation(somePicture, 1.0)?.write(to: imgURL) }
                catch {
                    print("Error")
                }
                let imagAsset = CKAsset(fileURL: imgURL)
                crimeCK.setObject(imagAsset, forKey: "image")
            }
            publicDatabase.save(crimeCK, completionHandler: { (savedRecord, error) in
                if let someError = error as? NSError {
                    DispatchQueue.main.async {
                        self.loading.stopAnimating()
                        self.loading.isHidden = true
                        self.loadingLabel.isHidden = true
                    }
                    if(someError.code == 9) {
                        let alertController = UIAlertController(title: "Error Connecting to CloudKit", message: "Pin could not be saved succesfully to the Cloud. Sign in to your iCloud account to write records. On the Home screen, launch Settings, tap iCloud, and enter your Apple ID. Turn iCloud Drive on. If you don't have an iCloud account, tap Create a new Apple ID.", preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alertController, animated: true, completion: nil)
                    } else {
                        let alertController = UIAlertController(title: "Error establishing a connection", message: "Please try again later", preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alertController, animated: true, completion: nil)
                    }
                } else {
                        CrimeService.shared.tempCreateCrime(latitude: someLatitude, longitude: someLongitude, type: someCrime, time: someTime, picture: self.picture, comment: self.comment!, id: String(Int(arc4random_uniform(1000000) + 1)) )
                    DispatchQueue.main.async {
                        self.loading.stopAnimating()
                        self.loading.isHidden = true
                        self.loadingLabel.isHidden = true
                        self.performSegue(withIdentifier: "DoneUnwindSegue", sender: self)
                    }
                }
            })
        }
        
    }
    
}
