//
//  ProfileViewModel.swift
//  TinderClone
//
//  Created by Vincent Angelo on 22/06/20.
//  Copyright © 2020 Vincent Angelo. All rights reserved.
//

import Foundation
import UIKit

struct ProfileViewModel {
    private let user: User
    
    let userDetailsAttributedString: NSAttributedString
    
    var imageCount: Int {
        return user.profileImageURLs.count
    }
    
    var imageURLs: [URL] {
        return user.profileImageURLs.map ({ URL(string: $0)!})
    }
    
    let profession: String
    
    let bio: String
    
    init(user: User) {
        self.user = user
        
        let attributedText = NSMutableAttributedString(string: user.name, attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .semibold)])
        attributedText.append(NSAttributedString(string: "  \(user.age)", attributes: [.font: UIFont.systemFont(ofSize: 22)]))
        
        userDetailsAttributedString = attributedText
        
        profession = user.profession
        
        bio = user.bio
    }
}
