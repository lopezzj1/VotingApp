
//
//  BallotInfoController.swift
//  VotingApp
//
//  Created by iGuest on 12/3/15.
//  Copyright © 2015 Jill Lopez. All rights reserved.
//

import UIKit
import Parse


class BallotInfoController: UIViewController {

    @IBOutlet weak var startVoteButton: UIButton!
    @IBOutlet weak var ballotTitle: UILabel!
    @IBOutlet weak var closingDate: UILabel!
    @IBOutlet weak var ballotInformation: UITextView!
    
    var ballot: Ballot? = nil
    var measures: [Measure]? = nil
    var tableCtrl: BallotTableController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Start trying to load the measures ahead of time
        if let ballot = self.ballot {
            let nav: HackyNavController = self.navigationController as! HackyNavController
            if nav.cachedBallot!.measures == nil { //no cached data go get some
                ballot.measureRelation.query().findObjectsInBackgroundWithBlock {
                    (objects: [PFObject]?, error: NSError?) -> Void in
                    NSLog("getting measures from net")
                    if let pMeasures = objects {
                        nav.cachedBallot?.measures = [String: Measure]()
                        let measures = pMeasures.map {
                            (object: PFObject) -> Measure in
                            let title = object["measureTitle"] as! String
                            let candidates = object["candidates"] as! PFRelation
                            let parseObjId = object.objectId!
                            let thisMeasure = Measure(title: title, candidatesRelation: candidates, candidates: nil, parseObjId: parseObjId)
                            nav.cachedBallot!.measures![parseObjId] = thisMeasure
                            
                            return thisMeasure
                        }
                        if let ctrl = self.tableCtrl {
                            // The table will suddenly populate with data
                            ctrl.measures = measures
                            ctrl.tableView.reloadData()
                        } else {
                            self.measures = measures
                        }
                    }
                }
            } else {
                self.measures = [Measure]()
                for (_, measure) in nav.cachedBallot!.measures! {
                    self.measures!.append(measure)
                }
            }
            
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.setLabels()
    }
    
    func setLabels() {
        // Don't try this unless it's loaded, otherwise it will attempt to unwrap optional UI Elements
        if self.isViewLoaded() {
            if let b = self.ballot {
                self.ballotInformation.text = b.desc
                self.ballotTitle.text = b.title
                self.closingDate.text = b.closingDate.description
            }
        }
        self.ballotInformation.font = UIFont(name: (ballotTitle.font?.fontName)!, size: 17)
        self.ballotInformation.textColor = UIColor.whiteColor()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let dest = segue.destinationViewController as! BallotTableController
        if let measures = self.measures {
            dest.measures = measures
        }
    }
}
