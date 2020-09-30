//
//  MatchCellViewModel.swift
//  TinderClone
//
//  Created by Vincent Angelo on 24/06/20.
//  Copyright © 2020 Vincent Angelo. All rights reserved.
//

import Foundation

struct MatchCellViewModel {
    
    let nameText: String
    var profileImageURL: URL?
    let uid: String
    
    init(match: Matches) {
        nameText = match.name
        profileImageURL = URL(string: match.profileImageURL)
        uid = match.uid
    }
}
