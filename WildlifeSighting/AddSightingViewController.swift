//
//  AddSightingViewController.swift
//  WildlifeSighting
//
//  Created by Sabrina Ip on 1/9/17.
//  Copyright © 2017 Sabrina, Vic, Tom. All rights reserved.
//

import UIKit
import ImagePicker
import SwiftSpinner
import CoreLocation
import CoreData


class AddSightingViewController: UIViewController, ImagePickerDelegate, CLLocationManagerDelegate, UITextViewDelegate {

    // MARK: - Outlets

    @IBOutlet weak var addDetailsLabel: UILabel!
    @IBOutlet weak var sightingImageView: UIImageView!
    @IBOutlet weak var sightingNameTextField: UITextField!
    @IBOutlet weak var sightingDetailsTextView: UITextView!
    @IBOutlet weak var currentLocationSwitch: UISwitch!
    @IBOutlet weak var shareToTwitterSwitch: UISwitch!
    @IBOutlet weak var takePhotoButton: UIButton!
    @IBOutlet weak var photoBottomConstraint: NSLayoutConstraint!
    // MARK: - Preperties
    
    var sightingPhoto: UIImage?
    var currentWeather: DarkSkiesWeather?
    var currentLocation: CLLocation?
    
    let locationManager: CLLocationManager = {
        let locMan: CLLocationManager = CLLocationManager()
        locMan.desiredAccuracy = 100.0
        locMan.distanceFilter = 100.0
        return locMan
    }()
    
    var mainContext: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }

    
    // MARK: - View Did Load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        setupTextView()
        self.automaticallyAdjustsScrollViewInsets = false

        sightingImageView.isHidden = true
        photoBottomConstraint.isActive = false
        photoBottomConstraint =
            sightingImageView.bottomAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor, constant: 8.0)
//            takePhotoButton.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor, constant: 8.0)
        photoBottomConstraint.isActive = true
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddSightingViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
 
    }
 
 
    // MARK: - ImagePicker
    
    @IBAction func takePhotoButtonPressed(_ sender: UIButton) {
        let imagePickerController = ImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)

        sightingImageView.isHidden = false
        photoBottomConstraint.isActive = false
        photoBottomConstraint = sightingImageView.bottomAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 8.0)
        photoBottomConstraint.isActive = true

        takePhotoButton.setTitle("Retake Photo", for: .normal)
    }
    
    
    @IBAction func saveBarButtonPressed(_ sender: UIBarButtonItem) {
        
        // this is an async call and wont be finished before the function returns. #PROBLEM
        // fixed this problem by calling saveToCoreData() in completion handler
        if let validCurrentLocation = currentLocation, currentLocationSwitch.isOn {
            let lat = validCurrentLocation.coordinate.latitude
            let long = validCurrentLocation.coordinate.longitude
            
            SwiftSpinner.show("Fetching Weather Info")
            APIRequestManager.manager.getData(endPoint: "https://api.darksky.net/forecast/7a31f9474ffaca358c03dafd19e487a6/\(lat),\(long)", callback: { (data: Data?) in
                if let validData = data {
                    self.currentWeather = DarkSkiesWeather.getWeather(from: validData)
                    print(">>weather: ", self.currentWeather?.temp ?? "no temp", self.currentWeather?.summary ?? "no summary")
                    SwiftSpinner.hide()
                    DispatchQueue.main.async {
                        self.saveToCoreData()
                        
                    }
                }
            })
        } else {
            saveToCoreData()
        }
    }
        

    func saveToCoreData() {
        
        guard let sightingName = sightingNameTextField.text, sightingName.characters.count > 0 else {
            showAlertWith(title: "No Name", message: "Please make sure you've entered a name for this sighting.")
            return
        }
        guard let sightingDetail = sightingDetailsTextView.text, sightingDetail.characters.count > 0 else {
            showAlertWith(title: "No Details", message: "Please make sure you've entered details for this sighting.")
            return
        }
        let newSightingObject = Sighting(context: mainContext)
        newSightingObject.name = sightingName
        newSightingObject.details = sightingDetail
        newSightingObject.date = NSDate()
        if let currentWeatherInfo = currentWeather {
            newSightingObject.temperature = currentWeatherInfo.temp
            newSightingObject.weatherDescription = currentWeatherInfo.summary
        }
        if let currentLocationInfo = currentLocation {
            newSightingObject.latitude = currentLocationInfo.coordinate.latitude
            newSightingObject.longitude = currentLocationInfo.coordinate.longitude
        }
        if let image = sightingPhoto, let asset = image.imageAsset,
            let thumbData = UIImageJPEGRepresentation(image, 0.4),
            let fullData = UIImageJPEGRepresentation(image, 1.0) {
            
            newSightingObject.imageAssetURL = String(describing: asset)
            newSightingObject.fullImageData = NSData(data: thumbData)
            newSightingObject.thumbImageData = NSData(data: fullData)
        }
        do {
            try mainContext.save()
        }
        catch let error {
            fatalError("Failed to save context: \(error)")
        }
        
        showAlertWith(title: "Success", message: "Sighting Added Succesfully") { (_) in
            _ = self.navigationController?.popViewController(animated: true) }
    }

    
    func showAlertWith(title: String, message: String, completion: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: completion)
        alert.addAction(okayAction)
        present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - Image Picker Delegate Methods
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        print("wrapperDidPress")
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        print("doneButtonPressed")
        dismiss(animated: true, completion: nil)
        guard images.count > 0 else { return }
        sightingPhoto = images[0]   
        sightingImageView.image = images[0]
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        print("cancel")
        dismiss(animated: true, completion: nil)
    }
    

    // MARK: - CoreLocation Delegate Methods
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            print("all good")
            manager.startUpdatingLocation()
        case .denied, .restricted:
            print("not good")
        case .notDetermined:
            print("not determined")
            //prompt user
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("location updated")
        guard let validLocation: CLLocation = locations.last else { return }
        let lat = "Lat: " + String(format: "Lat: %0.4f", validLocation.coordinate.latitude)
        let long = String(format: "Long: %0.4f", validLocation.coordinate.longitude)
        print(lat,", ", long)
        currentLocation = validLocation
        locationManager.stopUpdatingLocation()
    }
    
    // MARK: - TextView setup
    
    func setupTextView() {
        //SOURCE: http://stackoverflow.com/questions/20790907/uitextview-to-mimic-uitextfield-for-basic-round-corner-text-field
        let borderColor = UIColor(red: 215.0 / 255.0, green: 215.0 / 255.0, blue: 215.0 / 255.0, alpha: 1)
        sightingDetailsTextView.layer.borderColor = borderColor.cgColor
        sightingDetailsTextView.layer.borderWidth = 0.6;
        sightingDetailsTextView.layer.cornerRadius = 6.0;
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        addDetailsLabel.isHidden = true
        return
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if sightingDetailsTextView.text.isEmpty || sightingDetailsTextView.text == "" {
            addDetailsLabel.isHidden = false
        }
        return true
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
}
