//
//  CandidateCell.swift
//  VotingApp
//
//  Created by iGuest on 12/14/15.
//  Copyright © 2015 Jill Lopez. All rights reserved.
//

import UIKit

class CandidateCell: UITableViewCell {
    
    var candidate: Candidate? = nil

    @IBOutlet weak var detailButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
