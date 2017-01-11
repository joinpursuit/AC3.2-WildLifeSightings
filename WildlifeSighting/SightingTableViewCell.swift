//
//  SightingTableViewCell.swift
//  WildlifeSighting
//
//  Created by Sabrina Ip on 1/9/17.
//  Copyright © 2017 Sabrina, Vic, Tom. All rights reserved.
//

import UIKit

// SOURCE for how to use button in xib to segue: http://stackoverflow.com/questions/26880526/performing-a-segue-from-a-button-within-a-custom-uitableviewcell
protocol MyCustomCellDelegator {
    func callSegueFromCell(myData dataobject: AnyObject)
}

class SightingTableViewCell: UITableViewCell {

    @IBOutlet weak var sightingImageView: UIImageView!
    @IBOutlet weak var sightingTitleLabel: UILabel!
    @IBOutlet weak var sightingDateAndTimeLabel: UILabel!
    @IBOutlet weak var infoButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var delegate: MyCustomCellDelegator!
    
    @IBAction func infoButtonTapped(_ sender: UIButton) {
        let mydata = "Anydata you want to send to the next controller"
        if(self.delegate != nil){ //Just to be safe.
            self.delegate.callSegueFromCell(myData: mydata as AnyObject)
        }
    }
    

}
