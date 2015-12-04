//
//  ViewController.swift
//  test
//
//  Created by iGuest on 12/3/15.
//  Copyright © 2015 iGuest. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var parseString: UILabel!
    
    @IBOutlet weak var parseDataTable: UITableView!
    

    
    // Keeps track of the cells
    var peoples: [parsePerson] = []
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        NSLog("we're constructing a table")
        let cell: ParseDataCell = tableView.dequeueReusableCellWithIdentifier("parseCell", forIndexPath: indexPath) as! ParseDataCell
        let person: parsePerson = peoples[indexPath.row]
        cell.setData(person: person)
        return cell
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peoples.count
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        parseDataTable.dataSource = self
        
        let query1 = PFQuery(className:"fake_data")
        query1.getObjectInBackgroundWithId("xwVmdqHfQE") {
            (fake_data: PFObject?, error: NSError?) -> Void in
            if let fakeObj = fake_data {
                self.parseString.text = "String from parse: \(fakeObj["hello"])"
            } else {
                print(error)
            }
        }
        
        // Used to populate a table
        let arrayQuery = PFQuery(className: "fake_table")
        // The query is empty, so it should return everything
        arrayQuery.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if let people = objects {
                let persons: [parsePerson] = people.map {
                    (p: PFObject) -> parsePerson in
                    return parsePerson(name: p["name"] as! String, job: p["job"] as! String)
                }
                
                self.peoples += persons
                self.parseDataTable.reloadData()
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

