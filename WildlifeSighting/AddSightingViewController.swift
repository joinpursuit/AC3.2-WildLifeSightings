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


class AddSightingViewController: UIViewController, ImagePickerDelegate, CLLocationManagerDelegate, UITextViewDelegate, UITextFieldDelegate {
    
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
    
    let communityEndpoint = "https://api.fieldbook.com/v1/58757bb45de269040063ab78/sightings"
    var communityPostDict: [String: Any] = [:]
    
    
    // MARK: - View Did Load
    
    override func viewDidLoad() {
        navigationController?.hidesBottomBarWhenPushed = true
        super.viewDidLoad()
        locationManager.delegate = self
        setupTextView()
        self.automaticallyAdjustsScrollViewInsets = false
        bringUpTexts()

        
        //Source: http://stackoverflow.com/questions/24126678/close-ios-keyboard-by-touching-anywhere-using-swift
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddSightingViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
 
    }
 
 
    // MARK: - ImagePicker
    
    @IBAction func takePhotoButtonPressed(_ sender: UIButton) {
        let imagePickerController = ImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
        bringDownTexts()
        takePhotoButton.setTitle("Retake Photo?", for: .normal)
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
        
        communityPostDict["name"] = sightingName
        communityPostDict["details"] = sightingDetail
        communityPostDict["date"] = newSightingObject.postDate
 
        if let currentWeatherInfo = currentWeather {
            newSightingObject.temperature = currentWeatherInfo.temp
            newSightingObject.weatherDescription = currentWeatherInfo.summary
            communityPostDict["weather"] = currentWeatherInfo.summary
        } else {
            communityPostDict["weather"] = "N/A"
        }
        if let currentLocationInfo = currentLocation {
            newSightingObject.latitude = currentLocationInfo.coordinate.latitude
            newSightingObject.longitude = currentLocationInfo.coordinate.longitude
            communityPostDict["lat"] = currentLocationInfo.coordinate.latitude
            communityPostDict["long"] = currentLocationInfo.coordinate.longitude
        } else {
            communityPostDict["lat"] = 0.0
            communityPostDict["long"] = 0.0
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
        
        showShareAlert()
    }
    
    
    
    func shareWithCommunity() {
        dump(communityPostDict)
        SwiftSpinner.show("Sharing to Community")
        APIRequestManager.manager.makeRequest(httpMethod: .post, endpoint: communityEndpoint, bodyDict: communityPostDict) { (response, _) in
            DispatchQueue.main.async {
                SwiftSpinner.hide()
                if let response = response as? HTTPURLResponse {
                    switch response.statusCode {
                    case 200...299:
                        self.showAlertWith(title: "Success", message: "Your sighting was shared successfully") { (_) in
                            DispatchQueue.main.async {
                                _ = self.navigationController?.popViewController(animated: true) }
                        }
                        print("HTTP Response code: \(response.statusCode)")
                    default:
                        self.showAlertWith(title: "Failure", message: "Your contact was not shared successfully") { (_) in
                            DispatchQueue.main.async {
                                _ = self.navigationController?.popViewController(animated: true) }
                            }
                        print("HTTP Response code: \(response.statusCode)")
                    }
                }
            }
        }
    }
    
    func showShareAlert() {
        let alertController = UIAlertController(title: "Sighting Saved Successfully", message: "Would you like to share your sighting with the WildLifeSighting community?", preferredStyle: .alert)
        let noAction = UIAlertAction(title: "Not Today", style: .cancel) { (_) in
            _ = self.navigationController?.popViewController(animated: true) }
        alertController.addAction(noAction)
        let okayAction = UIAlertAction(title: "OK", style: .default) { (_) in
            self.shareWithCommunity()
        }
        alertController.addAction(okayAction)
        self.present(alertController, animated: true, completion: nil)
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
        currentLocation = validLocation
        locationManager.stopUpdatingLocation()
    }
    
    // MARK: - TextView and Textfield setup
    
    func setupTextView() {
        //SOURCE: http://stackoverflow.com/questions/20790907/uitextview-to-mimic-uitextfield-for-basic-round-corner-text-field
        let borderColor = UIColor(red: 215.0 / 255.0, green: 215.0 / 255.0, blue: 215.0 / 255.0, alpha: 1)
        sightingDetailsTextView.layer.borderColor = borderColor.cgColor
        sightingDetailsTextView.layer.borderWidth = 0.6;
        sightingDetailsTextView.layer.cornerRadius = 6.0;
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        addDetailsLabel.isHidden = true
        bringUpTexts()
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if sightingDetailsTextView.text.isEmpty || sightingDetailsTextView.text == "" {
            addDetailsLabel.isHidden = false
        }
        if sightingImageView.image != nil {
            bringDownTexts()
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        bringUpTexts()
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if sightingImageView.image != nil {
            bringDownTexts()
        }
        return true
    }
    
    func bringUpTexts() {
        photoBottomConstraint.isActive = false
        if sightingImageView.image != nil {
            photoBottomConstraint = sightingImageView.bottomAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -80.0)
        } else {
            photoBottomConstraint = sightingImageView.bottomAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor, constant: 8.0)
        }
        photoBottomConstraint.isActive = true
    }
    
    func bringDownTexts() {

        photoBottomConstraint.isActive = false
        photoBottomConstraint = sightingImageView.bottomAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 8.0)
        photoBottomConstraint.isActive = true
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    func returnDate() -> String {
        let rightNow =  NSDate() as Date
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MM/dd/yyyy"
        return dateformatter.string(from: rightNow)
    }

    
}
