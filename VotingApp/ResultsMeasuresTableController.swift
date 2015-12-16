//
//  ResultsMeasuresTableController.swift
//  VotingApp
//
//  Created by iGuest on 12/15/15.
//  Copyright © 2015 Jill Lopez. All rights reserved.
//

import UIKit
import Parse

class ResultsMeasuresTableController: UITableViewController {
    
    var ballot: Ballot? = nil
    var measures: [Measure]? = nil
    var measureToSend:Measure? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        if let ballot = self.ballot {
            let nav: HackyNavController = self.navigationController as! HackyNavController
            if nav.cachedResults![ballot.parseObjId]?.measures == nil { //no cached data go get some
                ballot.measureRelation.query().findObjectsInBackgroundWithBlock {
                    (objects: [PFObject]?, error: NSError?) -> Void in
                    NSLog("getting measures from net")
                    if let pMeasures = objects {
                        nav.cachedResults![ballot.parseObjId]?.measures = [String: Measure]()
                        let measures = pMeasures.map {
                            (object: PFObject) -> Measure in
                            let title = object["measureTitle"] as! String
                            let candidates = object["candidates"] as! PFRelation
                            let parseObjId = object.objectId!
                            let thisMeasure = Measure(title: title, candidatesRelation: candidates, candidates: nil, parseObjId: parseObjId)
                            nav.cachedResults![ballot.parseObjId]!.measures![parseObjId] = thisMeasure
                            
                            return thisMeasure
                        }
                        self.measures = measures
                        self.tableView.reloadData()
                    }
                }
            } else {
                self.measures = [Measure]()
                for (_, measure) in nav.cachedResults![ballot.parseObjId]!.measures! {
                    self.measures!.append(measure)
                }
            }
            
        }
        
        tableView.tableFooterView = UIView()
        tableView.backgroundView = UIImageView(image: UIImage(named: "colored_background_blur"))
        
        self.tableView.reloadData()
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
        }
        return 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("measure", forIndexPath: indexPath)

        if let measures = self.measures {
            cell.textLabel?.text = measures[indexPath.row].title
        }
        
        cell.textLabel?.textColor = UIColor.lightGrayColor()
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red: 21/255, green: 63/255, blue: 129/255, alpha: 1)
        cell.selectedBackgroundView = backgroundView

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let measure = self.measures?[indexPath.row] {
            
            self.measureToSend = measure
            
            self.performSegueWithIdentifier("showMeasureDetailSegue", sender: nil)
        }
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
        if segue.identifier == "showMeasureDetailSegue" {
            let destinationVC = segue.destinationViewController as! ResultsMeasureDetailController
            destinationVC.measure = self.measureToSend
            destinationVC.ballotParseObjId = self.ballot!.parseObjId
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBar.hidden = true
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.hidden = false
    }

}
