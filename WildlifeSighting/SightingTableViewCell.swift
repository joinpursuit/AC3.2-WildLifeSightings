//
//  SightingTableViewCell.swift
//  WildlifeSighting
//
//  Created by Sabrina Ip on 1/9/17.
//  Copyright © 2017 Sabrina, Vic, Tom. All rights reserved.
//

import UIKit

class SightingTableViewCell: UITableViewCell {

    @IBOutlet weak var SightingImageView: UIImageView!
    @IBOutlet weak var sightingTitleLabel: UILabel!
    @IBOutlet weak var sightingDateAndTimeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func showDetailsButtonPressed(_ sender: UIButton) {
    }
}
