//
//  User.swift
//  TinderClone
//
//  Created by Vincent Angelo on 18/06/20.
//  Copyright © 2020 Vincent Angelo. All rights reserved.
//

import UIKit

struct User {
    var name: String
    var age: Int
    var email: String
    let uid: String
    var profileImageURLs: [String]
    var profession: String
    var minSeekingAge: Int
    var maxSeekingAge: Int
    var bio: String
    
    init(dictionary: [String: Any]) {
        self.name = dictionary["fullname"] as? String ?? ""
        self.age = dictionary["age"] as? Int ?? 0
        self.email = dictionary["email"] as? String ?? ""
        self.profileImageURLs = dictionary["profileImageURLs"] as? [String] ?? [String]()
        self.uid = dictionary["uid"] as? String ?? ""
        self.profession = dictionary["profession"] as? String ?? ""
        self.minSeekingAge = dictionary["minSeekingAge"] as? Int ?? 18
        self.maxSeekingAge = dictionary["maxSeekingAge"] as? Int ?? 64
        self.bio = dictionary["bio"] as? String ?? ""
    }

}
