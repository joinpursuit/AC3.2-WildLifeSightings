//
//  SightingTableViewCell.swift
//  WildlifeSighting
//
//  Created by Sabrina Ip on 1/9/17.
//  Copyright © 2017 Sabrina, Vic, Tom. All rights reserved.
//

import UIKit

class SightingTableViewCell: UITableViewCell {

    @IBOutlet weak var sightingImageView: UIImageView!
    @IBOutlet weak var sightingTitleLabel: UILabel!
    @IBOutlet weak var sightingDateAndTimeLabel: UILabel!
    @IBOutlet weak var infoButton: UIButton!
    
    @IBOutlet weak var weatherEmojiLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
