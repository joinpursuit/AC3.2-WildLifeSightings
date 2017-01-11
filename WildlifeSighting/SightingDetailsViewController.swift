//
//  SightingDetailsViewController.swift
//  WildlifeSighting
//
//  Created by Sabrina Ip on 1/9/17.
//  Copyright © 2017 Sabrina, Vic, Tom. All rights reserved.
//

import UIKit

class SightingDetailsViewController: UIViewController {

    var sighting: Sighting!
    
    @IBOutlet weak var sightingImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var editSaveButton: UIButton!
    @IBOutlet weak var detailsTextView: UITextView!
    @IBOutlet weak var dateWeatherLocationTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLabels()
    }
    
    func updateLabels() {
        titleLabel.text = sighting.name!
        detailsTextView.text = sighting.details ?? ""
        if let image = sighting.fullImageData as? Data {
            sightingImageView.image = UIImage(data: image)
        }
        var dateWeatherText = ""
        dateWeatherText += sighting.dateString
        dateWeatherText += "\n" + sighting.time
        
        if sighting.latitude != 0 && sighting.longitude != 0 {
            dateWeatherText += "\nLatitude:" + String(sighting.latitude)
            dateWeatherText += "\nLongitude:" + String(sighting.longitude)
            //TODO: Get Placemark
        }
        
        if let weather = sighting.weatherDescription, weather != "" {
            dateWeatherText += "\nWeather:" + weather
        }
        dateWeatherLocationTextView.text = dateWeatherText
    }
    
    @IBAction func editSaveButtonPressed(_ sender: UIButton) {
        if editSaveButton.titleLabel?.text == "Edit" {
            titleLabel.isHidden = true
            titleTextField.isHidden = false
            detailsTextView.isEditable = true
            titleTextField.text = titleLabel.text
            editSaveButton.setTitle("Save", for: .normal)
        } else {
            titleTextField.isHidden = true
            titleLabel.isHidden = false
            detailsTextView.isEditable = false
            titleLabel.text = titleTextField.text
            editSaveButton.setTitle("Edit", for: .normal)

        }
    }
}
