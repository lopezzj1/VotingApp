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
    var measureCtrl: BallotMeasureController? = nil
    var measureToSend: Measure? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let path = NSIndexPath(forRow: 0, inSection: 0)
        let scroll = UITableViewScrollPosition(rawValue: 0)
        NSLog("about to select")
        self.tableView.selectRowAtIndexPath(path, animated: true, scrollPosition: scroll!)
        tableView.tableFooterView = UIView()
        tableView.backgroundView = UIImageView(image: UIImage(named: "colored_background_blur"))
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
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red: 21/255, green: 63/255, blue: 129/255, alpha: 1)
        cell.selectedBackgroundView = backgroundView
        
        return cell
    }
    
    // Called when a user selects a cell
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //let cell = tableView.dequeueReusableCellWithIdentifier("measureCell", forIndexPath: indexPath) as! MeasureCell
        if let measure = self.measures?[indexPath.row] {
            if let candidates = measure.candidates {
                // Set this value for the next controller, it's been cached already
            }
            
            self.measureToSend = measure
            
            self.performSegueWithIdentifier("showMeasureSegue", sender: nil)
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "showMeasureSegue" {
            let destinationVC = segue.destinationViewController as! BallotMeasureController
            destinationVC.measure = self.measureToSend
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBar.hidden = true
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.hidden = false
    }


}
