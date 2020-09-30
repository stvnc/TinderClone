//
//  CardViewModel.swift
//  TinderClone
//
//  Created by Vincent Angelo on 18/06/20.
//  Copyright © 2020 Vincent Angelo. All rights reserved.
//

import UIKit

class CardViewModel {
    
    let user: User
    
    let userInfoText: NSAttributedString
    
    let imageURLs: [String]
    
    var imageURL: URL?
    
    private var imageIndex = 0
    var index: Int { return imageIndex }
    
    init(user: User) {
        self.user = user
        
        let attributedText = NSMutableAttributedString(string: user.name, attributes: [.font: UIFont.systemFont(ofSize: 32, weight: .heavy), .foregroundColor: UIColor.white])
        attributedText.append(NSAttributedString(string: " \(user.age)", attributes: [.font: UIFont.systemFont(ofSize: 24), .foregroundColor: UIColor.white]))
        
        self.userInfoText = attributedText
        self.imageURLs = user.profileImageURLs
        self.imageURL = URL(string: self.imageURLs[0])
        
//        self.imageURL = URL(string: user.profileImageURL)
    
    }
    
    
    func showNextPhoto(){
        guard imageIndex < user.profileImageURLs.count - 1 else { return }
        imageIndex += 1
        imageURL  = URL(string: imageURLs[imageIndex])
        
    }
    
    func showPreviousPhoto(){
        guard imageIndex > 0 else { return }

        imageIndex -= 1
        imageURL  = URL(string: imageURLs[imageIndex])
    }
}
