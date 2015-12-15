//
//  BallotMeasureController.swift
//  VotingApp
//
//  Created by iGuest on 12/3/15.
//  Copyright © 2015 Jill Lopez. All rights reserved.
//

import UIKit
import Parse


class BallotMeasureController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var voteButton: UIButton!
    @IBOutlet weak var ballotOptions: UITableView!
    @IBOutlet weak var tableView: UITableView!

    var measure: Measure? = nil
    var selectedCandidate: Candidate? = nil
    var candidates: [Candidate]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        let nav: HackyNavController = self.navigationController as! HackyNavController
        if var measure = self.measure {
            if nav.cachedBallot?.measures![measure.parseObjId]?.candidates == nil { //NO CACHED DATA GET SOME
                measure.candidatesRelation.query().findObjectsInBackgroundWithBlock {
                    (objects: [PFObject]?, error: NSError?) -> Void in
                    NSLog("getting candidates from net")
                    if let candidates = objects {
                        measure.candidates = [String: Candidate]()
                        self.candidates = [Candidate]()
                        for candidateParseObject in candidates {
                            let name = candidateParseObject["name"] as! String
                            let title = candidateParseObject["title"] as! String
                            let bioURL = candidateParseObject["bioURL"] as! String
                            let bioText = candidateParseObject["bioText"] as! String
                            let pictureURL = candidateParseObject["pictureURL"] as! String
                            let position = candidateParseObject["position"] as! String
                            let parseObjId = candidateParseObject.objectId! as String
                            let thisCandidate = Candidate(name: name, title: title, bioURL: bioURL, bioText: bioText, pictureURL: pictureURL, position: position, parseObjId: parseObjId)
                            measure.candidates![parseObjId] = thisCandidate
                            //nav.cachedBallot?.measures![(self.measure?.parseObjId)!]!.candidates![parseObjId] = thisCandidate
                            self.candidates!.append(thisCandidate)
                        }
                        nav.cachedBallot?.measures![measure.parseObjId]?.candidates = measure.candidates
                        self.measure = measure
                        self.updateTable()
                    } else { //no candidates found.
                        //shit this wasn't supposed to happen there are no answers for this ballot
                        NSLog("BAD DATA NO CANDIDATES")
                    }
                }
            } else { //DATA WAS CACHED DON'T TOUCH THE NETWORK
                self.measure!.candidates = nav.cachedBallot?.measures![measure.parseObjId]?.candidates
                self.candidates = [Candidate]()
                for (_,candidate) in self.measure!.candidates! {
                    self.candidates!.append(candidate)
                }
            }
        }else {
            //SOMETHING BAD HAPPEND THERE IS NO MEASURE
            NSLog("THERE WAS NO MEASURE, THIS SHOULD NOT BE POSSIBLE")
        }
    }
    
    func updateTable() {
        self.tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("options", forIndexPath: indexPath) 
        
        if let candidates = self.candidates {
            //cell.titleLabel.text = candidates[indexPath.row].title
            cell.textLabel?.text = candidates[indexPath.row].name
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let measure = self.measure {
            if let candidates = measure.candidates {
                return candidates.count
            }
        }
        return 0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedCandidate = self.candidates![indexPath.row]
    }

    @IBAction func voteButtonPress(sender: UIButton) {
        //push the vote up to parse
        if let candidate = self.selectedCandidate {
            if let user = PFUser.currentUser() {
                if user.authenticated {
                    //check if the user has already voted on this before
                    let ballotResponseQuery = PFQuery(className:"ballotResponse")
                    let user = PFObject.init(withoutDataWithClassName: "_User", objectId: user.objectId!)
                    let measure = PFObject.init(withoutDataWithClassName: "candidateMeasure", objectId: self.measure!.parseObjId)
                    ballotResponseQuery.whereKey("measure", equalTo: measure)
                    ballotResponseQuery.whereKey("user", equalTo: user)
                    
                    var ballotResponse: PFObject? = nil
                    
                    ballotResponseQuery.findObjectsInBackgroundWithBlock {
                        (objects: [PFObject]?, error: NSError?) -> Void in
                        if let objects = objects {
                            let candidate = PFObject.init(withoutDataWithClassName: "candidates", objectId: candidate.parseObjId)
                            if objects.count > 0 { //update old vote
                                ballotResponse = objects[0]
                                ballotResponse!["candidate"] = candidate
                                ballotResponse!["user"] = user
                            } else { // new vote
                                ballotResponse = PFObject(className:"ballotResponse")
                                ballotResponse!["measure"] = measure
                                ballotResponse!["user"] = user
                                ballotResponse!["candidate"] = candidate
                            }
                        } else { //error

                        }
                        ballotResponse!.saveInBackgroundWithBlock {
                            (success: Bool, error: NSError?) -> Void in
                            if (success) {
                                NSLog("TYVM for voting for \(candidate.name)")
                            } else {
                                NSLog("voting failed")
                            }
                        }
                    }
                } else {
                    NSLog("user not authenticated")
                }
            } else {
                NSLog("no user somehow")
            }
        }
        //do nothing if no candidate is selected.
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
