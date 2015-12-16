//
//  ResultsMeasureDetailController.swift
//  VotingApp
//
//  Created by iGuest on 12/15/15.
//  Copyright © 2015 Jill Lopez. All rights reserved.
//

import UIKit
import Parse

class ResultsMeasureDetailController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var measureLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalVotes: UILabel!
    
    
    
    var measure: Measure? = nil
    var candidates: [Candidate]? = nil
    var totVotes: Int? = nil
    var ballotParseObjId: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.measureLabel.text = measure?.title
        
        let nav: HackyNavController = self.navigationController as! HackyNavController
        if var measure = self.measure {
            if nav.cachedResults![self.ballotParseObjId!]!.measures![measure.parseObjId]!.candidates == nil { //NO CACHED DATA GET SOME
                
                let parseQuery = PFQuery(className: "Measure_Results")
                let measureParseObj = PFObject.init(withoutDataWithClassName: "candidateMeasure", objectId: measure.parseObjId)
                parseQuery.whereKey("candidateMeasureID", equalTo: measureParseObj)
                
//                let ballotResponseQuery = PFQuery(className:"ballotResponse")
//                let user = PFObject.init(withoutDataWithClassName: "_User", objectId: user.objectId!)
//                let measure = PFObject.init(withoutDataWithClassName: "candidateMeasure", objectId: self.measure!.parseObjId)
//                ballotResponseQuery.whereKey("measure", equalTo: measure)
//                ballotResponseQuery.whereKey("user", equalTo: user)
                
                parseQuery.findObjectsInBackgroundWithBlock {
                    (objects: [PFObject]?, error: NSError?) -> Void in
                    NSLog("getting candidates from net")
                    if let candidates = objects {
                        measure.candidates = [String: Candidate]()
                        self.candidates = [Candidate]()
                        for candidateParseObject in candidates {
                            let name = candidateParseObject["Candidate_Proposition"] as! String
                            let title = "title"
                            let bioURL = "url"
                            let bioText = "text"
                            let pictureURL = "picUrl"
                            let position = "position"
                            let parseObjId = candidateParseObject.objectId! as String
                            let party = "party"
                            let votes = candidateParseObject["Num_Of_Votes"] as! Int
                            let thisCandidate = Candidate(name: name, title: title, bioURL: bioURL, bioText: bioText, pictureURL: pictureURL, position: position, parseObjId: parseObjId, party: party, votes: votes)
                            measure.candidates![parseObjId] = thisCandidate
                            //nav.cachedBallot?.measures![(self.measure?.parseObjId)!]!.candidates![parseObjId] = thisCandidate
                            self.candidates!.append(thisCandidate)
                        }
                        nav.cachedResults![self.ballotParseObjId!]!.measures![measure.parseObjId]?.candidates = measure.candidates
                        self.measure = measure
                        self.updateData()
                    } else { //no candidates found.
                        //shit this wasn't supposed to happen there are no answers for this ballot
                        NSLog("BAD DATA NO CANDIDATES")
                    }
                }
            } else { //DATA WAS CACHED DON'T TOUCH THE NETWORK
                self.measure!.candidates = nav.cachedResults![ballotParseObjId!]!.measures![measure.parseObjId]?.candidates
                self.candidates = [Candidate]()
                for (_,candidate) in self.measure!.candidates! {
                    self.candidates!.append(candidate)
                }
                self.updateData()
            }
        }else {
            //SOMETHING BAD HAPPEND THERE IS NO MEASURE
            NSLog("THERE WAS NO MEASURE, THIS SHOULD NOT BE POSSIBLE")
        }
        tableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("candidate", forIndexPath: indexPath) as! MeasureDetailCandidateCell
        
        if let candidates = self.candidates {
            cell.name.text = candidates[indexPath.row].name
            cell.votes.text = "Votes: \(candidates[indexPath.row].votes!)"
            cell.percent.text = "\(100.0 * Double(candidates[indexPath.row].votes!) / Double(self.totVotes!))%"
        }
        cell.textLabel?.textColor = UIColor.whiteColor()
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let candidates = self.candidates {
            return candidates.count
        }
        return 0
    }

    func calcTotalVotes() {
        self.totVotes = self.candidates?.reduce(0, combine: { (x: Int, c: Candidate) -> Int in
            var votes = 0
            if c.votes != nil {
                votes = c.votes!
            }
            return votes + x
        })
        self.totalVotes.text = "Total Votes: \(self.totVotes!)"
    }
    
    func updateData() {
        self.calcTotalVotes()
        self.tableView.reloadData()
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
