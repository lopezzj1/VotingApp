//
//  MeasureDetailCandidateCell.swift
//  VotingApp
//
//  Created by iGuest on 12/15/15.
//  Copyright © 2015 Jill Lopez. All rights reserved.
//

import UIKit

class MeasureDetailCandidateCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var votes: UILabel!
    @IBOutlet weak var percent: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
