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
    var measures: [String: Measure]?
    let measureRelation: PFRelation
    let closingDate: NSDate
    let desc: String
    let title: String
    let parseObjId: String
}

struct Measure {
    let title: String
    let candidatesRelation: PFRelation
    var candidates: [String: Candidate]?
    let parseObjId: String
}

struct Candidate {
    let name: String
    let title: String
    let bioURL: String
    let bioText: String
    let pictureURL: String
    let position: String
    let parseObjId: String
    let votes: Int? = nil
}

var states: [String] = ["", "Alabama", "Alaska", "American Samoa", "Arizona", "Arkansas", "California", "Colorado", "Connecticut", "Delaware", "District Of Columbia", "Federated States Of Micronesia", "Florida", "Georgia", "Guam", "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky", "Louisiana", "Maine", "Marshall Islands", "Maryland", "Massachusetts", "Michigan", "Minnesota", "Mississippi", "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire", "New Jersey", "New Mexico", "New York", "North Carolina", "North Dakota", "Northern Mariana Islands", "Ohio", "Oklahoma", "Oregon", "Palau", "Pennsylvania", "Puerto Rico", "Rhode Island", "South Carolina", "South Dakota", "Tennessee", "Texas", "Utah", "Vermont", "Virgin Islands", "Virginia", "Washington", "West Virginia", "Wisconsin", "Wyoming"]