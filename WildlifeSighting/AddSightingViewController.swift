//
//  AddSightingViewController.swift
//  WildlifeSighting
//
//  Created by Sabrina Ip on 1/9/17.
//  Copyright © 2017 Sabrina, Vic, Tom. All rights reserved.
//

import UIKit

class AddSightingViewController: UIViewController {

    @IBOutlet weak var sightingNameTextField: UITextField!
    @IBOutlet weak var sightingDetailsTextView: UITextView!
    @IBOutlet weak var currentWeatherSwitch: UISwitch!
    @IBOutlet weak var currentLocationSwitch: UISwitch!
    @IBOutlet weak var shareToTwitterSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func takePhotoButtonPressed(_ sender: UIButton) {
    }
    @IBAction func saveBarButtonPressed(_ sender: UIBarButtonItem) {
    }
}
