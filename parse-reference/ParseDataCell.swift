//
//  ParseDataCell.swift
//  test
//
//  Created by iGuest on 12/3/15.
//  Copyright © 2015 iGuest. All rights reserved.
//

import UIKit

struct parsePerson {
    let name: String
    let job: String
}

class ParseDataCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var jobLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // Used for configuration
    func setData(person p: parsePerson) {
        NSLog("data is being altered")
        self.nameLabel?.text = p.name
        self.jobLabel?.text = p.job
    }
}
