//
//  BallotMeasureController.swift
//  VotingApp
//
//  Created by iGuest on 12/3/15.
//  Copyright © 2015 Jill Lopez. All rights reserved.
//

import UIKit
import Parse


class BallotMeasureController: UIViewController {

    @IBOutlet weak var voteButton: UIButton!
    @IBOutlet weak var ballotOptions: UITableView!

    var measure: Measure? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        if var measure = self.measure {
            if measure.candidates == nil {
                measure.candidatesRelation.query().findObjectsInBackgroundWithBlock {
                    (objects: [PFObject]?, error: NSError?) -> Void in
                    if let candidates = objects {
                        measure.candidates = []
                        for candidateParseObject in candidates {
                            let name = candidateParseObject["name"] as! String
                            let title = candidateParseObject["title"] as! String
                            let bioURL = candidateParseObject["bioURL"] as! String
                            let bioText = candidateParseObject["bioText"] as! String
                            let pictureURL = candidateParseObject["pictureURL"] as! String
                            let position = candidateParseObject["position"] as! String
                            let thisCandidate = Candidate(name: name, title: title, bioURL: bioURL, bioText: bioText, pictureURL: pictureURL, position: position)
                            measure.candidates!.append(thisCandidate)
                        }
                        self.measure = measure
                        self.updateTable()
                        
                    } else { //no candidates found.
                        //shit this wasn't supposed to happen there are no answers for this ballot
                        NSLog("BAD DATA NO CANDIDATES")
                    }
                }
            }
        }else {
            //SOMETHING BAD HAPPEND THERE IS NO MEASURE
        }
        
    }
    
    func updateTable() {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Do an if check if another segue is ever added
        //let dest = segue.destinationViewController as! BallotTableController
    }
}
