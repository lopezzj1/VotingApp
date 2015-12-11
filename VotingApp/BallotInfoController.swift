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
    let measures: [String]
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
        
        // Do any additional setup after loading the view.
        let parseQuery = PFQuery(className: "ballots")
        parseQuery.whereKey("closingDate", greaterThan: NSDate()).orderByAscending("closingDate")
        
        parseQuery.getFirstObjectInBackgroundWithBlock {
            (object: PFObject?, error: NSError?) -> Void in
            if let parseBallot = object {
                let measureRelation: PFRelation = parseBallot["measures"] as! PFRelation
                let closingDate: NSDate = parseBallot["closingDate"] as! NSDate
                let title: String = parseBallot["title"] as! String
                let description: String = parseBallot["description"] as! String
                
                self.ballot = Ballot(measures: ["test", "test"], closingDate: closingDate, desc: description, title: title)
                
                self.setLabels(self.ballot!)
                
                measureRelation.query().findObjectsInBackgroundWithBlock {
                    (objects: [PFObject]?, error: NSError?) -> Void in
                    if let measures = objects {
                        print(measures)
                    }
                }
            }
            
        }
        
    }
    
    func setLabels(ballot: Ballot) {
        self.ballotInfo.text = ballot.desc
        self.ballotTitle.text = ballot.title
        self.closingDate.text = ballot.closingDate.description
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
