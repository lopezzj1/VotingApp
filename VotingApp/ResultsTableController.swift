//
//  ResultsTableController.swift
//  VotingApp
//
//  Created by iGuest on 12/3/15.
//  Copyright © 2015 Jill Lopez. All rights reserved.
//

import UIKit
import Parse

class ResultsTableController: UITableViewController {
    
    var results: [Ballot] = []
    
    var selectedBallot: Ballot? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        tableView.tableFooterView = UIView()
        tableView.backgroundView = UIImageView(image: UIImage(named: "colored_background_blur"))
        
        let nav: HackyNavController = self.navigationController as! HackyNavController
        
        if let ballots = nav.cachedResults {
            for (_, ballot) in ballots {
                self.results.append(ballot)
            }
        } else {
            nav.cachedResults = [String: Ballot]()
            let parseQuery = PFQuery(className: "ballots")
            parseQuery.whereKey("closingDate", lessThan: NSDate()).orderByDescending("closingDate")
            
            parseQuery.findObjectsInBackgroundWithBlock {
                (ballots: [PFObject]?, error: NSError?) -> Void in
                if let ballots = ballots {
                    for parseBallot in ballots {
                        let closingDate = parseBallot["closingDate"] as! NSDate
                        let title = parseBallot["title"] as! String
                        let description = parseBallot["description"] as! String
                        let measureRelation = parseBallot["measures"] as! PFRelation
                        let parseObjId = parseBallot.objectId!
                        let image = parseBallot["ballotImageURL"] as! String
                        
                        let thisBallot = Ballot(measures: nil, measureRelation: measureRelation, closingDate: closingDate, desc: description, title: title, parseObjId: parseObjId, image: image)
                        self.results.append(thisBallot)
                        nav.cachedResults![parseObjId] = thisBallot
                    }
                    self.tableView.reloadData()
                } else {
                    NSLog("error downloading")
                }
            }
        }
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
        return self.results.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("resultTableCellIdentifier", forIndexPath: indexPath)

        // Configure the cell...
        cell.textLabel?.text = self.results[indexPath.row].title
        cell.textLabel?.textColor = UIColor.lightGrayColor()
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red: 21/255, green: 63/255, blue: 129/255, alpha: 1)
        cell.selectedBackgroundView = backgroundView

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedBallot = self.results[indexPath.row]
        self.performSegueWithIdentifier("resultsViewSegue", sender: nil)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "resultsViewSegue" {
            let destinationVC = segue.destinationViewController as! ResultsMeasuresTableController
            destinationVC.ballot = self.selectedBallot
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBar.hidden = true
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.hidden = false
    }
}
