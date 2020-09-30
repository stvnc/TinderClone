//
//  MatchViewViewModel.swift
//  TinderClone
//
//  Created by Vincent Angelo on 23/06/20.
//  Copyright © 2020 Vincent Angelo. All rights reserved.
//

import Foundation

struct MatchViewViewModel {
    
    private let currentUser: User
    let matchedUser: User
    
    let matchLabelText: String
    
    var currentUserImageURL: URL?
    var matchedUserImageURL: URL?
    
    init(currentUser: User, matchedUser: User) {
        self.currentUser = currentUser
        self.matchedUser = matchedUser
        
        matchLabelText = "You and \(matchedUser.name) have liked each other!"
        
        guard let imageURLString = currentUser.profileImageURLs.first else { return }
        guard let matchedImageURLString = matchedUser.profileImageURLs.first else { return }
        
        
        
        currentUserImageURL = URL(string: imageURLString)
        matchedUserImageURL = URL(string: matchedImageURLString)
    }
}
