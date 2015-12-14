//
//  DataStructures.swift
//  VotingApp
//
//  Created by iGuest on 12/12/15.
//  Copyright © 2015 Jill Lopez. All rights reserved.
//

import Foundation
import Parse

struct Ballot {
    var measures: [Measure]?
    let measureRelation: PFRelation
    let closingDate: NSDate
    let desc: String
    let title: String
}

struct Measure {
    let title: String
    let candidatesRelation: PFRelation
    var candidates: [Candidate]?
}

struct Candidate {
    let name: String
    let title: String
    let bioURL: String
    let bioText: String
    let pictureURL: String
    let position: String
}