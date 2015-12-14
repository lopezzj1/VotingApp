//
//  BallotTableController.swift
//  VotingApp
//
//  Created by iGuest on 12/3/15.
//  Copyright © 2015 Jill Lopez. All rights reserved.
//

import UIKit
import Parse

class BallotTableController: UITableViewController {

    var measures: [Measure]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let path = NSIndexPath(forRow: 0, inSection: 0)
        let scroll = UITableViewScrollPosition(rawValue: 0)
        NSLog("about to select")
        self.tableView.selectRowAtIndexPath(path, animated: true, scrollPosition: scroll!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let measures = self.measures {
            return measures.count
        } else {
            return 0
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("measureCell", forIndexPath: indexPath) as! MeasureCell

        if let measures = self.measures {
            cell.titleLabel.text = measures[indexPath.row].title
        }
        
        return cell
    }
    
    // Called when a user selects a cell
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        NSLog("WFT")
        //let cell = tableView.dequeueReusableCellWithIdentifier("measureCell", forIndexPath: indexPath) as! MeasureCell
        if let measure = self.measures?[indexPath.row] {
            if let candidates = measure.candidates {
                // Set this value for the next controller, it's been cached already
            } else { // start doing a query for the candidates, we don't have it
                self.measures![indexPath.row].candidates = getCandidatesForMeasure(measure.candidatesRelation.query())
                NSLog("finished getting candidates I think maybe")
            }
        }
    }
    
    func getCandidatesForMeasure(measureQuery: PFQuery) -> [Candidate] {
        var result: [Candidate] = []
        measureQuery.findObjectsInBackgroundWithBlock{
            (objects: [PFObject]?, error: NSError?) -> Void in
            if let candidates = objects {
                for candidateParseObject in candidates {
                    let name = candidateParseObject["name"] as! String
                    let title = candidateParseObject["title"] as! String
                    let bioURL = candidateParseObject["bioURL"] as! String
                    let bioText = candidateParseObject["bioText"] as! String
                    let pictureURL = candidateParseObject["pictureURL"] as! String
                    let position = candidateParseObject["position"] as! String
                    let thisCandidate = Candidate(name: name, title: title, bioURL: bioURL, bioText: bioText, pictureURL: pictureURL, position: position)
                    result.append(thisCandidate)
                }
            } else { //no candidates found.
                //shit this wasn't supposed to happen there are no answers for this ballot
                print("we're stuck here")
            }
        }
        return result
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
