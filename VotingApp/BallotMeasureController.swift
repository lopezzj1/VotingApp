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
