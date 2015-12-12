//
//  MenuController.swift
//  VotingApp
//
//  Created by iGuest on 12/3/15.
//  Copyright © 2015 Jill Lopez. All rights reserved.
//

import UIKit
import Parse

class MenuController: UIViewController {

    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var electionsButton: UIButton!
    @IBOutlet weak var resultsButton: UIButton!
    
    // Used so that we can pass this value forward to the ballot controller
    var ballot: Ballot? = nil
    
    // The key to caching values ahead of time is getting a reference to the next controller, so that we can update it asynchronlously here!
    // Our request code must be exectuted in this controller, but there's no reason we can't modify a controller from here
    var ballotCtrl: BallotInfoController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let parseQuery = PFQuery(className: "ballots")
        parseQuery.whereKey("closingDate", greaterThan: NSDate()).orderByAscending("closingDate")
        
        // Executes the query asynchronously, optionally returning the first object
        parseQuery.getFirstObjectInBackgroundWithBlock {
            (object: PFObject?, error: NSError?) -> Void in
            if let parseBallot = object {
                let measureRelation: PFRelation = parseBallot["measures"] as! PFRelation
                let closingDate: NSDate = parseBallot["closingDate"] as! NSDate
                let title: String = parseBallot["title"] as! String
                let description: String = parseBallot["description"] as! String
                
                // Now we execute yet another query to get the measures
                measureRelation.query().findObjectsInBackgroundWithBlock {
                    (objects: [PFObject]?, error: NSError?) -> Void in
                    if let pMeasures = objects {
                        let measures = pMeasures.map {
                            (object: PFObject) -> Measure in
                            let title = object["measureTitle"] as! String
                            let candidates = object["candidates"] as! PFRelation
                            return Measure(title: title, candidates: candidates)
                        }
                        
                        let ballot = Ballot(measures: measures, closingDate: closingDate, desc: description, title: title)
                        
                        // If a controller is set, that means we've gone to the next controller already, and will update it there
                        if let ctrl = self.ballotCtrl {
                            ctrl.ballot = ballot
                            ctrl.setLabels()
                            // Otherwise we're still in the menu, and just need the ballot to be cached
                        } else {
                            self.ballot = ballot
                        }
                    }
                }
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
        
        // Check that we're going to the elections controller
        if segue.identifier == "electionsSegue" {
            let dest = segue.destinationViewController as! BallotInfoController
            
            // Sets the controller so if our request is still loading, it will update when it can
            self.ballotCtrl = dest
            
            // If our ballot has already loaded from parse though, we can set it here
            if let ballot = self.ballot {
                dest.ballot = ballot
            }
        }
    }
}
