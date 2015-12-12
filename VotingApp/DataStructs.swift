//
//  DataStructs.swift
//  VotingApp
//
//  Created by iGuest on 12/12/15.
//  Copyright © 2015 Jill Lopez. All rights reserved.
//

import Foundation
import Parse

struct Ballot {
    let measures: [Measure]?
    let measureRelation: PFRelation
    let closingDate: NSDate
    let desc: String
    let title: String
}

struct Measure {
    let title: String
    let candidates: PFRelation
}
