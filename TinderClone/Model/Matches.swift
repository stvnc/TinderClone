//
//  Matches.swift
//  TinderClone
//
//  Created by Vincent Angelo on 24/06/20.
//  Copyright © 2020 Vincent Angelo. All rights reserved.
//

import Foundation

struct Matches {
    let name: String
    let profileImageURL: String
    let uid: String
    
    init(dictionary: [String:Any]) {
        self.name = dictionary["name"] as? String ?? ""
        self.profileImageURL = dictionary["profileImageURL"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
}
