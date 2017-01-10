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


class AddSightingViewController: UIViewController, ImagePickerDelegate {

    // MARK: - Outlets
    

    @IBOutlet weak var sightingImageView: UIImageView!

    @IBOutlet weak var sightingNameTextField: UITextField!
    @IBOutlet weak var sightingDetailsTextView: UITextView!
    @IBOutlet weak var currentWeatherSwitch: UISwitch!
    @IBOutlet weak var currentLocationSwitch: UISwitch!
    @IBOutlet weak var shareToTwitterSwitch: UISwitch!
    
    
    // MARK: - Preperties
    
    var sightingPhoto: UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func takePhotoButtonPressed(_ sender: UIButton) {
        
    }
    
    
    
    
    @IBAction func saveBarButtonPressed(_ sender: UIBarButtonItem) {
        guard let sightingName = sightingNameTextField.text, sightingName.characters.count > 0 else {
            showAlertWith(title: "No Name", message: "Please make sure you've entered a name for this sighting.")
            return
        }
        guard let sightingDetail = sightingDetailsTextView.text, sightingDetail.characters.count > 0 else {
            showAlertWith(title: "No Details", message: "Please make sure you've entered details for this sighting.")
            return
        }
        
        
    }
    
    
    // MARK: - Image Picker Delegate Methods
    
    func showAlertWith(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(okayAction)
        present(alert, animated: true, completion: nil)
    }
    
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        print("wrapperDidPress")
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        print("doneButtonPressed")
        
        dismiss(animated: true, completion: nil)
        print(images.count)
        print(images)
        sightingPhoto = images[0]   
        
        
        
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        print("cancel")
        
        dismiss(animated: true, completion: nil)
        
        
        
    }

    
    

    
}
