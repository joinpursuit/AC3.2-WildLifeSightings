//
//  SightingDetailsViewController.swift
//  WildlifeSighting
//
//  Created by Sabrina Ip on 1/9/17.
//  Copyright © 2017 Sabrina, Vic, Tom. All rights reserved.
//

import UIKit

class SightingDetailsViewController: UIViewController {

    @IBOutlet weak var sightingImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var editSaveButton: UIButton!
    @IBOutlet weak var detailsTextView: UITextView!
    @IBOutlet weak var dateWeatherLocationTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // TO DO - VISION
        // titleTextField is hidden until edit button is pressed
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
