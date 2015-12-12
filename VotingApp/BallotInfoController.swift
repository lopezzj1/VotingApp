//
//  BallotInfoController.swift
//  VotingApp
//
//  Created by iGuest on 12/3/15.
//  Copyright © 2015 Jill Lopez. All rights reserved.
//

import UIKit
import Parse

struct Ballot {
    let measures: [Measure]?
    let measureRelation: PFRelation
    let closingDate: NSDate
    let desc: String
    let title: String
}

class BallotInfoController: UIViewController {

    @IBOutlet weak var startVoteButton: UIButton!
    @IBOutlet weak var ballotInfo: UILabel!
    @IBOutlet weak var ballotTitle: UILabel!
    @IBOutlet weak var closingDate: UILabel!
    
    var ballot: Ballot? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.setLabels()
    }
    
    func setLabels() {
        // Don't try this unless it's loaded, otherwise it will attempt to unwrap optional UI Elements
        if self.isViewLoaded() {
            if let b = self.ballot {
                self.ballotInfo.text = b.desc   
                self.ballotTitle.text = b.title
                self.closingDate.text = b.closingDate.description
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}
