//
//  SightingMKPointAnnotation.swift
//  WildlifeSighting
//
//  Created by Tom Seymour on 1/11/17.
//  Copyright © 2017 Sabrina, Vic, Tom. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class SightingMKPointAnnotation: MKPointAnnotation {
    var managedObject: Sighting?
    
    override init () {
        managedObject = nil
        super.init()
    }
    
}
